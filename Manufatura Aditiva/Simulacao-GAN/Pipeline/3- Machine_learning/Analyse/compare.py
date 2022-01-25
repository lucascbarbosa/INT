from mmap import ACCESS_WRITE
import os
import numpy as np
import sys

prop_ = str(sys.argv[1])
dimension = int(sys.argv[2])
simmetry = str(sys.argv[3])


if os.getcwd().split('\\')[2] == 'lucas':
    open_source_dir = f"E:/Lucas GAN/Dados/3- Mechanical_properties/{prop_}/RTGA/{dimension}D/{simmetry}/"
    comsol_dir = f"E:/Lucas GAN/Dados/3- Mechanical_properties/{prop_}/MATLAB/{dimension}D/{simmetry}/"

else:
    open_source_dir = f"D:/Lucas GAN/Dados/3- Mechanical_properties/{prop_}/RTGA/{dimension}D/{simmetry}/"
    comsol_dir = f"D:/Lucas GAN/Dados/3- Mechanical_properties/{prop_}/MATLAB/{dimension}D/{simmetry}/"

os_filenames = os.listdir(open_source_dir)
comsol_filenames = os.listdir(comsol_dir)

props_os = np.array([])
approved_os = np.array([])
for os_filename in os_filenames:
    try:
        prop = np.loadtxt(open_source_dir+os_filename)
        props_os = np.append(props_os, np.array([prop]).ravel(), axis=0)
        if prop[0] != 0 and prop[1] != 0:
            approved_os = np.append(approved_os, [1, 1], axis=0)
        else:
            approved_os = np.append(approved_os, [0, 0], axis=0)

    except:
        props_os = np.append(props_os, np.array([0,0]).ravel(), axis=0)
        approved_os = np.append(approved_os, [0, 0], axis=0)

props_comsol = np.array([])
approved_comsol = np.array([])
for comsol_filename in comsol_filenames:
    try:
        prop = np.loadtxt(comsol_dir+comsol_filename)
        props_comsol = np.append(props_comsol, np.array([prop]).ravel(), axis=0)
        if prop[0] != 0 and prop[1] != 0:
            approved_comsol = np.append(approved_comsol, [1, 1], axis=0)
        else:
            approved_comsol = np.append(approved_comsol, [0, 0], axis=0)

    except:
        approved_comsol = np.append(approved_comsol, [0, 0], axis=0)

props_os = props_os.reshape((props_os.shape[0]//2,2))
approved_os = approved_os.reshape((approved_os.shape[0]//2,2))
props_comsol = props_comsol.reshape((props_comsol.shape[0]//2,2))
approved_comsol = approved_comsol.reshape((approved_comsol.shape[0]//2,2))

props_comsol_ = []
props_os_ = []

for prop_comsol,ap_comsol,prop_os,ap_os in list(zip(props_comsol,approved_comsol,props_os,approved_os)):
    if ap_os[0] == 1 and ap_comsol[0] == 1:
        props_comsol_.append(list(prop_comsol))
        props_os_.append(list(prop_os))

props_os = np.array(props_os_).ravel()
props_comsol = np.array(props_comsol_).ravel()


erro_RMS = np.round(np.sqrt(np.mean((props_comsol-props_os)**2)),2)

print("Erro para %dD, simetria %s e propriedade %s: %.4fe9"%(dimension,simmetry,prop_,erro_RMS/1e9))
