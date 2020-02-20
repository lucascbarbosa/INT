import os

listarq = os.listdir('sinais/wfm')

for arq in listarq:
    f = open('sinais/csv/'+arq.split('.')[0]+'.csv','w')
    f.close()