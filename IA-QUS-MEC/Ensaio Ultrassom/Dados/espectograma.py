import os
from scipy import signal
from scipy.fft import fftshift
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import mlflow
sns.set()

# Lista de arquivos ossos original (sem desmineralização)
lista_arq_original=os.listdir('original/')
# Lista de arquivos ossos desmineralização 1
lista_arq_desm1=os.listdir('desm1/')
# Lista de arquivos ossos desmineralização 2
lista_arq_desm2=os.listdir('desm2/')
# Lista de arquivos ossos desmineralização 3
lista_arq_desm3=os.listdir('desm3/')

fig,axs = plt.subplots(2)
with open('desm3/'+lista_arq_desm3[2],'r') as f:
    data = f.readlines()
    dt = float(data[0])
    fs = 1.0/dt
    x = data[8000:11000]
    x = list(map(lambda x: float(x),x))
    x=np.array(x)
    t = [dt*i for i in range(len(x))]
    axs[0].plot(t,x)
    axs[0].set_title('Ultrasound signal')
    axs[0].set_ylabel('Amplitude')
    axs[0].set_xlabel('Time [sec]')
    f, t, Sxx = signal.spectrogram(x, fs)
    # data = Sxx[:15,:]


axs[1].pcolormesh(t, f, Sxx, shading='gouraud')
axs[1].set_title('Spectogram')
axs[1].set_ylabel('Frequency [Hz]')
axs[1].set_xlabel('Time [sec]')
plt.show()