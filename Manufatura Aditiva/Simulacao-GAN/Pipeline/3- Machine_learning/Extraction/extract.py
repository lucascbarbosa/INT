from numpy.core.defchararray import array
import pandas as pd
import os
import numpy as np
import sys
def calculate_isotropy(Es,p):
    m, M = Es.min(),Es.max()
    return 1.0 - ((M-m)/((M+m)))

def calculate_HS(Es,E,p):
    m, M = Es.min(),Es.max()
    E_mean = (M+m)/2.0
    E_HS = E*(1-p)/(1+2*p)
    return E_mean/E_HS

def create_df(property,origin,problem,simmetry,E):
    if origin == "-g":
        property_dir = 'D:/Lucas GAN/Dados/3- Mechanical_properties/%s/GAN/%s/'%(property,simmetry)
        array_dir = 'D:/Lucas GAN/Dados/1- Arranged_geometries/Arrays/GAN/%s/'%(simmetry)
    else:
        property_dir = 'D:/Lucas GAN/Dados/3- Mechanical_properties/%s/%s/'%(property,simmetry)
        array_dir = 'D:/Lucas GAN/Dados/1- Arranged_geometries/Arrays/%s/'%(simmetry)
    
    Es = np.array([])
    porosities = []
    geometries = []
    idxs = []

    passed = 0

    simulations = os.listdir(property_dir)
    for simulation in simulations:
        try:
            Es_simulation = np.loadtxt(os.path.join(property_dir,simulation),delimiter='/n')
        except:
            Es_simulation = np.zeros(2)
        
        try:
            tmp = Es_simulation[0]
        except:
            Es_simulation = [0.0,0.0]

        if Es_simulation[0] != 0.0 and Es_simulation[1] != 0.0:
            porosity = float(simulation[:-4].split('_')[-1])
            porosities.append(porosity)
            Es = np.append(Es,Es_simulation)
            geometry = np.loadtxt(os.path.join(array_dir,simulation),delimiter='\n').astype(int)
            geometry = geometry.reshape((int(np.sqrt(len(geometry))), int(np.sqrt(len(geometry))))).ravel()
            geometries.append(geometry)
            idxs.append(int(simulation.split('_')[0]))
            passed += 1
    
    Es = np.array(Es).reshape((passed,len(Es_simulation)))
    porosities = np.array(porosities)
    geometries = np.array(geometries).astype(int)
    idxs = np.array(idxs)

    if problem == 'isotropy':
        isos = []
        data = np.array([])

        for i in range(len(Es)):
            p = 1.0-porosities[i]
            iso = calculate_isotropy(Es[i,:],p)
            isos.append(iso)
        
        isos = np.array(isos)

        for i in range(len(isos)):
            idx = np.array([idxs[i]])
            iso = np.array([isos[i]])
            geometry = geometries[i]
            data_point =  np.concatenate([idx,geometry,iso])
            data = np.append(data,data_point,axis=0)

        data = data.reshape((len(isos),len(geometry)+2))
        if origin == "-g":
            np.savetxt('data/GAN/%s/%s.csv'%(simmetry,problem),data, delimiter=',')
        else:
            np.savetxt('data/%s/%s.csv'%(simmetry,problem),data, delimiter=',')
    
    if problem == 'hs':
        hss = []
        data = np.array([])

        for i in range(len(Es)):
            p = porosities[i]
            hs = calculate_HS(Es[i,:],E,p)
            hss.append(hs)
        
        hss = np.array(hss)

        for i in range(len(hss)):
            idx = np.array([idxs[i]])
            hs = np.array([hss[i]])
            geometry = geometries[i]
            data_point =  np.concatenate([idx,geometry,hs])
            data = np.append(data,data_point,axis=0)

        data = data.reshape((len(hss),len(geometry)+2))
        if origin == "-g":
            np.savetxt('data/GAN/%s/%s.csv'%(simmetry,problem),data, delimiter=',')
        else:
            np.savetxt('data/%s/%s.csv'%(simmetry,problem),data, delimiter=',')


if __name__ == '__main__':
    origin = sys.argv[1]
    property = sys.argv[2].lower()
    problem = sys.argv[3].lower()
    simmetry = sys.argv[4]
    E = float(sys.argv[5])*1e9
    create_df(property,origin,problem,simmetry,E)