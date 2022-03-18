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

def create_df(dimension,property,origin,score,simmetry,E):
    if origin == "-g":
        if os.getcwd().split('\\')[2] == 'lucas':
            property_dir = 'E:/Lucas GAN/Dados/3- Mechanical_properties/%s/GAN/%sD/%s/' %(property,dimension,simmetry)
            array_dir = 'E:/Lucas GAN/Dados/1- Arranged_geometries/GAN/%s/' %(simmetry)
            score_filename = 'E:/Lucas GAN/Dados/4- Mechanical_scores/GAN/%sD/%s/%s.csv' %(dimension,simmetry,score)
        else:
            property_dir = 'D:/Lucas GAN/Dados/3- Mechanical_properties/%s/GAN/%sD/%s/' %(property,dimension,simmetry)
            array_dir = 'D:/Lucas GAN/Dados/1- Arranged_geometries/GAN/%s/' %(simmetry)
            score_filename = 'D:/Lucas GAN/Dados/4- Mechanical_scores/GAN/%sD/%s/%s.csv' %(dimension,simmetry,score)
    else:
        if os.getcwd().split('\\')[2] == 'lucas':
            property_dir = 'E:/Lucas GAN/Dados/3- Mechanical_properties/%s/RTGA/%sD/%s/' %(property,dimension,simmetry)
            array_dir = 'E:/Lucas GAN/Dados/1- Arranged_geometries/RTGA/%s/' %(simmetry)
            score_filename = 'E:/Lucas GAN/Dados/4- Mechanical_scores/RTGA/%sD/%s/%s.csv' %(dimension,simmetry,score)
        else:
            property_dir = 'E:/Lucas GAN/Dados/3- Mechanical_properties/%s/RTGA/%sD/%s/' %(property,dimension,simmetry)
            array_dir = 'E:/Lucas GAN/Dados/1- Arranged_geometries/RTGA/%s/' %(simmetry)
            score_filename = 'E:/Lucas GAN/Dados/4- Mechanical_scores/RTGA/%sD/%s/%s.csv' %(dimension,simmetry,score)
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

    if score == 'isotropy':
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
    
    if score == 'hs':
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
    
    np.savetxt(score_filename,data, delimiter=',')


if __name__ == '__main__':
    dimension = sys.argv[1]
    origin = sys.argv[2]
    property = sys.argv[3].lower()
    score = sys.argv[4].lower()
    simmetry = sys.argv[5]
    E = float(sys.argv[6])*1e9
    create_df(dimension, property,origin,score,simmetry,E)