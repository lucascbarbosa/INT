import os 
from src.simulate import Simulate
from src.preproc import preproc
import time
from multiprocessing import Process, freeze_support




if __name__ == '__main__':
    stl_dir = r'C:\Users\lucas\Documents\GitHub\INT\Manufatura Aditiva\Simulacao-GAN\Dados\2- 3D_models\stl'
    vtk_dir = r'C:\Users\lucas\Documents\GitHub\INT\Manufatura Aditiva\Simulacao-GAN\Dados\2- 3D_models\vtk'

    max_idx = 5

    start = time.time()

    processes = []

    freeze_support()

    for array_dir in os.listdir(stl_dir)[:1]:

        if not os.path.exists((os.path.join(vtk_dir,array_dir))):
            os.mkdir(os.path.join(vtk_dir,array_dir))
        for stl_filename in os.listdir(os.path.join(stl_dir,array_dir))[:max_idx]:
            vtk_filename = stl_filename[:-4]+'.vtk'
            # preproc(os.path.join(stl_dir,array_dir,stl_filename),os.path.join(vtk_dir,array_dir,vtk_filename))
            process = Process(target=preproc, args=(os.path.join(stl_dir,array_dir,stl_filename),os.path.join(vtk_dir,array_dir,vtk_filename),))
            processes.append(process)
            process.start()

        # Titanium
        YOUNG = 100e9 #GPa
        POISSON = 0.3
        DISP = 0.1
        ORDER = 1

        # sim = Simulate()
        # mesh = sim.get_mesh(os.path.join(vtk_dir,array_dir,vtk_filename))
        # dimensions,omega,top,bot = sim.create_regions(mesh)
        # field,u,v = sim.create_field_variables(omega, ORDER)
        # solid,f = sim.define_material(YOUNG, POISSON)
        # integral = sim.define_integral(ORDER)
        # t1,t2,eqs = sim.define_terms(solid, f, u, v, integral, omega)
        # fix_bot,shift_u = sim.set_bcs(bot,top,DISP)
        # pb,out,vms,E = sim.solve_problem(eqs, fix_bot, shift_u, dimensions, solid, DISP)

    for process in processes:
        process.join()

    end = time.time()

    print('Elapsed time = %.2f'%(end-start))