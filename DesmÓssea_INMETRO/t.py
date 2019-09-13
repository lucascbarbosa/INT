import pandas as pd
import os
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report,confusion_matrix
from sklearn.svm import SVC
import matplotlib.pyplot as plt


# Lista de arquivos ossos original (sem desmineralização)
lista_arq_ossos=os.listdir('Dados/original/')
# Lista de arquivos ossos desmineralização 1
lista_arq_desm1=os.listdir('Dados/desm1/')
# Lista de arquivos ossos desmineralização 2
lista_arq_desm2=os.listdir('Dados/desm2/')
# Lista de arquivos ossos desmineralização 3
lista_arq_desm3=os.listdir('Dados/desm3/')

# Quantidade total de sinais
total_signal = len(lista_arq_ossos)+len(lista_arq_desm1)+len(lista_arq_desm2)+len(lista_arq_desm3)+1

# Matriz zerada para comportar todos os sinais
ossos = np.zeros((total_signal,15997))
# Matriz zerada para comportar todas as classes
classes = np.zeros((total_signal))

data_len = 15999

# Lendo os sinais de ossos sem desmineralização
i=0
# Lendo os sinais de ossos desmineralização 1
for nome2 in lista_arq_desm1:
	arq = open('Dados/desm1/'+nome2,'r')
	data = arq.readlines()
	data = [float(x) for x in data]
	data = data [2:data_len]
	ossos[i,:]=data
#	classes[i,:] = [0., 1., 0., 0.]
	classes[i] = 1
	i = i+1
	data=0
	arq.close()

# Lendo os sinais de ossos desmineralização 2
for nome3 in lista_arq_desm2:
	arq = open('Dados/desm2/'+nome3,'r')
	data = arq.readlines()
	data = [float(x) for x in data]
	data = data [2:data_len]
	ossos[i,:]=data
#	classes[i,:] = [0., 0., 1., 0.]
	classes[i] = 2
	i = i+1
	data=0
	arq.close()

# Lendo os sinais de ossos desmineralização 3
for nome4 in lista_arq_desm3:
	arq = open('Dados/desm3/'+nome4,'r')
	data = arq.readlines()
	data = [float(x) for x in data]
	data = data [2:data_len]
	ossos[i,:]=data
#	classes[i,:] = [0., 0., 0., 1.]
	classes[i] = 3
	i = i+1
	data=0
	arq.close()

ossos = ossos[0:i,:]
classes = classes[0:i]
