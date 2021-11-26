import dmsh
from dmsh.geometry.geometry import Difference
import dmsh
import optimesh
import meshio
from madcad import difference,read
import time

start = time.time()
arrange = dmsh.Polygon([[-0.024, -0.024],[-0.024, 0.024],[0.024, 0.024],[0.024,-0.024]])
for i in range(2):
    for j in range(2):
        pixel = dmsh.Polygon([[-0.012+j*0.0005,0.012-i*0.0005],[-0.012+(j+1)*0.0005, 0.012-i*0.0005],[-0.012+j*0.0005,0.012-(i+1)*0.0005],[-0.012+(j+1)*0.0005, 0.012-(i+1)*0.0005]])
        arrange = arrange - pixel

        
X, cells = dmsh.generate(arrange, 0.002)
X, cells = optimesh.optimize_points_cells(X, cells, "CVT (full)", 1.0e-10, 100)
meshio.Mesh(X, {"triangle": cells}).write("arrange.vtk")

end = time.time()
print(f'Elapsed time: {end-start} s')
