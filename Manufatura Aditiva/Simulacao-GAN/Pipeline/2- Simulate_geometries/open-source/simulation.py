import os
import numpy as np
from numpy.core.numeric import array_equal
from numpy.lib import index_tricks
from src.simulate_2d import Simulate2D
from src.simulate_3d import Simulate3D
from src.preproc import preproc
import time
from multiprocessing import Process, freeze_support, Array
import sys

def simulation(simmetry, score, vtk_dir, array_dir, log_dir, idx_array, idx_file, Es, idx, origin, dimension):

    stl_filename, vtk_filename = preproc(
        vtk_dir, array_dir, log_dir, score, idx_array, idx_file, simmetry, origin, dimension)

    # Titanium
    YOUNG = 100e9  # GPa
    POISSON = 0.3
    RHO = 4500

    ORDER = 1
    STRESS = -100

    if dimension == 2:
        sim = Simulate2D()
        plane = 'stress'
    if dimension == 3:
        sim = Simulate3D()
        plane = 'strain'

    log_dir = log_dir + array_dir 
    log_filename = stl_filename.split('/')[-1][:-4] + '.txt'
    sim.setup_log(log_dir,log_filename)

    print(vtk_filename)
    mesh = sim.get_mesh(vtk_filename)
    dimensions, omega, top, bot = sim.create_regions(mesh)
    field, u, v = sim.create_field_variables(omega, ORDER)
    integral = sim.define_integral(ORDER)
    area = sim.get_area(integral, top, u)
    solid, f = sim.define_material(YOUNG, POISSON, RHO, STRESS, dimension, plane)
    t1, t2, eqs = sim.define_terms(solid, f, u, v, integral, top, omega)
    fix_bot = sim.set_bcs(bot, top)
    bcs = [fix_bot]
    pb, out, E, disp = sim.solve_problem(field, eqs, bcs, dimensions, STRESS, dimension, vtk_filename)

    Es[idx] = float(E/1e9)

    print('\nFor %s: E = %fe9 and u =%.4fe-9' %(stl_filename, float(E/1e9), disp/1e-9))


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
            
        arrays_dir = ['%05d/' % (i+1) for i in range(start, end+1)]
        geometries_filename = os.listdir(geometries_dir)
        rounds = int(2*size/max_processes)

        if 2*size % max_processes != 0:
            rounds += 1

        start_time = time.time()
        process_count = 0
        for r in range(rounds):
            Es = Array('f', max_processes)
            processes = []

            freeze_support()

            for p in range(max_processes):

                idx_array = int(process_count/2)
                idx_file = process_count % 2
                try:
                    array_dir = arrays_dir[idx_array]
                except:
                    break

                process = Process(target=simulation, args=(
                    simmetry, score, vtk_dir, array_dir, log_dir, start+idx_array, idx_file, Es, p, origin, dimension,))
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
            log_dir = 'E:/Lucas GAN/Dados/6- Simulation_logs/GAN/%sD/%s/' % (dimension, simmetry)
        else:
            max_processes = 14
            geometries_dir = 'D:/Lucas GAN/Dados/1- Arranged_geometries/GAN/%s/%s/' % (simmetry, score)
            vtk_dir = 'D:/Lucas GAN/Dados/2- Geometry_models/GAN/%sD/%s/%s/' % (dimension, simmetry, score)
            young_dir = 'D:/Lucas GAN/Dados/3- Mechanical_properties/young/GAN/%sD/%s/%s/' % (dimension, simmetry, score)
            log_dir = 'D:/Lucas GAN/Dados/6- Simulation_logs/GAN/%sD/%s/' % (dimension, simmetry)

        arrays_dir = ['%05d/' % (i+1) for i in range(start, end+1)]

        geometries_filename = os.listdir(geometries_dir)
        rounds = int(2*size/max_processes)

        if size % max_processes != 0:
            rounds += 1

        start_time = time.time()
        process_count = 0

        for r in range(rounds):
            Es = Array('f', max_processes)
            processes = []

            freeze_support()

            for p in range(max_processes):

                idx_array = int(process_count/2)
                idx_file = process_count % 2
                try:
                    array_dir = arrays_dir[idx_array]
                except:
                    break

                process = Process(target=simulation, args=(
                    simmetry, score, vtk_dir, array_dir, log_dir, start+idx_array, idx_file, Es, p, origin, dimension,))
                processes.append(process)
                process.start()
                process_count += 1

            for process in processes:
                process.join()

            for i in range(0, len(Es[:]), 2):
                Es_geometry = Es[i:i+2]
                for j in range(len(Es_geometry)):
                    Es_geometry[j] = str(Es_geometry[j])+'e+9'
                filename = geometries_filename[int(i/2)+start+r*int(max_processes/2)]
                print(filename)
                np.savetxt(young_dir+filename, Es_geometry,delimiter='\n', fmt='%s')

        end_time = time.time()
        print('Elapsed time = %.2f' % (end_time-start_time))
