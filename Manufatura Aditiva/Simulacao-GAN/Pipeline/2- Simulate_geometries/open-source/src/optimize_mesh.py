import meshio
import numpy as np
import optimesh

path = 'C:/Users/lucas/OneDrive/Documentos/GitHub/INT/Manufatura Aditiva/Simulacao-GAN/Pipeline/2- Simulate_geometries/open-source/src/test.vtk'

mesh = meshio.read(path)

points = mesh.points
cells = mesh.cells
# cells = [(str(cells[0,0]),cells[0,1].tolist())]


points, cells = optimesh.optimize_points_cells(
    points, cells, "CVT (block-diagonal)", 1.0e-5, 100
)
