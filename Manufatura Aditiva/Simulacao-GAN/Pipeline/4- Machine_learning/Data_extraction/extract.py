from numpy.core.defchararray import array
import pandas as pd
import os
import numpy as np
import sys
def calculate_isotropy(Es,p):
    m, M = Es.min(),Es.max()
    return 1.0 - ((M-m)/((M+m)))

def create_df(property,problem,E):
    property_dir = 'C:/Users/lucas/Documents/GitHub/INT/Manufatura Aditiva/Simulacao-GAN/Dados/3- Mechanical_properties/'+property
    array_dir = 'C:/Users/lucas/Documents/GitHub/INT/Manufatura Aditiva/Simulacao-GAN/Dados/1- Arranged_geometries/Arrays/'
    
    Es = np.array([])
    porosities = []
    geometries = []

    for simulation in os.listdir(property_dir):
        Es_simulation = np.loadtxt(os.path.join(property_dir,simulation),delimiter='/n')
        porosity = float(simulation[:-4].split('_')[-1])
        porosities.append(porosity)
        Es = np.append(Es,Es_simulation)
        geometry = np.loadtxt(os.path.join(array_dir,simulation),delimiter='\n').astype(int)
        geometry = geometry.reshape((int(np.sqrt(len(geometry))), int(np.sqrt(len(geometry)))))[1:-1,1:-1].ravel()
        geometries.append(geometry)
    
    Es = np.array(Es).reshape((len(os.listdir(property_dir)),len(Es_simulation)))
    porosities = np.array(porosities)
    geometries = np.array(geometries).astype(int)

    if problem == 'isotropy':
        isos = []
        data = np.array([])

        for i in range(len(Es)):
            p = 1.0-porosities[i]
            iso = calculate_isotropy(Es[i,:],p)
            isos.append(iso)
        
        isos = np.array(isos)

        for i in range(len(isos)):
            iso = isos[i]
            geometry = geometries[i]
            data_point =  geometry
            data_point = np.append(data_point,iso)
            data = np.append(data,data_point)

        data = data.reshape((len(isos),len(geometry)+1))
        np.savetxt('data/data_isotropy.csv',data, delimiter=',')

if __name__ == '__main__':
    property = sys.argv[1].lower()
    problem = sys.argv[2].lower()
    E = int(sys.argv[3])*1e6
    create_df(property,problem,E)