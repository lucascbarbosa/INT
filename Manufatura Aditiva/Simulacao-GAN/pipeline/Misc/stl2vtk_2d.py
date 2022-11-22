import meshio
import pygalmesh

def stl2vtk_2d(file_in,file_out):

    mesh = meshio.read(file_in)
    
    meshio.write(file_out, mesh, binary=False)
