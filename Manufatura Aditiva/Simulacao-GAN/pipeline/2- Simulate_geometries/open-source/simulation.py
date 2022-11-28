import os
import numpy as np
from numpy.core.numeric import array_equal
from numpy.lib import index_tricks
from src.simulate_2d import Simulate2D
# from src.simulate_3d import Simulate3D
from src.preproc import preproc
import time
from multiprocessing import Process, freeze_support, Array
import sys
import warnings
warnings.filterwarnings("ignore")

def simulation(dimension, simmetry, vtk_dir, array_dir, log_dir, idx_array, idx_file, Es, idx, origin, score):

    vtk_filename = preproc(
        vtk_dir, array_dir, idx_array, idx_file, origin, simmetry, dimension, score
        )

    # Titanium
    YOUNG = 0.95e9  # GPa
    POISSON = 0.35
    RHO = 700  # kg/m³

    ORDER = 1
    THICKNESS = 2.5e-3 # m
    ARRANGE_SIZE = 48e-3 # m
    STRESS = -100.0/(THICKNESS*ARRANGE_SIZE) # N/m²

    if dimension == 2:
        sim = Simulate2D()
        plane = 'stress'
    if dimension == 3:
        sim = Simulate3D()
        plane = 'strain'

    log_filename = vtk_filename.split('/')[-1][:-4] + '.txt'
    sim.quiet_log()
    start_sim = time.time()
    mesh, geom, cells, verts = sim.get_mesh(vtk_filename)
    dimensions, omega, top, bot = sim.create_regions(mesh)
    field, u, v = sim.create_field_variables(omega, ORDER)
    integral = sim.define_integral(ORDER)
    area = sim.get_area(integral, top, u)
    solid, f = sim.define_material(YOUNG, POISSON, RHO, STRESS, dimension, plane)
    t1, t2, eqs = sim.define_terms(solid, f, u, v, integral, top, omega)
    fix_bot = sim.set_bcs(bot, top)
    bcs = [fix_bot]
    pb, out, E, disp, dofs = sim.solve_problem(field, eqs, bcs, dimensions, STRESS, dimension, vtk_filename)
    end_sim = time.time()
    sim_time = np.round(end_sim - start_sim,2)
    Es[idx] = float(E/1e9)

    sim.log(log_dir, array_dir, log_filename, sim_time, geom, cells, verts, dofs)
    
    print('\nFor %s: E = %fe9 and u =%.4fe-3' %(vtk_filename, float(E/1e9), disp/1e-3))

def get_idx_model(geometries_dir, models_filename, idx_array):
    count = 0
    for i in range(len(models_filename)):
        model_filename = models_filename[i]
        geometries_model = len(os.listdir(geometries_dir+model_filename[:-3]+'/'))
        if count+ geometries_model <= idx_array:
            count += geometries_model
        else:
            break

    return i, idx_array - count

