import bpy
import bmesh
from mathutils import Vector, Matrix
from mathutils.bvhtree import BVHTree
from math import radians, cos, sin, log
import numpy as np
import os
from mathutils import Matrix, Vector
import sys

def create_cube(name,size,location,scale,angles):
    bpy.ops.mesh.primitive_cube_add(size=size, location=location, scale=scale)
    so = bpy.context.active_object
    for i in range(3):
        so.rotation_euler[i] += radians(angles[i])
#        
    so.name = name
        
def translate_object(obj,location):
    for i in range(3):
        obj.location[i] = location[i]
        
def rotate_object(obj, angles):
   for i in range(3):
       obj.rotation_euler[i] += radians(angles[i])
       
def select_object(name):
    bpy.data.objects[name].select_set(True)
    sel = bpy.context.selected_objects
    act = bpy.context.active_object
    obj = sel[0]
    bpy.context.view_layer.objects.active = obj

def deselect_object(name):
    bpy.data.objects[name].select_set(False)    
def deselect_all():
    bpy.ops.object.select_all(action='DESELECT')
    bpy.context.view_layer.objects.active = None
    
def join(mother_name, siblings_name):
    context = bpy.context
    scene = context.scene
    objects = [o for o in scene.objects if o.name.startswith(siblings_name)]


    for object in objects:
        select_object(object.name)
        
    bpy.ops.object.join()
    bpy.context.active_object.name = mother_name     
    bpy.ops.object.origin_set(type='ORIGIN_CURSOR', center='MEDIAN')

def add_array(name, array_size,direction):
    bpy.ops.object.modifier_add(type='ARRAY')
    bpy.context.object.modifiers["Array"].name = name
    bpy.context.object.modifiers[name].count = array_size
    
    if direction == "x":
        bpy.context.object.modifiers[name].relative_offset_displace[0] = 1.0
        bpy.context.object.modifiers[name].relative_offset_displace[1] = 0.0
    if direction == "y":
        bpy.context.object.modifiers[name].relative_offset_displace[0] = 0.0
        bpy.context.object.modifiers[name].relative_offset_displace[1] = 1.0
    
    bpy.ops.object.modifier_apply(modifier=name)

def get_bm_elements(bm):
        # select all faces
    for f in bm.faces:
        f.select = True

    verts = [v for v in bm.verts]
    edges = [e for e in bm.edges]
    faces = [f for f in bm.faces]
    
    geom = []
    
    geom.extend(verts)
    geom.extend(edges)
    geom.extend(faces)
    
    return geom

def create_unit(name,array,rotation,location):
    for i in range(len(array)):
        for j in range(len(array)):
            loc_y = unit_size/2.0 - (i+0.5)*pixel_size
            if array[i,j] == 0.0:
                loc_x = (j+0.5)*pixel_size - unit_size/2.0
                name_pixel = "pixel {}".format(i*resolution+j+1)
                create_cube(name_pixel,pixel_size*1.001,(loc_x,loc_y,0),scale_pixel,degs_pixel)

    join(name,"pixel")
    rotate_object(bpy.context.object, rotation)
    translate_object(bpy.context.object,location)    

def create_element(name, locations):
    for i in range(units_per_element*units_per_element):
        create_unit("unit {}".format(i+1),array,rotations[i],locations[i])
    join(name,"unit")
    
