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

def idx2coord(simmetry,i,j):
    if simmetry == 'p3':
        if i % 2 == 0:
            loc_x = np.round((j+0.5)*pixel_radius*np.sqrt(3)*1.003 - element_size[0]/2, 6)
            loc_y = np.round((i+2/3)*pixel_radius*1.5 - element_size[1], 6)
        else:
            loc_x = np.round((j+1.0)*pixel_radius*np.sqrt(3)*1.003 - element_size[0]/2, 6)
            loc_y = np.round((i+2/3)*pixel_radius*1.5 - element_size[1], 6)

    return loc_x,loc_y

def generate_mesh(simmetry, filename):
    
    with pygmsh.occ.Geometry()  as geom:
        
        edges = [
            [np.round(-element_size[0]/2,6),0],
            [np.round(-element_size[0]/2,6),np.round(-element_size[1],6)],
            [np.round(element_size[0]/2,6),np.round(-element_size[1],6)],
            [np.round(element_size[0]/2,6),0]
        ]
        
        element = geom.add_polygon(
            edges,
            mesh_size=5e-4,
        )

        # generate unit with specific simmetry
        void_pixels = []
        for i in range(array.shape[0]): #row of pixel
            for j in range(array.shape[1]): #column of pixel
                if array[i,j] == 0:
                    loc_x,loc_y = idx2coord(simmetry,i,j)
                    pixel_edges = [[loc_x+pixel_radius*1.01*np.cos(q),loc_y+pixel_radius*1.01*np.sin(q)] for q in np.arange(np.pi/6, 2*np.pi, np.pi/3)]
                    # print(pixel_edges)
                    void_pixel = geom.add_polygon(pixel_edges,mesh_size=5e-4)
                    void_pixels.append(void_pixel)

        for i in range(-1,array.shape[0]+1):
            loc_x,loc_y = idx2coord(simmetry, i, -1)
            pixel_edges = [[loc_x+pixel_radius*1.01*np.cos(q),loc_y+pixel_radius*1.01*np.sin(q)] for q in np.arange(np.pi/6, 2*np.pi, np.pi/3)]
            void_pixel = geom.add_polygon(pixel_edges,mesh_size=5e-4)
            void_pixels.append(void_pixel)
            
            loc_x,loc_y = idx2coord(simmetry, i, array.shape[1])
            pixel_edges = [[loc_x+pixel_radius*1.01*np.cos(q),loc_y+pixel_radius*1.01*np.sin(q)] for q in np.arange(np.pi/6, 2*np.pi, np.pi/3)]
            void_pixel = geom.add_polygon(pixel_edges,mesh_size=5e-4)
            void_pixels.append(void_pixel)
        
        for i in range(-1,array.shape[1]+1):
            loc_x,loc_y = idx2coord(simmetry, -1, i)
            pixel_edges = [[loc_x+pixel_radius*1.01*np.cos(q),loc_y+pixel_radius*1.01*np.sin(q)] for q in np.arange(np.pi/6, 2*np.pi, np.pi/3)]
            void_pixel = geom.add_polygon(pixel_edges,mesh_size=5e-4)
            void_pixels.append(void_pixel)

            loc_x,loc_y = idx2coord(simmetry, array.shape[0], i)
            pixel_edges = [[loc_x+pixel_radius*1.01*np.cos(q),loc_y+pixel_radius*1.01*np.sin(q)] for q in np.arange(np.pi/6, 2*np.pi, np.pi/3)]
            void_pixel = geom.add_polygon(pixel_edges,mesh_size=5e-4)
            void_pixels.append(void_pixel)
        
        element = geom.boolean_difference(element, geom.boolean_union(void_pixels))

        elements = []
        elements.append(element[0])

        for i in range(1,elements_per_unit):
            element_ = geom.copy(element[0])
            geom.rotate(element_,(pixel_radius*np.sqrt(3)/4,0.0,0.0),i*2*np.pi/3,(0.0,0.0,1.0))
            elements.append(element_)
        
        unit = geom.boolean_union(elements)
        
        units  = []
        
        for i in range(units_per_col+2):
            for j in range(units_per_row+2):
                unit_ = geom.copy(unit[0])
                if i % 2 == 0:
                    translate = [j*(element_size[0]+1.5*pixel_radius*np.sqrt(3))*0.997,i*(1.5*element_size[1]+0.75*pixel_radius),0]
                else:
                    translate = [(j*(element_size[0]+1.5*pixel_radius*np.sqrt(3))+element_size[0]/2+pixel_radius*np.sqrt(3)*0.75)*0.997,i*(1.5*element_size[1]+0.75*pixel_radius),0]

                geom.translate(unit_, translate)
                units.append(unit_)

        geom.remove(unit[0],recursive=True)
        arrange = geom.boolean_union(units)

        # geom.translate(arrange[0],[-(units_per_row+1.5)*element_size[1]*np.sqrt(3)*0.5,-(units_per_col+1)*0.75*element_size[1],0])
        
        # geom.rotate(arrange[0],[0.,0.,0.],np.deg2rad(theta),[0.,0.,1.])

        # filter_out = geom.add_disk([0.0, 0.0], 0.06, mesh_size=5e-4)

        # filter_in = geom.add_polygon(
        #     [
        #         [-arrange_size/2+1e-4, -arrange_size/2+1e-4],
        #         [arrange_size/2-1e-4, -arrange_size/2+1e-4],
        #         [arrange_size/2-1e-4, arrange_size/2-1e-4],
        #         [-arrange_size/2+1e-4, arrange_size/2-1e-4],
        #     ],
        #     mesh_size=5e-4,
        # )

        # filter_boolean = geom.boolean_difference(filter_out,filter_in)

        # arrange = geom.boolean_difference(arrange, filter_boolean)

        # handle_top = geom.add_polygon(
        #     [
        #         [-arrange_size/2.+1.1e-4, arrange_size/2.-1.1e-4],
        #         [arrange_size/2.-1.1e-4, arrange_size/2.-1.1e-4],
        #         [arrange_size/2.-1.1e-4, 3*arrange_size/4.],
        #         [-arrange_size/2.+1.1e-4, 3*arrange_size/4.],
        #     ],
        #     mesh_size=5e-4,
        # )
        
        # handle_bot = geom.copy(handle_top)
        # geom.translate(handle_bot,[0,-5*arrange_size*0.998/4,0])

        # geom.boolean_union([arrange,handle_bot,handle_top])
        
        # geom.set_mesh_size_callback(
        #     lambda dim, tag, x, y, z: pixel_size
        # )

        mesh = geom.generate_mesh()
        mesh.write(filename)
        # end = time.time()

        # print(f'Elapsed time: {end-start} s')
