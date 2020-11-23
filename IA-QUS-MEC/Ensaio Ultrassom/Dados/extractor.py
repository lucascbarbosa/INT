import imp, sys, os
from scipy import signal
from scipy.fft import fftshift
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import mlflow
sns.set()

def extract_data():
    data = []
    classes = []

    # Lista de arquivos ossos desmineralização 1
    lista_arq_desm1=os.listdir('desm1/')
    # Lista de arquivos ossos desmineralização 2
    lista_arq_desm2=os.listdir('desm2/')
    # Lista de arquivos ossos desmineralização 3
    lista_arq_desm3=os.listdir('desm3/')
    total = len(lista_arq_desm1)+len(lista_arq_desm2)+len(lista_arq_desm3)
    print(len(lista_arq_desm1),len(lista_arq_desm2),len(lista_arq_desm3))
    print(f'Total = {total}')
    freq_cut = 4
    for arq in lista_arq_desm1:
        with open('desm1/'+arq,'r') as f:

            x = f.readlines()
            dt = float(x[0])
            fs = 1.0/dt
            x=np.array(x).astype(float)
            f, t, Sxx = signal.spectrogram(x, fs)
            x = Sxx[:freq_cut,:]
            data.append(x)
            classes.append([1,0,0])

    for arq in lista_arq_desm2:
        with open('desm2/'+arq,'r') as f:

            x = f.readlines()
            dt = float(x[0])
            fs = 1.0/dt
            x=np.array(x).astype(float)
            f, t, Sxx = signal.spectrogram(x, fs)
            x = Sxx[:freq_cut,:]
            data.append(x)
            classes.append([0,1,0])

    for arq in lista_arq_desm3:
        with open('desm3/'+arq,'r') as f:

            x = f.readlines()
            dt = float(x[0])
            fs = 1.0/dt
            x=np.array(x).astype(float)
            f, t, Sxx = signal.spectrogram(x, fs)
            x = Sxx[:freq_cut,:]
            data.append(x)
            classes.append([0,0,1])

    data = np.array(data)
    print(data.shape)
    return data,classes
extract_data()