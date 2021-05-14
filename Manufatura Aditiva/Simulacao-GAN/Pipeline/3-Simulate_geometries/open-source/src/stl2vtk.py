import pygalmesh
import meshio 

def stl2vtk(file_in,file_out):
    mesh = pygalmesh.generate_volume_mesh_from_surface_mesh(
        file_in,
        facet_size=0.0002,
        facet_angle=30,
        seed=42,
        verbose=True,
        odt=True
        )

    meshio.write(file_out, mesh)
