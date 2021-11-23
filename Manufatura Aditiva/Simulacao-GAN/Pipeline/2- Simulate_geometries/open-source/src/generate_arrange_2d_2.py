import numpy as np
import os
import sys
from numpy.core.numeric import count_nonzero
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

def idx2coord(i,j):
    loc_y = np.round(element_size - (i+0.5)*pixel_size,5)
    loc_x = np.round((j+0.5)*pixel_size - element_size,5)
    return loc_x,loc_y

def coord2idx(loc_x,loc_y):
    i = int(np.round((element_size-loc_y)/pixel_size - 0.5))
    j = int(np.round((loc_x+element_size)/pixel_size - 0.5))
    return i,j

def get_points_constraints(array):
    points = []
    points_position = np.zeros((int(array.shape[0]*elements_per_unit*units_per_arrange+1),int(array.shape[1]*elements_per_unit*units_per_arrange+1)))
    constraints = []
    locs_solid = []
    for i in range(array.shape[0]):
    # for i in range(2):
        for j in range(array.shape[1]):
        # for j in range(2):
            loc_x,loc_y = idx2coord(i,j)
            locs_element_x = [loc_x,loc_y,-loc_x,-loc_y]
            locs_element_y = [loc_y,-loc_x,-loc_y,loc_x]
            for loc_pixel_x,loc_pixel_y in list(zip(locs_element_x,locs_element_y)):

                if [np.round(loc_pixel_x-pixel_size/2.,4),np.round(loc_pixel_y+pixel_size/2.,4)] not in points:
                    points.append([np.round(loc_pixel_x-pixel_size/2.,4),np.round(loc_pixel_y+pixel_size/2.,4)])

                if [np.round(loc_pixel_x-pixel_size/2.,4),np.round(loc_pixel_y-pixel_size/2.,4)] not in points:
                    points.append([np.round(loc_pixel_x-pixel_size/2.,4),np.round(loc_pixel_y-pixel_size/2.,4)])

                if [np.round(loc_pixel_x+pixel_size/2.,4),np.round(loc_pixel_y+pixel_size/2.,4)] not in points:
                    points.append([np.round(loc_pixel_x+pixel_size/2.,4),np.round(loc_pixel_y+pixel_size/2.,4)])

                if [np.round(loc_pixel_x+pixel_size/2.,4),np.round(loc_pixel_y-pixel_size/2.,4)] not in points:
                    points.append([np.round(loc_pixel_x+pixel_size/2.,4),np.round(loc_pixel_y-pixel_size/2.,4)])

                if array[i,j] == 1:
                    locs_solid.append([loc_pixel_x,loc_pixel_y])
    points = np.array(points).reshape(len(points),2)
    ind = np.lexsort((points[:,1],points[:,0]))
    # points = points[np.argsort(points,axis=0)[:,0]]
    points = points[ind]

    # for p in range(len(points)):
    #     point = points[p]
    #     i,j = coord2idx(point[0],point[1])
    #     points_position[i,j] = p
        # print(point[0],point[1],i,j)

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
elements_per_unit = 2.
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
        get_points_constraints(array)
