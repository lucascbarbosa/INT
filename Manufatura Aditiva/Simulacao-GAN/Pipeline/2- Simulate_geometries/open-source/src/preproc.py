import os
# from src.stl2vtk_2d import stl2vtk_2d
# from src.stl2vtk_3d import stl2vtk_3d

def preproc(vtk_dir, array_dir, idx_array, idx_file, origin, simmetry, dimension):
    angle = [0,45][idx_file]
    units = 9
    size = 16

    if dimension == 2:
            
        if not os.path.isdir(vtk_dir+array_dir):
            os.mkdir(vtk_dir+array_dir)

        if simmetry[1] in ['3','6']:
            command_vtk = "python src/generate_model_2d_hex.py %s %s %i %i %i %i"%(origin,simmetry,units,size,idx_array,angle)
        elif simmetry[1] == '4':
            command_vtk = "python src/generate_model_2d_quad.py %s %s %i %i %i %i"%(origin,simmetry,units,size,idx_array,angle)
        os.system(command_vtk)

        vtk_filenames = os.listdir(vtk_dir + array_dir)
        for i in range(len(vtk_filenames)):
            if vtk_filenames[i].split('_')[-1][:2] == str(angle):
                idx_file = i
        
        vtk_filename = vtk_filenames[idx_file]
        vtk_filename = vtk_dir + array_dir + vtk_filename
        command_convert = """python "src/convert_mesh.py" -2 "%s" "%s" """ %(vtk_filename,vtk_filename)
        os.system(command_convert)

    # if dimension == 3:
    #     try:
    #         stl_filenames = os.listdir(vtk_dir + array_dir)
    #         stl_filename = stl_filenames[idx_file]
            
    #     except:
    #         command_stl = "blender -b -P src/generate_model_3d.py %s %s %i %i --log-level 0"%(origin,simmetry,idx_array,angle)
    #         os.system(command_stl)

        # stl_filenames = os.listdir(vtk_dir + array_dir)
        # stl_filename = stl_filenames[idx_file]
        # vtk_filename = stl_filename[:-4]+'.vtk'
        # stl_filename = vtk_dir + array_dir + stl_filename
        # vtk_filename = vtk_dir + array_dir + vtk_filename
    
    # if not os.path.exists((os.path.join(vtk_dir,array_dir))):
    #     os.mkdir(os.path.join(vtk_dir,array_dir))

    # if not os.path.exists(vtk_filename):
    #     if dimension == 3:
    #         stl2vtk_3d(stl_filename,vtk_filename)
    #         command_convert = """python "src/convert_mesh.py" -d 3 "%s" "%s" """ %(vtk_filename,vtk_filename)
    #         os.system(command_convert)
    #         os.remove(stl_filename)
            
    return vtk_filename