if __name__ == '__main__':

    dimension = int(sys.argv[1])
    origin = str(sys.argv[2])
    simmetry = str(sys.argv[3])
    start = int(sys.argv[4])-1
    end = int(sys.argv[5])-1

    if origin == "-r":
        score = None

    if origin == "-g":
        score = str(sys.argv[6])

    size = end-start+1

    if origin == "-r":
        if os.getcwd().split('\\')[2] == 'lucas':
            max_processes = 2
            geometries_dir = 'E:/Lucas GAN/Dados/1- Arranged_geometries/RTGA/%s/' % simmetry
            vtk_dir = 'E:/Lucas GAN/Dados/2- Geometry_models/RTGA/%sD/%s/' % (dimension, simmetry)
            young_dir = 'E:/Lucas GAN/Dados/3- Mechanical_properties/young/RTGA/%sD/%s/' % (dimension, simmetry)
            log_dir = 'E:/Lucas GAN/Dados/6- Simulation_logs/RTGA/%sD/%s/' % (dimension, simmetry)
        else:
            max_processes = 14
            geometries_dir = 'D:/Lucas GAN/Dados/1- Arranged_geometries/RTGA/%s/' % simmetry
            vtk_dir = 'D:/Lucas GAN/Dados/2- Geometry_models/RTGA/%sD/%s/' % (dimension, simmetry)
            young_dir = 'D:/Lucas GAN/Dados/3- Mechanical_properties/young/RTGA/%sD/%s/' % (dimension, simmetry)
            log_dir = 'D:/Lucas GAN/Dados/6- Simulation_logs/RTGA/%sD/%s/' % (dimension, simmetry)
            
        geometries_filename = os.listdir(geometries_dir)
        rounds = int(2*size/max_processes)

        if 2*size % max_processes != 0:
            rounds += 1

        start_time = time.time()
        process_count = start
        
        for r in range(rounds):
            Es = Array('f', max_processes)
            processes = []

            freeze_support()

            for p in range(max_processes):

                idx_array = int((process_count + start)/2)
                idx_file = process_count % 2
                try:
                    array_dir = '%05d/' % (idx_array+1)
                except:
                    break

                process = Process(target=simulation, args=(
                    dimension, simmetry, vtk_dir, array_dir, log_dir, start+idx_array, idx_file, Es, p, origin, score,))
                processes.append(process)
                process.start()
                process_count += 1

            for process in processes:
                process.join()

            for i in range(0, len(Es[:]), 2):
                Es_geometry = Es[i:i+2]
                for j in range(len(Es_geometry)):
                    Es_geometry[j] = str(Es_geometry[j])+'e+9'
                filename = geometries_filename[int(
                    i/2)+start+r*int(max_processes/2)]
                np.savetxt(young_dir+'/'+filename, Es_geometry,
                           delimiter='\n', fmt='%s')

        end_time = time.time()
        print('Elapsed time = %.2f' % (end_time-start_time))

    if origin == "-g":
        if os.getcwd().split('\\')[2] == 'lucas':
            max_processes = 2
            geometries_dir = 'E:/Lucas GAN/Dados/1- Arranged_geometries/GAN/%s/%s/' % (simmetry, score)
            vtk_dir = 'E:/Lucas GAN/Dados/2- Geometry_models/GAN/%sD/%s/%s/' % (dimension, simmetry, score)
            young_dir = 'E:/Lucas GAN/Dados/3- Mechanical_properties/young/GAN/%sD/%s/%s/' % (dimension, simmetry, score)
            models_dir = 'E:/Lucas GAN/Dados/5- GAN_models/%sD/%s/%s/'%(dimension,simmetry,score)
            log_dir = 'E:/Lucas GAN/Dados/6- Simulation_logs/GAN/%sD/%s/' % (dimension, simmetry)
        else:
            max_processes = 14
            geometries_dir = 'D:/Lucas GAN/Dados/1- Arranged_geometries/GAN/%s/%s/' % (simmetry, score)
            vtk_dir = 'D:/Lucas GAN/Dados/2- Geometry_models/GAN/%sD/%s/%s/' % (dimension, simmetry, score)
            young_dir = 'D:/Lucas GAN/Dados/3- Mechanical_properties/young/GAN/%sD/%s/%s/' % (dimension, simmetry, score)
            models_dir = 'D:/Lucas GAN/Dados/5- GAN_models/%sD/%s/%s/'%(dimension,simmetry,score)
            log_dir = 'D:/Lucas GAN/Dados/6- Simulation_logs/GAN/%sD/%s/' % (dimension, simmetry)
        
        models_filename = os.listdir(models_dir)
        geometries_filename = os.listdir(geometries_dir)
        rounds = int(2*size/max_processes)

        if 2*size % max_processes != 0:
            rounds += 1

        start_time = time.time()
        process_count = start

        for r in range(rounds):
            Es = Array('f', max_processes)
            processes = []

            freeze_support()

            for p in range(max_processes):

                idx_array = int((process_count + start)/2)
                idx_file = process_count % 2
                
                try:
                    array_dir = '%05d/' % (idx_array+1)
                except:
                    break
                
                process = Process(target=simulation, args=(
                    dimension, simmetry, vtk_dir, array_dir, log_dir, idx_array, idx_file, Es, p, origin, score,))
                processes.append(process)
                process.start()
                process_count += 1

            for process in processes:
                process.join()

            for i in range(0, len(Es[:]), 2):
                Es_geometry = Es[i:i+2]
                for j in range(len(Es_geometry)):
                    Es_geometry[j] = str(Es_geometry[j])+'e+9'
                geometries_filename = os.listdir(geometries_dir)
                filename = geometries_filename[r+start]
                np.savetxt(young_dir + filename, Es_geometry,delimiter='\n', fmt='%s')

        end_time = time.time()
        print('Elapsed time = %.2f' % (end_time-start_time))
