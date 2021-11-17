import os
from src.stl2vtk_2d import stl2vtk_2d
from src.stl2vtk_3d import stl2vtk_3d

def preproc(array_dir, stl_dir, vtk_dir, idx_array,idx_stl,simmetry,origin,dimension):
    angle = [0,45][idx_stl]
    try:
        stl_filenames = os.listdir(stl_dir + '/' + array_dir)
        stl_filename = stl_filenames[idx_stl]
        
    except:
        if dimension == 2:
            command_stl = "blender -b -P src/generate_arrange_2d.py %s %s %s %i %i"%(dimension,origin,simmetry,idx_array,angle)
            os.system(command_stl)
        if dimension == 3:
            command_stl = "blender -b -P src/generate_arrange_3d.py %s %s %s %i %i"%(dimension,origin,simmetry,idx_array,angle)
            os.system(command_stl)
    
    stl_filenames = os.listdir(stl_dir + '/' + array_dir)
    stl_filename = stl_filenames[idx_stl]
    vtk_filename = stl_filename[:-4]+'.vtk'
    stl_filename = stl_dir + '/' + array_dir + '/' + stl_filename
    vtk_filename = vtk_dir + '/' + array_dir + '/' + vtk_filename
    print('Preproc ',vtk_filename)
    
    if not os.path.exists((os.path.join(vtk_dir,array_dir))):
        os.mkdir(os.path.join(vtk_dir,array_dir))

    if not os.path.exists(vtk_filename):
        if dimension == 2:
            stl2vtk_2d(stl_filename,vtk_filename)
            command_convert = """python "C:/Users/lucas.barbosa/Documents/GitHub/INT/Manufatura Aditiva/Simulacao-GAN/Pipeline/3-Simulate_geometries/open-source/src/convert_mesh.py" -2 "%s" "%s" """ %(vtk_filename,vtk_filename)
            os.system(command_convert)
        if dimension == 3:
            stl2vtk_3d(stl_filename,vtk_filename)
            command_convert = """python "C:/Users/lucas.barbosa/Documents/GitHub/INT/Manufatura Aditiva/Simulacao-GAN/Pipeline/3-Simulate_geometries/open-source/src/convert_mesh.py" -d 3 "%s" "%s" """ %(vtk_filename,vtk_filename)
            os.system(command_convert)

    return stl_filename,vtk_filename
