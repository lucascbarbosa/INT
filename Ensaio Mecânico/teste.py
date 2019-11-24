import pandas as pd
import os
import numpy as np
import seaborn as sb
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report
from sklearn.neighbors import KNeighborsClassifier

# Lista de arquivos ossos original (sem desmineralização)
lista_arq_ossos=os.listdir('CNN_osso/original/')
# Lista de arquivos ossos desmineralização 1
lista_arq_desm1=os.listdir('CNN_osso/desm1/')
# Lista de arquivos ossos desmineralização 2
lista_arq_desm2=os.listdir('CNN_osso/desm2/')
# Lista de arquivos ossos desmineralização 3
lista_arq_desm3=os.listdir('CNN_osso/desm3/')

# Quantidade total de sinais
total_signal = len(lista_arq_ossos)+len(lista_arq_desm1)+len(lista_arq_desm2)+len(lista_arq_desm3)+1

# Matriz zerada para comportar todos os sinais
ossos = np.zeros((total_signal,15997))
# Matriz zerada para comportar todas as classes
classes = np.zeros((total_signal,3))

data_len = 15999

# Lendo os sinais de ossos sem desmineralização
i=0
# Lendo os sinais de ossos desmineralização 1
for nome2 in lista_arq_desm1:
	arq = open('CNN_osso/desm1/'+nome2,'r')
	data = arq.readlines()
	data = [float(x) for x in data]
	data = data [2:data_len]
	ossos[i,:]=data
#	classes[i,:] = [0., 1., 0., 0.]
	classes[i,:] = [1, 0, 0]
	i = i+1
	data=0
	arq.close()

# Lendo os sinais de ossos desmineralização 2
for nome3 in lista_arq_desm2:
	arq = open('CNN_osso/desm2/'+nome3,'r')
	data = arq.readlines()
	data = [float(x) for x in data]
	data = data [2:data_len]
	ossos[i,:]=data
#	classes[i,:] = [0., 0., 1., 0.]
	classes[i,:] = [0, 1, 0]
	i = i+1
	data=0
	arq.close()

# Lendo os sinais de ossos desmineralização 3
for nome4 in lista_arq_desm3:
	arq = open('CNN_osso/desm3/'+nome4,'r')
	data = arq.readlines()
	data = [float(x) for x in data]
	data = data [2:data_len]
	ossos[i,:]=data
#	classes[i,:] = [0., 0., 0., 1.]
	classes[i,:] = [0, 0, 1]
	i = i+1
	data=0
	arq.close()

ossos = ossos[0:i,:]
classes = classes[0:i,:]
ossos_df = pd.DataFrame(columns='Sinais Desm1 Desm2 Desm3'.split(' '))
""""for i in range(total_signal):
    osso = ossos[i]
    desm1 = classes[i,0]
    desm2 = classes[i,1]
    desm3 = classes[i,2]
    ossos_df.at[i,'Sinais'] = osso
    ossos_df.at[i,'Desm1'] = desm1
    ossos_df.at[i,'Desm2'] = desm2    
    ossos_df.at[i,'Desm3'] = desm3   """"

X = result.drop(['Desm1','Desm2','Desm3'],axis=1)
y = result['Desm3']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3)
lr_model = LogisticRegression()
lr_model.fit(X_train, y_train)
predictions = lr_model.predict(X_test)
print(classification_report(y_test, predictions))