# //////////////////////////////////////////////////////////////

# origin = sys.argv[1]
# simmetry = sys.argv[2]
# units = int(sys.argv[3])
# size = int(sys.argv[4])
# idx = int(sys.argv[5])-1
# theta = int(sys.argv[6])

start_time = time.time()

origin = '-r'
simmetry = 'p3'
units = 9
idx = 1
theta = 0

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
units_per_col = units_per_row
elements_per_unit = int(simmetry[1])

thickness =  2.5e-3 # m
arrange_size = 48e-3 # m
unit_radius = np.round(float(arrange_size/(((units_per_col-1)*0.75+1)*2)),4) # m
mag = int(log(len(arrays_filename),10)+3)

array_filename = arrays_filename[idx-1]

with open(os.path.join(arrays_dir,array_filename),'r') as f:
    array_dir = array_filename.split('_')[0]
    try:
        os.mkdir(vtks_dir+array_dir)
    except:
        pass
    
    array = np.array(f.readlines()).astype(float)
    
    size = array[0]
    array = array[1:]
    
    element_size = [unit_radius*np.sqrt(3), unit_radius] # m
    pixel_radius = np.round(float(element_size[1]/(((size-1)*0.75+1)*2)),6)
    array = array.reshape((int(size),int(array.shape[0]/size)))
    element_size = [np.round(pixel_radius*np.sqrt(3)*(array.shape[1]+0.5),4), np.round(1.5*pixel_radius*(array.shape[0]-1)+2*pixel_radius,4)] # m
    print(f'arrange_size={arrange_size},\nunit_radius={unit_radius},\nelement_size={np.round(element_size,4)},\npixel_radius={pixel_radius}')
    filename = vtks_dir+array_dir+'/'+array_filename[mag:-4]+"_theta_%d.vtk"%theta
    generate_mesh(simmetry, 'test.vtk')
    end_time = time.time()

print(end_time-start_time)