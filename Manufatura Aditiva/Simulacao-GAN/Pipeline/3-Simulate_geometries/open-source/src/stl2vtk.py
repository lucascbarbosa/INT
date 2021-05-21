import pygalmesh
import meshio
# import trimesh 

def stl2vtk(file_in,file_out):
    mesh = meshio.read(file_in)

    mesh = pygalmesh.generate_volume_mesh_from_surface_mesh(
        file_in,
        facet_size=0.0002,
        facet_angle=30,
        seed=42,
        verbose=True,
        odt=True
    )
    
    meshio.write(file_out, mesh)
    
    # trimesh.interfaces.gmsh.to_volume(mesh, file_name=file_out, max_element=2e-4)