def create_arrange(name,locations_units):
    deselect_all()
    
    create_element("negative element",locations_units)
    bpy.ops.transform.translate(value=(+unit_size/2, +unit_size/2, 0), orient_type='GLOBAL', orient_matrix=((1, 0, 0), (0, 1, 0), (0, 0, 1)), orient_matrix_type='GLOBAL', mirror=True, use_proportional_edit=False, proportional_edit_falloff='SMOOTH', proportional_size=1, use_proportional_connected=False, use_proportional_projected=False, cursor_transform=True, release_confirm=True)
    bpy.ops.object.origin_set(type='ORIGIN_CURSOR', center='MEDIAN')
    bpy.ops.transform.translate(value=(-unit_size/2, -unit_size/2, 0), orient_type='GLOBAL', orient_matrix=((1, 0, 0), (0, 1, 0), (0, 0, 1)), orient_matrix_type='GLOBAL', mirror=True, use_proportional_edit=False, proportional_edit_falloff='SMOOTH', proportional_size=1, use_proportional_connected=False, use_proportional_projected=False, cursor_transform=True, release_confirm=True)
    bpy.context.object.location[0] = 0
    bpy.context.object.location[1] = 0
    bpy.ops.object.move_to_collection(collection_index=0, is_new=True, new_collection_name="negative element")

    # create element
    create_cube("element",element_size,(0, 0, 0),(2,2,float(2*thickness/element_size)),(0,0,0))
    bpy.ops.object.modifier_add(type='BOOLEAN')
    bpy.context.object.modifiers["Boolean"].operand_type = 'COLLECTION'
    bpy.context.object.modifiers["Boolean"].collection = bpy.data.collections["negative element"]
    bpy.ops.object.modifier_apply(modifier="Boolean")
    deselect_all()
    select_object("negative element")
    bpy.ops.object.delete()
    bpy.data.collections.remove(bpy.data.collections.get("negative element"))

    # array
    deselect_all()
    select_object("element")
    add_array("Array 1", 6,"x")
    add_array("Array 2", 6,"y")
    bpy.context.active_object.name = name
    bpy.ops.transform.translate(value=(arrange_size-unit_size, arrange_size-unit_size, 0), orient_type='GLOBAL', orient_matrix=((1, 0, 0), (0, 1, 0), (0, 0, 1)), orient_matrix_type='GLOBAL', mirror=True, use_proportional_edit=False, proportional_edit_falloff='SMOOTH', proportional_size=1, use_proportional_connected=False, use_proportional_projected=False, cursor_transform=True, release_confirm=True)
    bpy.ops.object.origin_set(type='ORIGIN_CURSOR', center='MEDIAN')
    bpy.ops.transform.translate(value=(-arrange_size+unit_size, -arrange_size+unit_size, 0), orient_type='GLOBAL', orient_matrix=((1, 0, 0), (0, 1, 0), (0, 0, 1)), orient_matrix_type='GLOBAL', mirror=True, use_proportional_edit=False, proportional_edit_falloff='SMOOTH', proportional_size=1, use_proportional_connected=False, use_proportional_projected=False, cursor_transform=True, release_confirm=True)
    bpy.context.object.location[0] = 0
    bpy.context.object.location[1] = 0
    bpy.ops.object.move_to_collection(collection_index=0, is_new=True, new_collection_name=name)
    
    # bisect 
    deselect_all()
    select_object(name)
    me = bpy.context.object.data
    bm = bmesh.new()
    bm.from_mesh(me)
    
    plane_cos = []
    plane_nos = []
    
    for i in range(4):
        plane_cos.append((arrange_size*cos(radians(theta+i*90))/2, arrange_size*sin(radians(theta+i*90))/2, 0))
        plane_nos.append((cos(radians(theta+i*90)),sin(radians(theta+i*90)),0))
    
    for i in range(4):
        plane_co = plane_cos[i]        
        plane_no = plane_nos[i]
        
        geom = get_bm_elements(bm)
   
        bmesh.ops.bisect_plane(bm, geom=geom, plane_co=plane_co, plane_no=plane_no, clear_outer=True, clear_inner=False, use_snap_center=False, dist=1e-9)
 
    bm.to_mesh(me)
    me.update()
    bm.clear()
    bm.free()

    # fill holes
    me = bpy.context.object.data
    bm = bmesh.new()
    bm.from_mesh(me)
    bmesh.ops.holes_fill(bm, edges=bm.edges[:], sides=0)
    bm.to_mesh(me)
    me.update()
    bm.clear()
    bm.free()
    
    #rotate back
    rotate_object(bpy.context.object,(0, 0, -theta))
    
    locations = [(0, 5*arrange_size/8, 0), (0, -5*arrange_size/8, 0)] 
    
    #add handles
    for i in range(2):
        create_cube("arrange {}".format(i+1), arrange_size, locations[i], (2., 1./2.,  float(2*(thickness)/arrange_size)), (0, 0, 0))
    
    locations = [(float(arrange_size/2.0)+0.0005, 0, 0),(-float(arrange_size/2.0)-0.0005, 0, 0)]
    #add side rectangles
    for i in range(2):
        create_cube("arrange{}".format(i+3), arrange_size, locations[i], (float(2./(1000*arrange_size)), 3., float(2*(thickness)/arrange_size)), (0, 0, 0))
    
    join(name, "arrange")
    
    #remesh
    bpy.ops.object.modifier_add(type='REMESH')
    bpy.context.object.modifiers["Remesh"].voxel_size = 0.0002
    bpy.context.object.modifiers["Remesh"].use_smooth_shade = True
    bpy.ops.object.modifier_apply(modifier="Remesh")
    
