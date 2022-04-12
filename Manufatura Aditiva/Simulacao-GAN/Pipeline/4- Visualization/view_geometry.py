import matplotlib.pyplot as plt
import numpy as np
import os
import sys

from sklearn.metrics import precision_score
from sklearn.model_selection import permutation_test_score


def get_score_filename(origin,dimension,simmetry,score):
    origins = {'-r':'RTGA','-g':'GAN'}
    if os.getcwd().split('\\')[2] == 'lucas':
        score_filename = 'E:/Lucas GAN/Dados/4- Mechanical_scores/%s/%sD/%s/%s.csv' %(origins[origin],dimension,simmetry,score)
    else:
        score_filename = 'D:/Lucas GAN/Dados/4- Mechanical_scores/%s/%sD/%s/%s.csv' %(origins[origin],dimension,simmetry,score)

    return score_filename

def create_unit(element, element_size, simmetry):
  if simmetry in ['p4']:
    unit_size = 2*element_size
    # fold_size = np.random.choice(4,1)[0]
    unit = np.ones((2*element_size,2*element_size))*(-1)
    for i in range(element_size):
      for j in range(element_size):
        el = element[i,j]
        j_ = [j,element_size-1-i,2*element_size-1-j,i+element_size]
        i_ = [i+element_size,j,element_size-1-i,2*element_size-1-j]
        # (1,7)->(7,14)->(14,8)->(8,1)
        for (k,l) in list(zip(i_,j_)):
          unit[k,l]  = el
  
  if simmetry in ['p4g','p4m']:
    unit_element_size = 2*element_size
    # fold_element_size = np.random.choice(4,1)[0]
    unit = np.ones((2*element_size,2*element_size))*(-1)
    h,w = element.shape
    for i in range(h):
      for j in range(w):
        el = element[i,j]
        
        j_ = [j,2*element_size-1-j,2*element_size-1-j,j]
        i_ = [i+element_size,i+element_size,element_size-1-i,element_size-1-i]
        # (1,2)-> (1,13) -> (14,13) -> (14,2)
        for (k,l) in list(zip(i_,j_)):
          unit[k,l]  = el

  return unit


def create_arrange(unit, units, unit_size):
  cols = rows = int(np.sqrt(units))
  arrange = np.ones((cols*unit_size,cols*unit_size))
  h,w = unit.shape
  for i in range(h):
    for j in range(w):
      for k in range(rows):
        for l in range(cols):
          arrange[i+k*unit_size,j+l*unit_size] = unit[i,j]

  return arrange

def plot_geom(origin, dimension, simmetry, element, score, score_value):
  unit = create_unit(element, element.shape[1], simmetry)
  arrange = create_arrange(unit, units, unit_size)

  fig,ax = plt.subplots(1,3)
  fig.set_size_inches((16,5))

  if score:
    fig.suptitle(f'Origin:{origin} Dimension:{dimension}D Simmetry:{simmetry} {score}:{score_value}',fontsize=16)
  else:
    fig.suptitle(f'Origin:{origin} Dimension:{dimension}D Simmetry:{simmetry}',fontsize=16)

  ax[0].imshow(element,cmap='Greys');
  # ax[0].axis('off')

  ax[1].imshow(unit,cmap='Greys');
  # ax[1].axis('off')

  ax[2].imshow(arrange,cmap='Greys');
  # ax[2].axis('off')
  plt.show()


# ////////////////////////////////////////

dimension = sys.argv[1]
origin = sys.argv[2]
simmetry = sys.argv[3]
units = int(sys.argv[4])
idx = int(sys.argv[5])

try:
  score = sys.argv[6]
  print_score = True
except:
  print_score = False

origins = {'-r':'RTGA','-g':'GAN'}

if print_score:
  score_filename = get_score_filename(origin,dimension,simmetry,score)
  score_data = np.loadtxt(score_filename,delimiter=',')
  score_value = score_data[np.where(score_data[:,0] == idx)[0][0]][-1]
  score_value = np.round(score_value,2)
else: 
  score = None
  score_value = None

if origin == "-g":
  if os.getcwd().split('\\')[2] == 'lucas':
    arrays_dir = "E:/Lucas GAN/Dados/1- Arranged_geometries/GAN/%s/%s/" % (simmetry, score)
  else:
    arrays_dir = "D:/Lucas GAN/Dados/1- Arranged_geometries/GAN/%s/%s/" % (simmetry, score)
    
else:
  if os.getcwd().split('\\')[2] == 'lucas':
    arrays_dir = "E:/Lucas GAN/Dados/1- Arranged_geometries/RTGA/%s/" % simmetry
  else:
    arrays_dir = "D:/Lucas GAN/Dados/1- Arranged_geometries/RTGA/%s/" % simmetry

arrays_filename = os.listdir(arrays_dir)
array_filename = arrays_filename[idx-1]

with open(os.path.join(arrays_dir,array_filename),'r') as f:
  element = np.array(f.readlines()).astype(float)
  element_size = int(np.sqrt(element.shape[0]))
  element = element.reshape((int(element_size),int(element_size)))
  unit_size = int(2*element_size)

plot_geom(origins[origin], dimension, simmetry, element, score, score_value) 