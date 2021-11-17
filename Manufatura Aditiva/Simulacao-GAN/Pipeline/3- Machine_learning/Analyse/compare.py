from mmap import ACCESS_WRITE
import os 
import numpy as np

open_source_dir = "D:/Lucas GAN/Dados/3- Mechanical_properties/young/p4/"
comsol_dir = "D:/Lucas GAN/Dados/3- Mechanical_properties/young_COMSOL/"

os_filenames = os.listdir(open_source_dir)
comsol_filenames = os.listdir(comsol_dir)

youngs_os = np.array([])
for os_filename in os_filenames:
    young = np.loadtxt(open_source_dir+os_filename)
    youngs_os = np.append(youngs_os,np.array([(young[0]/young[1])]),axis=0)

youngs_comsol = np.array([])
for comsol_filename in comsol_filenames:
    young = np.loadtxt(comsol_dir+comsol_filename)
    youngs_comsol = np.append(youngs_comsol,np.array([young[0]/young[1]]),axis=0)

youngs_comsol_ = []
youngs_os_ = []
for young_comsol,young_os in list(zip(youngs_comsol,youngs_os)):
    if young_comsol == np.inf or young_comsol == 0 or young_comsol == np.nan or young_os == np.inf or young_os == 0 or young_os == np.nan:
        pass
    else:
        youngs_comsol_.append(young_comsol)
        youngs_os_.append(young_os)
youngs_os = np.array(youngs_os_)
youngs_comsol = np.array(youngs_comsol_)
# print(youngs_comsol[:7])
print(np.round(np.sqrt(np.mean((youngs_comsol-youngs_os)**2)),2))