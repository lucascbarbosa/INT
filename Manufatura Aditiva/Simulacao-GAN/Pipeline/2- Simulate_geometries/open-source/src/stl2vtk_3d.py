import pygalmesh
import meshio
# import trimesh
# import gmsh 


def stl2vtk_3d(file_in,file_out):
    mesh = meshio.read(file_in)
    # mesh = trimesh.load_mesh(file_in)

    mesh = pygalmesh.generate_volume_mesh_from_surface_mesh(
        file_in,
        facet_size=2e-4,
        seed=42,
        verbose=False
    )
    
    meshio.write(file_out, mesh)
    
    # trimesh.interfaces.gmsh.to_volume(mesh, file_name=file_out, max_element=2e-4)

# file_in = r'D:\Lucas GAN\Dados\2- 3D_models\stl\p4\00001\porosity_0.5273_theta_0.stl'
# file_out = r'D:\Lucas GAN\Dados\2- 3D_models\vtk\p4\00001\porosity_0.5273_theta_0.vtk'
# stl2vtk(file_in,file_out)