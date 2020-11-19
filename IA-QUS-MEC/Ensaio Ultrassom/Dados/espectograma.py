import os
from scipy import signal
from scipy.fft import fftshift
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import mlflow

sns.set()

# Lista de arquivos ossos original (sem desmineralização)
lista_arq_ossos=os.listdir('original/')
# Lista de arquivos ossos desmineralização 1
lista_arq_desm1=os.listdir('desm1/')
# Lista de arquivos ossos desmineralização 2
lista_arq_desm2=os.listdir('desm2/')
# Lista de arquivos ossos desmineralização 3
lista_arq_desm3=os.listdir('desm3/')

with open('desm3/'+lista_arq_desm3[10],'r') as f:
    data = f.readlines()
    fs = 1.0/float(data[0])
    x = data[2:]
    x = list(map(lambda x: float(x),x))
    x=np.array(x)
    f, t, Sxx = signal.spectrogram(x, fs)
    data = Sxx[:15,:]
    print(f)