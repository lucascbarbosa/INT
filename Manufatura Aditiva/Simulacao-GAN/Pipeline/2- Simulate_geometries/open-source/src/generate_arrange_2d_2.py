import numpy as np
import os
import sys


origin = sys.argv[1]
simmetry = sys.argv[2]
idx = int(sys.argv[3])
theta = int(sys.argv[4])

if origin == "-g":
    arrays_dir = r"E:/Lucas GAN/Dados/1- Arranged_geometries/Arrays/GAN/"+simmetry+'/'
    stls_dir = r"E:/Lucas GAN/Dados/2- 3D_models/stl/GAN/"+simmetry+'/'
else:
    arrays_dir = r"E:/Lucas GAN/Dados/1- Arranged_geometries/Arrays/RTGA/"+simmetry+'/'
    stls_dir = r"E:/Lucas GAN/Dados/2- 3D_models/stl/RTGA/"+simmetry+'/'

arrays_filename = os.listdir(arrays_dir)
