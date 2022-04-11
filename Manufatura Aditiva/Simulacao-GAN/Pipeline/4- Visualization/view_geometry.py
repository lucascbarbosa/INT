import matplotlib.pyplot as plt
import numpy as np
import os
import sys


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

def plot_geom(origin, dimension, simmetry, score_value):
  geom = data[idx,1:-1]
  element = geom.reshape((int(len(geom)**0.5),int(len(geom)**0.5)))
  unit = create_unit(element, element.shape[1], simmetry)
  arrange = create_arrange(unit, units, unit_size)
  
  fig,ax = plt.subplots(1,3)
  fig.set_size_inches((16,5))
  fig.suptitle(f'Origin:{origin} Dimension:{dimension}D Simmetry:{simmetry} {score}:{score_value}',fontsize=16)
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
score = sys.argv[5]
idx = int(sys.argv[6])-1

origins = {'-r':'RTGA','-g':'GAN'}

score_filename = get_score_filename(origin,dimension,simmetry,score)
data = np.loadtxt(score_filename,delimiter=',')

element_size = int(np.sqrt(data.shape[1]-2))
unit_size = int(2*element_size)

score_value = np.round(data[idx,-1],2)
plot_geom(origin, dimension, simmetry, score_value) 