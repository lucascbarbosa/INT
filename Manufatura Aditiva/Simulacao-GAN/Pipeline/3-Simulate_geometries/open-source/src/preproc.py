import os
from src.stl2vtk import stl2vtk

def preproc(stl_filename,vtk_filename):

    stl2vtk(stl_filename,vtk_filename)
    command = """python src/convert_mesh.py -d 3 "%s" "%s" """ %(vtk_filename,vtk_filename)
    os.system(command)