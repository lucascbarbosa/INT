import numpy as np
import os
import sys
import pygalmesh as pgm
from math import radians, cos, sin, log
import matplotlib.pyplot as plt

def export_vtk(points,constraints):
    
    mesh = pgm.generate_2d(
        points,
        constraints,
        max_edge_size=2e-4,
        num_lloyd_steps=10,
    )
    
    mesh.write("test.vtk")


def get_points_constraints(array):
    points = []
    constraints = []
    cells = 0
    locs_solid = []
    for i in range(array.shape[0]):
    # for i in range(10):
        loc_y = np.round(unit_size/2.0 - (i+0.5)*pixel_size,5)
        for j in range(array.shape[1]):
        # for j in range(10):
            loc_x = np.round((j+0.5)*pixel_size - unit_size/2.0,5)
            locs_x = [loc_x,loc_y,-loc_x,-loc_y]
            locs_y = [loc_y,-loc_x,-loc_y,loc_x]
            for loc_x,loc_y in list(zip(locs_x,locs_y)):
                points.append([loc_x-pixel_size/2.,loc_y-pixel_size/2.])
                points.append([loc_x-pixel_size/2.,loc_y+pixel_size/2.])
                points.append([loc_x+pixel_size/2.,loc_y-pixel_size/2.])
                points.append([loc_x+pixel_size/2.,loc_y+pixel_size/2.])
                if array[i,j] == 1:
                    locs_solid.append([loc_x,loc_y])
    
    print(array)
    points = np.array(points).reshape(len(points),2).round(4)
    points = np.unique(points,axis=0)

    for i in range(len(points)-1):
        for j in range(1,len(points)):
            vector = points[i] - points[j]
            vector = vector.round(4)
            vector = vector.tolist()
            position = (points[i] + points[j])/2.
            position = position.tolist()
            if vector == [0,-pixel_size] or vector == [-pixel_size,0]:
                for loc_solid in locs_solid:
                    if (position[0] <= loc_solid[0] + pixel_size/2. and position[0] >= loc_solid[0] - pixel_size/2.) and (position[1] <= loc_solid[1] + pixel_size/2. and position[1] >= loc_solid[1] - pixel_size/2.):
                        constraints.append([i,j])
                        break
            
    export_vtk(points,constraints)

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

units_per_arrange = 3.
elements_per_element = 2.
resolution = 16.
thickness =  2.5e-3 # m

arrange_size = 48e-3 # m
unit_size = float(arrange_size/units_per_arrange) # m
element_size = float(unit_size/elements_per_element) # m
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
        get_points_constraints(array)
