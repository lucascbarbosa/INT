import pygalmesh
import meshio 

mesh = pygalmesh.generate_volume_mesh_from_surface_mesh(
    "C:/Users/lucas/Documents/GitHub/INT/Manufatura Aditiva/Simulacao-GAN/Dados/2- 3D_models/00001_porosity_0.4531.stl",
    facet_size=0.0002,
    facet_angle=30,
    seed=42,
    verbose=True,
    odt=True
    )

meshio.write( "C:/Users/lucas/Documents/GitHub/INT/Manufatura Aditiva/Simulacao-GAN/Dados/2- 3D_models/00001_porosity_0.4531.vtk", mesh)
