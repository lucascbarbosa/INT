import meshio
import sys

filename  = sys.argv[1]
file_format = sys.argv[2]

filename = "C:/Users/lucas/Documents/GitHub/INT/Manufatura Aditiva/Simulacao-GAN/Dados/2- 3D_models/"+filename

mesh = meshio.read(
    filename,  # string, os.PathLike, or a buffer/open file
    file_format="stl",  # optional if filename is a path; inferred from extension
)

mesh.write(
    filename[:-4]+'.'+file_format,  # str, os.PathLike, or buffer/open file
    # file_format=file_format,  # optional if first argument is a path; inferred from extension
)