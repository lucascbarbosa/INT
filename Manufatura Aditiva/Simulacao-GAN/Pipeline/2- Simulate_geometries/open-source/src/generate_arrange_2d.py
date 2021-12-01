import meshio
import pygmsh
import numpy as np
import os
import sys
from math import log, sqrt
import matplotlib.pyplot as plt

def idx2coord(i,j,k,l):
    loc_y = np.round(element_size - (i+0.5)*pixel_size,5)
    loc_x = np.round((j+0.5)*pixel_size - element_size,5)
    
    locs_element_x = [loc_x,loc_y,-loc_x,-loc_y]
    locs_element_y = [loc_y,-loc_x,-loc_y,loc_x]
    element_idx = k*2 + l
    loc_x = locs_element_x[element_idx]
    loc_y = locs_element_y[element_idx]
    
    return loc_x,loc_y

def generate_mesh(filename):
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
        void_pixels = []
        for k in range(elements_per_unit): #row of element
            for l in range(elements_per_unit): #column of element
                for i in range(len(array)): #row of pixel
                    for j in range(len(array)): #column of pixel
                        if array[i,j] == 0:
                            loc_x,loc_y = idx2coord(i,j,k,l)
                            void_pixel = geom.add_polygon([[loc_x-pixel_size/2.,loc_y-pixel_size/2.],[loc_x+pixel_size/2.,loc_y-pixel_size/2.],[loc_x+pixel_size/2.,loc_y+pixel_size/2.],[loc_x-pixel_size/2.,loc_y+pixel_size/2.]],mesh_size=5e-4)
                            void_pixels.append(void_pixel)

        units = []
                
        unit = geom.boolean_difference(unit, geom.boolean_union(void_pixels))
        units.append(unit[0])
        
        for i in range(units_per_arrange):
            for j in range(units_per_arrange):
                if [i,j] != [int(units_per_arrange/2),int(units_per_arrange/2)]:
                    unit_ = geom.copy(unit[0])
                    geom.translate(unit_,[(j-1)*unit_size*0.998,(1-i)*unit_size*0.998,0])
                    units.append(unit_)
        
        arrange = geom.boolean_union(units) 

        # field0 = geom.add_boundary_layer(
        # edges_list=[arrange[0].curves[0]],
        # distmin=0.0,
        # distmax=pixel_size*sqrt(2),
        # )
        # field1 = geom.add_boundary_layer(
        #     nodes_list=[arrange[0].points[2]],
        #     distmin=0.0,
        #     distmax=2*pixel_size*sqrt(2),
        # )
        # geom.set_background_mesh([field0, field1], operator="Min")

        geom.set_mesh_size_callback(
            lambda dim, tag, x, y, z: pixel_size
        )

        mesh = geom.generate_mesh()
        mesh.write(filename)
        
        end = time.time()


# //////////////////////////////////////////////////////////////

origin = sys.argv[1]
simmetry = sys.argv[2]
idx = int(sys.argv[3])
theta = int(sys.argv[4])

if origin == "-g":
    arrays_dir = r"D:/Lucas GAN/Dados/1- Arranged_geometries/Arrays/GAN/"+simmetry+'/'
    vtks_dir = r"D:/Lucas GAN/Dados/2- Models/GAN/2D/"+simmetry+'/'
else:
    arrays_dir = r"D:/Lucas GAN/Dados/1- Arranged_geometries/Arrays/RTGA/"+simmetry+'/'
    vtks_dir = r"D:/Lucas GAN/Dados/2- Models/RTGA/2D/"+simmetry+'/'


arrays_filename = os.listdir(arrays_dir)

units_per_arrange = 3
elements_per_unit = 2
resolution = 16.
thickness =  2.5e-3 # m

arrange_size = 48e-3 # m
unit_size = float(arrange_size/units_per_arrange) # m
element_size = float(unit_size/elements_per_unit) # m
pixel_size = float(element_size/resolution)
mag = int(log(len(arrays_filename),10)+3)

for array_filename in arrays_filename[idx:idx+1]:
    with open(os.path.join(arrays_dir,array_filename),'r') as f:
        array_dir = array_filename.split('_')[0]
        try:
            os.mkdir(vtks_dir+array_dir)
        except:
            pass
        array = np.array(f.readlines()).astype(float)
        array = array.reshape((int(resolution),int(resolution)))
        filename = vtks_dir+array_dir+'/'+array_filename[mag:-4]+"_theta_%d.vtk"%theta
        generate_mesh(filename)