# /////////////////////////////////////////////////////////////////////////////////////////
# origin = sys.argv[4]
# simmetry = sys.argv[5]
# idx = int(sys.argv[6])
# theta = int(sys.argv[7])

origin = "-r"
simmetry = "p4"
idx = 1
theta = 0

if origin == "-g":
    if os.getcwd().split('\\')[2] == 'lucas':
        arrays_dir = r"E:/Lucas GAN/Dados/1- Arranged_geometries/Arrays/GAN/"+simmetry+'/'
        vtks_dir = r"E:/Lucas GAN/Dados/2- Models/GAN/3D/"+simmetry+'/'
    else:
        arrays_dir = r"D:/Lucas GAN/Dados/1- Arranged_geometries/Arrays/GAN/"+simmetry+'/'
        vtks_dir = r"D:/Lucas GAN/Dados/2- Models/GAN/3D/"+simmetry+'/'
    
else:
    if os.getcwd().split('\\')[2] == 'lucas':
        arrays_dir = r"E:/Lucas GAN/Dados/1- Arranged_geometries/Arrays/RTGA/"+simmetry+'/'
        vtks_dir = r"E:/Lucas GAN/Dados/2- Models/RTGA/3D/"+simmetry+'/'
    else:
        arrays_dir = r"D:/Lucas GAN/Dados/1- Arranged_geometries/Arrays/RTGA/"+simmetry+'/'
        vtks_dir = r"D:/Lucas GAN/Dados/2- Models/RTGA/3D/"+simmetry+'/'

arrays_filename = os.listdir(arrays_dir)

elements_per_arrange = 3
units_per_element = 2
resolution = 16
thickness =  2.5e-3 # m

arrange_size = 48e-3 # m
element_size = float(arrange_size/elements_per_arrange) # m
unit_size = float(element_size/units_per_element) # m
pixel_size = float(unit_size/resolution)

scale_pixel = (2,2,2*(thickness+0.5e-3)/pixel_size)   
degs_pixel = (0,0,0)
    
rotations = [(0,0,0),(0,0,90),(0,0,180),(0,0,270)]
locations = [(0,0,0),(unit_size,0,0),(unit_size,unit_size,0),(0,unit_size,0)]

mag = int(log(len(arrays_filename),10)+3)+1

for array_filename in arrays_filename[idx:idx+1]:
    with open(os.path.join(arrays_dir,array_filename),'r') as f:
        array_dir = array_filename.split('_')[0]
        try:
            os.mkdir(vtks_dir+array_dir)
        except:
            pass
        array = np.array(f.readlines()).astype(float)
        array = array.reshape((int(resolution),int(resolution)))
        
        
        create_arrange("arrange", locations)
    
        # export
        filepath = vtks_dir+array_dir+'/'+array_filename[mag:-4]+"_theta_%d.stl"%theta
        bpy.ops.export_mesh.stl(
                filepath=filepath,
                use_selection=True)

        #delete object and collection
        bpy.ops.object.delete()
        coll = bpy.data.collections.get("arrange")
        bpy.data.collections.remove(coll)