import optimesh
import meshio
import time
import pygmsh
import numpy as np
import os
import sys
from numpy.core.numeric import count_nonzero
from math import radians, cos, sin, log
import matplotlib.pyplot as plt
start = time.time()

def idx2coord(i,j,k,l,m,n):
    loc_y = np.round(element_size - (i+0.5)*pixel_size,5)
    loc_x = np.round((j+0.5)*pixel_size - element_size,5)
    
    locs_element_x = [loc_x,loc_y,-loc_x,-loc_y]
    locs_element_y = [loc_y,-loc_x,-loc_y,loc_x]
    element_idx = k*2+l
    loc_x = locs_element_x[element_idx]
    loc_y = locs_element_y[element_idx]

    loc_x = np.round(loc_x+n*unit_size - arrange_size/3.,5)
    loc_y = np.round(loc_y+m*unit_size + arrange_size/3.,5)
    return loc_x,loc_y

def generate_mesh(filename):
    with pygmsh.occ.Geometry()  as geom:
        arrange = geom.add_polygon(
            [
                [-arrange_size/2.+1e-5, -arrange_size/2.+1e-5],
                [arrange_size/2.-1e-5, -arrange_size/2.+1e-5],
                [arrange_size/2.-1e-5, arrange_size/2.-1e-5],
                [-arrange_size/2.+1e-5, arrange_size/2.-1e-5],
            ],
            mesh_size=2e-4,
        )
        void_pixels = []
        for m in range(1): #row of unit
            for n in range(3): #column of unit
                for k in range(elements_per_unit): #row of element
                    for l in range(elements_per_unit): #column of element
                        for i in range(len(array)):#row of pixel
                            for j in range(len(array)):#column of pixel
                                if array[i,j] == 0:
                                    loc_x,loc_y = idx2coord(i,j,k,l,m,n)
                                    void_pixel = geom.add_polygon([[loc_x-pixel_size/2.,loc_y-pixel_size/2.],[loc_x+pixel_size/2.,loc_y-pixel_size/2.],[loc_x+pixel_size/2.,loc_y+pixel_size/2.],[loc_x-pixel_size/2.,loc_y+pixel_size/2.]],mesh_size=2e-4)
                                    void_pixels.append(void_pixel)

                            # pixels = [
                        #     geom.add_polygon([[-0.8, -0.8],[-0.5, -0.8],[-0.5, -0.5],[-0.8, -0.5],],mesh_size=0.1,),
                        #     geom.add_polygon([[0.8, 0.8],[0.5, 0.8],[0.5, 0.5],[0.8, 0.5],],mesh_size=0.1,),
                        # ]
        geom.boolean_difference(arrange, geom.boolean_union(void_pixels))
        mesh = geom.generate_mesh()
        mesh = pygmsh.optimize(mesh, method="")

        mesh.write('test2.vtk')

        end = time.time()
        print(f'Elapsed time: {end-start} s')


# //////////////////////////////////////////////////////////////

origin = sys.argv[1]
simmetry = sys.argv[2]
idx = int(sys.argv[3])
theta = int(sys.argv[4])

if origin == "-g":
    arrays_dir = r"E:/Lucas GAN/Dados/1- Arranged_geometries/Arrays/GAN/"+simmetry+'/'
    stls_dir = r"E:/Lucas GAN/Dados/2- 3D_models/stl/GAN/"+simmetry+'/'
else:
    arrays_dir = r"E:/Lucas GAN/Dados/1- Arranged_geometries/Arrays/RTGA/"+simmetry+'/'
    stls_dir = r"E:/Lucas GAN/Dados/2- 3D_models/stl/RTGA/"+simmetry+'/'


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
            os.mkdir(stls_dir+array_dir)
        except:
            pass
        array = np.array(f.readlines()).astype(float)
        array = array.reshape((int(resolution),int(resolution)))
        generate_mesh('test2.vtk')