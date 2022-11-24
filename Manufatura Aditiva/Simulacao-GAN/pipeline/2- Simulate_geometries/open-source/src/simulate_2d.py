import sys
import os
import numpy as np
from numpy.lib.ufunclike import fix

from sfepy.base.base import IndexedStruct, output
from sfepy.discrete import (FieldVariable, Material, Integral, Function,
                            Equation, Equations, Problem)
from sfepy.discrete.fem import Mesh, FEDomain, Field
from sfepy.terms import Term
from sfepy.discrete.conditions import Conditions, EssentialBC
from sfepy.solvers.ls import ScipyDirect
from sfepy.solvers.auto_fallback import AutoDirect
from sfepy.solvers.nls import Newton
from sfepy.mechanics.matcoefs import stiffness_from_lame, stiffness_from_youngpoisson
from sfepy.base.base import Struct
from sfepy.mechanics.tensors import get_von_mises_stress
from sfepy.discrete.common.extmods.cmesh import CMesh
# from sfepy.postprocess.viewer import Viewer
from sfepy.base.base import output
class Simulate2D(object):
    def __init__(self):
        pass

    def quiet_log(self):
        output.set_output(quiet=True, combined= False)

    def log(self, log_dir, model_filename, array_dir, log_filename, time, geom, cells, verts, dofs):
        if not os.path.isdir(log_dir + model_filename + '/'):
            os.mkdir(log_dir + model_filename + '/')
        if not os.path.isdir(log_dir + model_filename + '/' + array_dir):
            os.mkdir(log_dir + model_filename + '/' + array_dir)

        log = f'cells ({geom}): {cells}\nverts: {verts}\nDOFS: {dofs}\ntime: {time}'
        with open(log_dir + model_filename + '/' + array_dir + log_filename,'w') as f:
            f.write(log)
        
    def get_stress(self, out, pb, state, solid, extend=False):
        """
        Calculate and output strain and stress for given displacements.
        """
        ev = pb.evaluate
        strain = ev('ev_cauchy_strain.1.Omega(u)', mode='el_avg')
        out['cauchy_strain'] = Struct(
            name='output_data', mode='cell', data=strain, dofs=None)
        stress = ev('ev_cauchy_stress.1.Omega(solid.D, u)',
                    mode='el_avg', solid=solid)
        out['cauchy_stress'] = Struct(
            name='output_data', mode='cell', data=stress)
        vms = get_von_mises_stress(stress.squeeze())
        vms.shape = (vms.shape[0], 1, 1, 1)
        out['von_mises_stress'] = Struct(
            name='output_data', mode='cell', data=vms)
        return out, vms.mean()

    def get_young_arrange(self, stress, dimensions, disp):
        length = dimensions[1]
        strain = float(disp/length)
        E = abs(stress/strain)
        return E

    def get_mesh(self, filename):
        mesh = Mesh.from_file(filename)
        cells = mesh.n_el
        verts = mesh.n_nod
        geom = mesh.descs[0]
        return mesh, geom, cells, verts
    
    def get_top_coors(self, mesh, tol=1e-5):
        domain = FEDomain('domain', mesh)
        min_x, max_x = domain.get_mesh_bounding_box()[:, 0]
        min_y, max_y = domain.get_mesh_bounding_box()[:, 1]
        # eps_y = tol*(max_y-min_y)
        return max_y
    
    def create_regions(self, mesh, tol=1e-5):
        domain = FEDomain('domain', mesh)

        min_x, max_x = domain.get_mesh_bounding_box()[:, 0]
        min_y, max_y = domain.get_mesh_bounding_box()[:, 1]

        dimensions = (max_x-min_x, max_y-min_y)

        eps_x = tol*(max_x-min_x)
        eps_y = tol*(max_y-min_y)

        omega = domain.create_region("Omega", 'all')

        bot = domain.create_region('bot',
                                   'vertices in y < %.10f' % (min_y+eps_y),
                                   'facet')

        top = domain.create_region('top',
                                   'vertices in y > %.10f' % (max_y-eps_y),
                                   'facet')
        return dimensions, omega, top, bot

    def create_field_variables(self, omega, order):
        # FE approx
        field = Field.from_args(
            'fu', np.float64, 'vector', omega, approx_order=order)

        # Variables
        u = FieldVariable('u', 'unknown', field)
        v = FieldVariable('v', 'test', field, primary_var_name='u')
        return field, u, v

    def define_integral(self, order):
        integral = Integral('i', order=order)
        return integral

    def define_material(self, young, poisson, rho, stress, dim, plane):
        D = stiffness_from_youngpoisson(dim, young, poisson, plane=plane)
        solid = Material('solid', kind='stationary', D=D,rho=rho)
        f = Material('f', kind='stationary', val=stress)
        return solid, f

    def define_terms(self, solid, f, u, v, integral, top, omega):

        t1 = Term.new('dw_lin_elastic(solid.D, v, u)',
                      integral, omega, solid=solid, v=v, u=u)
        t2 = Term.new('dw_surface_ltr(f.val, v)', integral, top, f=f, v=v)
        eq = Equation('balance', t1 + t2)
        eqs = Equations([eq])

        return t1, t2, eqs

    def get_area(self, integral, top, u):
        ta = Term.new('d_surface(u)', integral, top, u=u)
        ta.setup()
        area = ta.evaluate()
        return area

    def get_disp(self, pb, field, u):
        ii = field.get_dofs_in_region(pb.domain.regions['top'])
        disp = np.mean(u[ii,1])
        return disp

    def set_bcs(self, bot, top):
        fix_bot = EssentialBC('fix_bot', bot, {'u.all': 0.0})

        # shift_u = EssentialBC('shift_u', top, {'u.1' : disp})

        return fix_bot

    def solve_problem(self, field, eqs, bcs, dimensions, stress, dim, vtk_filename):
        ls = ScipyDirect({})

        nls_status = IndexedStruct()
        nls = Newton({}, lin_solver=ls, status=nls_status)

        pb = Problem('elasticity', equations=eqs)

        pb.save_regions_as_groups('regions')

        pb.set_bcs(ebcs=Conditions(bcs))

        pb.set_solver(nls)

        status = IndexedStruct()
        state = pb.solve(status=status)

        # print('Nonlinear solver status:\n', nls_status)
        # print('Stationary solver status:\n', status)

        out = state.create_output_dict()

        # out,vms = self.get_stress(out, pb, state, solid, extend=True)
        
        u_tensor = state().reshape(-1, dim)
        disp = self.get_disp(pb, field, u_tensor)

        E = self.get_young_arrange(stress, dimensions, disp)
        pb.save_state(vtk_filename, out=out)

        variables = pb.get_variables()
        dofs =  variables.di.n_dof['u']

        # visualize deformation
        # view = Viewer('linear_elasticity_%f.vtk'%E)
        # view(vector_mode='warp_norm', rel_scaling=1e-10, is_scalar_bar=True, is_wireframe=False)

        return pb, out, E, disp, dofs


# if __name__ == "__main__":

#     YOUNG = 100e9  # GPa
#     POISSON = 0.3
#     RHO = 4500

#     ORDER = 1
#     STRESS = 2*(-100)
#     dimension = 2

#     sim = Simulate2D()
#     vtk_filename = 'porosity_0.5273_theta_0.vtk'
#     mesh = sim.get_mesh(vtk_filename)
#     dimensions, omega, top, bot = sim.create_regions(mesh)
#     field, u, v = sim.create_field_variables(omega, ORDER)
#     integral = sim.define_integral(ORDER)
#     area = sim.get_area(integral, top, u)
#     solid, f = sim.define_material(YOUNG, POISSON, RHO, STRESS,dimension)
#     t1, t2, eqs = sim.define_terms(solid, f, u, v, integral, top, omega)
#     fix_bot = sim.set_bcs(bot, top)
#     bcs = [fix_bot]
#     pb, out, E, disp = sim.solve_problem(eqs, bcs, dimensions, solid, STRESS, dimension, vtk_filename)
