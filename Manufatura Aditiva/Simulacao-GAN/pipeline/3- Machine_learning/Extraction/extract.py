from numpy.core.defchararray import array
import pandas as pd
import os
import numpy as np
import sys
def calculate_isotropy(Es):
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
            array_dir = 'E:/Lucas GAN/Dados/1- Arranged_geometries/GAN/%s/%s/' %(simmetry,score)
            property_dir = 'E:/Lucas GAN/Dados/3- Mechanical_properties/%s/GAN/%sD/%s/%s/' %(property,dimension,simmetry,score)
            score_filename = 'E:/Lucas GAN/Dados/4- Mechanical_scores/GAN/%sD/%s/%s.csv' %(dimension,simmetry,score)
        else:
            array_dir = 'D:/Lucas GAN/Dados/1- Arranged_geometries/GAN/%s/%s/' %(simmetry,score)
            property_dir = 'D:/Lucas GAN/Dados/3- Mechanical_properties/%s/GAN/%sD/%s/' %(property,dimension,simmetry,score)
            score_filename = 'D:/Lucas GAN/Dados/4- Mechanical_scores/GAN/%sD/%s/%s.csv' %(dimension,simmetry,score)
    
    elif origin == "-r":
        if os.getcwd().split('\\')[2] == 'lucas':
            array_dir = 'E:/Lucas GAN/Dados/1- Arranged_geometries/RTGA/%s/' %(simmetry)
            property_dir = 'E:/Lucas GAN/Dados/3- Mechanical_properties/%s/RTGA/%sD/%s/' %(property,dimension,simmetry)
            score_filename = 'E:/Lucas GAN/Dados/4- Mechanical_scores/RTGA/%sD/%s/%s.csv' %(dimension,simmetry,score)
        else:
            array_dir = 'E:/Lucas GAN/Dados/1- Arranged_geometries/RTGA/%s/' %(simmetry)
            property_dir = 'E:/Lucas GAN/Dados/3- Mechanical_properties/%s/RTGA/%sD/%s/' %(property,dimension,simmetry)
            score_filename = 'E:/Lucas GAN/Dados/4- Mechanical_scores/RTGA/%sD/%s/%s.csv' %(dimension,simmetry,score)
    
    elif origin == "-m":
        if os.getcwd().split('\\')[2] == 'lucas':
            array_dir = 'E:/Lucas GAN/Dados/1- Arranged_geometries/RTGA/%s/' %(simmetry)
            property_dir = 'E:/Lucas GAN/Dados/3- Mechanical_properties/%s/MATLAB/%sD/%s/' %(property,dimension,simmetry)
            score_filename = 'E:/Lucas GAN/Dados/4- Mechanical_scores/MATLAB/%sD/%s/%s.csv' %(dimension,simmetry,score)
        else:
            array_dir = 'E:/Lucas GAN/Dados/1- Arranged_geometries/RTGA/%s/' %(simmetry)
            property_dir = 'E:/Lucas GAN/Dados/3- Mechanical_properties/%s/MATLAB/%sD/%s/' %(property,dimension,simmetry)
            score_filename = 'E:/Lucas GAN/Dados/4- Mechanical_scores/MATLAB/%sD/%s/%s.csv' %(dimension,simmetry,score)
    
    
    Es = np.array([])
    porosities = []
    geometries = []
    models = []
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
            if origin == '-g':
                model = int(simulation[:-4].split('_')[2])
                models.append(model)
            Es = np.append(Es,Es_simulation)
            geometry = np.loadtxt(os.path.join(array_dir,simulation),delimiter='\n').astype(int)
            size = geometry[0]
            geometry = geometry[1:]
            # geometry = geometry.reshape((size,size)).ravel()
            geometries.append(geometry)
            idxs.append(int(simulation.split('_')[0]))
            passed += 1
    
    Es = np.array(Es).reshape((passed,len(Es_simulation)))
    porosities = np.array(porosities).reshape(len(porosities),1)
    if origin == '-g':
        models = np.array(models).reshape(len(models),1)
    geometries = np.array(geometries).astype(int)
    idxs = np.array(idxs).reshape(len(idxs),1)

    if score == 'isotropy':
        isos = []
        data = np.array([])

        for i in range(len(Es)):
            iso = calculate_isotropy(Es[i,:])
            isos.append(iso)
        
        isos = np.array(isos).reshape(len(isos),1)
        for i in range(len(isos)):
            idx = idxs[i]
            model = models[i]
            geometry = geometries[i]
            iso = isos[i]
            if origin == '-r':
                data_point =  np.concatenate([idx,geometry,iso])
            if origin == '-g':
                data_point =  np.concatenate([idx,model,geometry,iso])
            data = np.append(data,data_point,axis=0)
        
    if score == 'hs':
        hss = []
        data = np.array([])

        for i in range(len(Es)):
            p = porosities[i]
            hs = calculate_HS(Es[i,:],E,p)
            hss.append(hs)
        
        hss = np.array(hss).reshape(len(hss),1)

        for i in range(len(hss)):
            idx = idxs[i]
            hs = hss[i]
            geometry = geometries[i]
            if origin == '-r':
                data_point =  np.concatenate([idx,geometry,hs])
            if origin == '-g':
                data_point =  np.concatenate([idx,model,geometry,hs])
            data = np.append(data,data_point,axis=0)

        data = data.reshape((len(hss),len(geometry)+2))
    
    if origin == '-g':
        data = data.reshape((len(isos),len(geometry)+3))
    if origin == '-r':
        data = data.reshape((len(isos),len(geometry)+2))

    np.savetxt(score_filename,data, delimiter=',')

if __name__ == '__main__':
    dimension = sys.argv[1]
    origin = sys.argv[2]
    property = sys.argv[3].lower()
    score = sys.argv[4].lower()
    simmetry = sys.argv[5]
    E = float(sys.argv[6])*1e9

    create_df(dimension, property,origin,score,simmetry,E)