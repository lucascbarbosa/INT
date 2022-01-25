from mmap import ACCESS_WRITE
import os 
import numpy as np
import sys

prop = str(sys.argv[1])
dimension = int(sys.argv[2])
origin = str(sys.argv[3])
simmetry = str(sys.argv[4])

if origin == "-r":
    origin = "RTGA"

if origin == "-g":
    origin = "GAN"

if os.getcwd().split('\\')[2] == 'lucas':
    open_source_dir = f"E:/Lucas GAN/Dados/3- Mechanical_properties/{prop}/{origin}/{dimension}D/{simmetry}/"
    comsol_dir = f"E:/Lucas GAN/Dados/3- Mechanical_properties/{prop}/MATLAB/{dimension}D/{simmetry}/"

else:
    open_source_dir = f"D:/Lucas GAN/Dados/3- Mechanical_properties/{prop}/{origin}/{dimension}D/{simmetry}/"
    comsol_dir = f"D:/Lucas GAN/Dados/3- Mechanical_properties/{prop}/MATLAB/{dimension}D/{simmetry}/"

os_filenames = os.listdir(open_source_dir)
comsol_filenames = os.listdir(comsol_dir)

props_os = np.array([])
for os_filename in os_filenames:
    try:
        prop = np.loadtxt(open_source_dir+os_filename)
        if prop[0] != 0 and prop[1] != 0:
            m = prop.min()
            M = prop.max()
            props_os = np.append(props_os,np.array([1.0 - ((M-m)/((M+m)))]),axis=0)
    except:
        pass

props_comsol = np.array([])
for comsol_filename in comsol_filenames:
    try:
        prop = np.loadtxt(open_source_dir+comsol_filename)
        if prop[0] != 0 and prop[1] != 0:
            m = prop.min()
            M = prop.max()
            props_comsol = np.append(props_comsol,np.array([1.0 - ((M-m)/((M+m)))]),axis=0)
    except:
        pass

# props_comsol_ = []
# props_os_ = []
# for young_comsol,young_os in list(zip(props_comsol,props_os)):
#     if young_comsol == np.inf or young_comsol == 0 or young_comsol == np.nan or young_os == np.inf or young_os == 0 or young_os == np.nan:
#         pass
#     else:
#         props_comsol_.append(young_comsol)
#         props_os_.append(young_os)
# props_os = np.array(props_os_)
# props_comsol = np.array(props_comsol_)
# # print(props_comsol[:7])
# print(np.round(np.sqrt(np.mean((props_comsol-props_os)**2)),2))