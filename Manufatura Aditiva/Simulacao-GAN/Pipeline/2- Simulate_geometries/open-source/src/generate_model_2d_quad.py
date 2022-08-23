import meshio
import pygmsh
import numpy as np
import os
import sys
from math import log, sqrt
import matplotlib.pyplot as plt
import time
import warnings
warnings.filterwarnings('ignore')

def idx2coord(simmetry,i,j,k,l):
    if simmetry == 'p4':
        loc_y = np.round(-(i+0.5)*pixel_size,5)
        loc_x = np.round((j+0.5)*pixel_size - element_size,5)
        
        locs_element_x = [loc_x,loc_y,-loc_x,-loc_y]
        locs_element_y = [loc_y,-loc_x,-loc_y,loc_x]
        element_idx = k*2 + l
        loc_x = locs_element_x[element_idx]
        loc_y = locs_element_y[element_idx]
    
    if simmetry in ['p4m', 'p4g']:
        loc_y = np.round(-(i+0.5)*pixel_size,5)
        loc_x = np.round((j+0.5)*pixel_size - element_size,5)
        
        locs_element_x = [loc_x,loc_x,-loc_x,-loc_x]
        locs_element_y = [loc_y,-loc_y,-loc_y,loc_y]
        element_idx = k*2 + l
        loc_x = locs_element_x[element_idx]
        loc_y = locs_element_y[element_idx]

    return loc_x,loc_y

def generate_mesh(simmetry, filename):
    with pygmsh.occ.Geometry()  as geom:
        unit = geom.add_polygon(
            [
                [-unit_size/2.+1e-5, -unit_size/2.+1e-5],
                [unit_size/2.-1e-5, -unit_size/2.+1e-5],
                [unit_size/2.-1e-5, unit_size/2.-1e-5],
                [-unit_size/2.+1e-5, unit_size/2.-1e-5],
            ],
            mesh_size=5e-4,
        )

        # generate unit with specific simmetry
        void_pixels = []
        for k in range(elements_per_row): #row of element
            for l in range(elements_per_row): #column of element
                for i in range(len(array)): #row of pixel
                    for j in range(len(array)): #column of pixel
                        if array[i,j] == 0:
                            loc_x,loc_y = idx2coord(simmetry,i,j,k,l)
                            void_pixel = geom.add_polygon([[loc_x-pixel_size/2.,loc_y-pixel_size/2.],[loc_x+pixel_size/2.,loc_y-pixel_size/2.],[loc_x+pixel_size/2.,loc_y+pixel_size/2.],[loc_x-pixel_size/2.,loc_y+pixel_size/2.]],mesh_size=5e-4)
                            void_pixels.append(void_pixel)

        units = []
                
        unit = geom.boolean_difference(unit, geom.boolean_union(void_pixels))
        units.append(unit[0])
        
        for i in range(units_per_row+2):
            for j in range(units_per_row+2):
                if [i,j] != [int(units_per_row/2),int(units_per_row/2)]:
                    unit_ = geom.copy(unit[0])
                    geom.translate(unit_,[(j-1)*unit_size*0.998,(1-i)*unit_size*0.998,0])
                    units.append(unit_)

        arrange = geom.boolean_union(units)

        geom.translate(arrange[0],[-unit_size,unit_size,0])
        
        geom.rotate(arrange[0],[0.,0.,0.],np.deg2rad(theta),[0.,0.,1.])

        filter_out = geom.add_disk([0.0, 0.0], 0.06, mesh_size=5e-4)

        filter_in = geom.add_polygon(
            [
                [-arrange_size/2+1e-4, -arrange_size/2+1e-4],
                [arrange_size/2-1e-4, -arrange_size/2+1e-4],
                [arrange_size/2-1e-4, arrange_size/2-1e-4],
                [-arrange_size/2+1e-4, arrange_size/2-1e-4],
            ],
            mesh_size=5e-4,
        )

        filter_boolean = geom.boolean_difference(filter_out,filter_in)

        arrange = geom.boolean_difference(arrange, filter_boolean)

        handle_top = geom.add_polygon(
            [
                [-arrange_size/2.+1.1e-4, arrange_size/2.-1.1e-4],
                [arrange_size/2.-1.1e-4, arrange_size/2.-1.1e-4],
                [arrange_size/2.-1.1e-4, 3*arrange_size/4.],
                [-arrange_size/2.+1.1e-4, 3*arrange_size/4.],
            ],
            mesh_size=5e-4,
        )
        
        handle_bot = geom.copy(handle_top)
        geom.translate(handle_bot,[0,-5*arrange_size*0.998/4,0])

        geom.boolean_union([arrange,handle_bot,handle_top])
        
        geom.set_mesh_size_callback(
            lambda dim, tag, x, y, z: pixel_size
        )

        mesh = geom.generate_mesh()
        mesh.write(filename)
        # end = time.time()

        # print(f'Elapsed time: {end-start} s')
# //////////////////////////////////////////////////////////////

origin = sys.argv[1]
simmetry = sys.argv[2]
units = int(sys.argv[3])
size = int(sys.argv[4])
idx = int(sys.argv[5])-1
theta = int(sys.argv[6])

if origin == "-g":
    score = sys.argv[7]
    if os.getcwd().split('\\')[2] == 'lucas':
        arrays_dir = "E:/Lucas GAN/Dados/1- Arranged_geometries/GAN/%s/%s/" % (simmetry, score)
        vtks_dir = "E:/Lucas GAN/Dados/2- Geometry_models/GAN/2D/%s/%s/" % (simmetry, score)
    else:
        arrays_dir = "D:/Lucas GAN/Dados/1- Arranged_geometries/GAN/%s/%s/" % (simmetry, score)
        vtks_dir = "D:/Lucas GAN/Dados/2- Geometry_models/GAN/2D/%s/%s/" % (simmetry, score)
    
else:
    if os.getcwd().split('\\')[2] == 'lucas':
        arrays_dir = "E:/Lucas GAN/Dados/1- Arranged_geometries/RTGA/%s/" % simmetry
        vtks_dir = "E:/Lucas GAN/Dados/2- Geometry_models/RTGA/2D/%s/" % simmetry
    else:
        arrays_dir = "D:/Lucas GAN/Dados/1- Arranged_geometries/RTGA/%s/" % simmetry
        vtks_dir = "D:/Lucas GAN/Dados/2- Geometry_models/RTGA/2D/%s/" % simmetry

arrays_filename = os.listdir(arrays_dir)

units_per_row = int(np.sqrt(units))
elements_per_row = int(np.sqrt(int(simmetry[1])))
thickness =  2.5e-3 # m

arrange_size = 48e-3 # m
unit_size = float(arrange_size/units_per_row) # m
element_size = float(unit_size/elements_per_row) # m
pixel_size = float(element_size/size)

array_filename = arrays_filename[idx+1]

with open(os.path.join(arrays_dir,array_filename),'r') as f:
    array_dir = array_filename.split('_')[0]
    try:
        os.mkdir(vtks_dir+array_dir)
    except:
        pass
    array = np.array(f.readlines()).astype(float)
    size = array[0]
    array = array[1:]
    array = array.reshape((int(size),int(size)))
    array_filename = '_'.join(array_filename.split('_')[1:])[:-4]
    filename = vtks_dir+array_dir+'/'+array_filename+"_theta_%d.vtk"%theta
    generate_mesh(simmetry, filename)