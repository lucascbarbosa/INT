import sys
import numpy as np

from sfepy.base.base import IndexedStruct
from sfepy.discrete import (FieldVariable, Material, Integral, Function,
                            Equation, Equations, Problem)
from sfepy.discrete.fem import Mesh, FEDomain, Field
from sfepy.terms import Term
from sfepy.discrete.conditions import Conditions, EssentialBC
from sfepy.solvers.ls import ScipyDirect
from sfepy.solvers.nls import Newton
from sfepy.mechanics.matcoefs import stiffness_from_lame, stiffness_from_youngpoisson
from sfepy.base.base import Struct
from sfepy.mechanics.tensors import get_von_mises_stress
from sfepy.discrete.common.extmods.cmesh import CMesh
# from sfepy.postprocess.viewer import Viewer

def get_stress(out, pb, state, extend=False):
    """
    Calculate and output strain and stress for given displacements.
    """
    ev = pb.evaluate
    strain = ev('ev_cauchy_strain.1.Omega(u)', mode='el_avg')
    out['cauchy_strain'] = Struct(name='output_data', mode='cell',data=strain, dofs=None)
    stress = ev('ev_cauchy_stress.1.Omega(solid.D, u)', mode='el_avg', solid=solid)
    out['cauchy_stress'] = Struct(name='output_data', mode='cell', data=stress)
    vms = get_von_mises_stress(stress.squeeze())
    vms.shape = (vms.shape[0], 1, 1, 1)
    out['von_mises_stress'] = Struct(name='output_data', mode='cell',data=vms)
    return out, vms.mean()

def get_disp(u):
    return (np.linalg.norm(u,axis=1).max()-np.linalg.norm(u,axis=1).min())

def get_young_arrange(stress,dimensions,u):
    length = dimensions[1]
    # area = dimensions[0]*dimensions[2]
    # stress = abs(float(load/area))
    strain = float(u/length)
    E = stress/strain
    return E

def get_reaction_force(disps):
    reaction_forces = pb.evaluator.eval_residual(disps)
    reaction_forces.shape = (int(reaction_forces.shape[0]/3),3)
    reaction_force = reaction_forces[:,1].max()
    print(reaction_forces[:,1].max())
    return reaction_force

# Titanium
YOUNG = 100e9 #GPa
POISSON = 0.3
# LOAD = -1000.0
DISP = 0.1

# Mesh
filename = r'C:\Users\lucas\Documents\GitHub\INT\Manufatura Aditiva\Simulacao-GAN\Dados\2- 3D_models\00001_porosity_0.4531_3d.vtk'
mesh = Mesh.from_file(filename)

#Domain and regions
domain = FEDomain('domain', mesh)

min_x, max_x = domain.get_mesh_bounding_box()[:,0]
min_y, max_y = domain.get_mesh_bounding_box()[:,1]
min_z, max_z = domain.get_mesh_bounding_box()[:,1]

DIMENSIONS = (max_x-min_x,max_y-min_y,max_z-min_z)

eps_x = 1e-5*(max_x-min_x)
eps_y = 1e-5*(max_y-min_y)

omega = domain.create_region("Omega",'all')
bot = domain.create_region("bot", 
                                'vertices in y < %.10f'%(min_y+eps_y), 
                                'facet')

top = domain.create_region("top", 
                                'vertices in y > %.10f'%(max_y-eps_y), 
                                'facet')

# FE approx
field = Field.from_args('fu', np.float64, 'vector', omega, approx_order=1)

# Variables
u = FieldVariable('u','unknown', field)
v = FieldVariable('v', 'test', field, primary_var_name='u')

# Material properties
D = stiffness_from_youngpoisson(3,YOUNG,POISSON)
solid = Material('solid', D=D,)
f = Material('f',val=[[0.0],[0.0], [0.0]])

# define quadrature order
integral = Integral('i', order=1)

# define terms and build equations
t1 = Term.new('dw_lin_elastic(solid.D, v, u)',
                integral, omega, solid=solid, v=v, u=u)
t2 = Term.new('dw_volume_lvf(f.val, v)', integral, omega, f=f, v=v)
eq = Equation('balance', t1 + t2)
eqs = Equations([eq])

fix_bot = EssentialBC('fix_bot', bot, {'u.all' : 0.0})
# fix_xz = EssentialBC('fix_xz', omega, {'u.[0,2]' : 0.0})

shift_u = EssentialBC('shift_u', top, {'u.1' : DISP})

ls = ScipyDirect({})

nls_status = IndexedStruct()
nls = Newton({}, lin_solver=ls, status=nls_status)

pb = Problem('elasticity', equations=eqs)


pb.save_regions_as_groups('regions')

pb.set_bcs(ebcs=Conditions([fix_bot,shift_u]))

pb.set_solver(nls)

status = IndexedStruct()
state = pb.solve(status=status)

# print('Nonlinear solver status:\n', nls_status)
# print('Stationary solver status:\n', status)

out = state.create_output_dict()
out,vms = get_stress(out, pb, state, extend=True)
# u_tensor = state()
# u_tensor = u_tensor.reshape((int(u_tensor.shape[0]/3),3))
# disp = get_disp(u_tensor)

E = get_young_arrange(vms,DIMENSIONS,DISP)
print(f'E = {E}')

# visualize deformation
# view = Viewer('linear_elasticity.vtk',output_dir='output/')
# view(vector_mode='warp_norm', rel_scaling=1e7, is_scalar_bar=True, is_wireframe=False)

pb.save_state('linear_elasticity.vtk', out=out)