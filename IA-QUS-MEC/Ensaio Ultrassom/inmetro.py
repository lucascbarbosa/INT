import keras
from keras.callbacks import EarlyStopping
from keras.models import Sequential
from keras.optimizers import SGD
from keras.layers import Conv1D, Dense, Dropout, Activation, MaxPooling1D, Flatten
from sklearn.model_selection import train_test_split
from keras.utils import Sequence
import matplotlib.pyplot as plt
import numpy as np
import os
import pandas as pd
import scipy as sp
from scipy.signal import butter, lfilter
from scipy.signal import freqs


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
# Matriz zerada para comportar todas as classess
#classes = np.zeros((total_signal,4))
classes = np.zeros((total_signal,3))

data_len = 15999

# Lendo os sinais de ossos sem desmineralização
i=0
#for nome1 in lista_arq_ossos:
#	arq = open('Dados/original/'+nome1,'r')
#	data = arq.readlines()
#	data = [float(x) for x in data]
#	data = data [2:data_len]
#	ossos[i,:]=data
#	classes[i,:] = [1., 0., 0., 0.]
#	i = i+1
#	data=0
#	arq.close()

# Lendo os sinais de ossos desmineralização 1
for nome2 in lista_arq_desm1:
	arq = open('Dados/desm1/'+nome2,'r')
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
	arq = open('Dados/desm2/'+nome3,'r')
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
	arq = open('Dados/desm3/'+nome4,'r')
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
"""
def butter_lowpass(cutoff, fs, order=5):
    nyq = 0.5 * fs
    normal_cutoff = cutoff / nyq
    b, a = butter(order, normal_cutoff, btype='low', analog=False)
    return b, a

def butter_lowpass_filter(data, cutoff, fs, order=5):
    b, a = butter_lowpass(cutoff, fs, order=order)
    y = lfilter(b, a, data)
    return y


# Filter requirements.
order = 6
fs = 2000    # sample rate, Hz
cutoff =3 # desired cutoff frequency of the filter, Hz

# Get the filter coefficients so we can check its frequency response.
b, a = butter_lowpass(cutoff, fs, order)

# Demonstrate the use of the filter.
# First make some data to be filtered.
n = 15997 # total number of samples
T = int(n/fs)        # seconds
t = np.linspace(0, T, n, endpoint=False)

ossos_filtered = np.zeros((total_signal,15997))

def filterData(data,cutoff,fs,order):
    # Filter the data, and plot both the original and filtered signals.
    y = butter_lowpass_filter(data, cutoff, fs, order)
    return y

for i in range(len(ossos)):
    # "Noisy" data. 
    data = ossos[i,:]
    y = filterData(data,cutoff,fs,order)
    ossos_filtered[i,:] = y

"""
# Para plotar o sinal de ossos
#plt.plot(ossos[0,:])
#plt.ylabel('Bone signal')
#plt.show()

#########################################

num_samples=total_signal-1
samples_len=ossos[0,:].size
len_smp=129 # 2666; 1333; 129
split=124 # 6; 12; 124
#num_class=4
num_class=3

X = ossos
Y = classes

X_train, X_test, y_train, y_test = train_test_split(X, Y, test_size=0.3, shuffle=True)

# Reshape signal to matrix signal_length
print(X_train)
X_train = X_train.reshape(X_train.shape[0], len_smp, split).astype('float32')
X_test = X_test.reshape(X_test.shape[0], len_smp, split).astype('float32') 
print(X_train)

"""
# Modelando a rede
model = Sequential()
# MODELO USADO PARA SEPARAR NORMAL X DESMINERALIZADO
#model.add(Conv1D(filters=60, kernel_size=30, input_shape=(len_smp, split)))
#model.add(MaxPooling1D(pool_size=5))
#model.add(Dropout(0.5))
#model.add(Conv1D(filters=30, kernel_size=5, input_shape=(len_smp, split)))
#model.add(MaxPooling1D(pool_size=5))
#model.add(Dropout(0.5))

##############################################
# TESTE PARA SEPARAR 3 NIVEIS DE DESMINERALIZACAO
model.add(Conv1D(filters=128, kernel_size=30, padding='same', input_shape=(len_smp, split)))
model.add(Activation('relu'))
model.add(MaxPooling1D(pool_size=5))

model.add(Conv1D(filters=128, kernel_size=15, padding='same', input_shape=(len_smp, split)))
model.add(Activation('relu'))
model.add(MaxPooling1D(pool_size=5))

model.add(Conv1D(filters=128, kernel_size=5, padding='same', input_shape=(len_smp, split)))
model.add(Activation('relu'))
model.add(MaxPooling1D(pool_size=5))

##############################################
model.add(Flatten())
model.add(Dense(256, activation='relu')) #256
model.add(Dropout(0.55))
model.add(Dense(512, activation='relu')) #512
model.add(Dropout(0.55))
model.add(Dense(1024, activation='relu')) #1024
model.add(Dropout(0.55))
model.add(Dense(3, activation='softmax'))

#model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['categorical_accuracy'])
model.compile(optimizer='adam', loss='mean_squared_error', metrics=['categorical_accuracy'])

# saves the model weights after each epoch if the validation loss decreased
# checkpointer = ModelCheckpoint(filepath='/Documentos/weights.hdf5', verbose=1, save_best_only=True)

# Early stopping
callback = [EarlyStopping(monitor='val_loss', min_delta=0, patience=10, verbose=1, mode='min', baseline=None, restore_best_weights=True)]

#model.fit(X_train, y_train, epochs=10 ,validation_data=(X_test, y_test), steps_per_epoch=200, validation_steps=200)
history = model.fit(X_train, y_train, batch_size=30, epochs=50, shuffle='True', validation_data=(X_test, y_test),callbacks = callback)

print(history.history.keys())
# summarize history for accuracy
plt.plot(history.history['categorical_accuracy'])
plt.plot(history.history['val_categorical_accuracy'])
plt.title('model accuracy')
plt.ylabel('accuracy')
plt.xlabel('epoch')
plt.legend(['train', 'test'], loc='upper left')
plt.show()
# summarize history for loss
plt.plot(history.history['loss'])
plt.plot(history.history['val_loss'])
plt.title('model loss')
plt.ylabel('loss')
plt.xlabel('epoch')
plt.legend(['train', 'test'], loc='upper left')
plt.show()

# Criando modelo para predição
ynew = model.predict_classess(X_test)
# ynew = model.predict_proba(Xnew)
# show the inputs and predicted outputs
for i in range(len(X_test)):
	z = np.nonzero(y_test[i])
	#print("result=%s, Predicted=%s" % (z[0], ynew[i]))
	print(z[0], ynew[i])
print('A média é %f' %(float(sum(history.history.keys)/len(history.history.keys))))
# plotando uma senoide
#Fs = 8000
#f = 5
#sample = 8000
#x1 = np.arange(sample)
#y1 = np.sin(2 * np.pi * f * x / Fs)
#plt.plot(x1, y1)
#plt.xlabel('sample(n)')
#plt.ylabel('voltage(V)')
#plt.show()
"""