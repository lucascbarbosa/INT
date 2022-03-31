import matplotlib.pyplot as plt
import numpy as np
import os
import sys

# ////////////////////////////////////////

origin = sys.argv[1]
dimension = sys.argv[2]
simmetry = sys.argv[3]
score = sys.argv[4]
idx = int(sys.argv[5])-1
origins = {'-r':'RTGA','-g':'GAN'}

def get_score_filename(origin,dimension,simmetry,score):
    origins = {'-r':'RTGA','-g':'GAN'}
    if os.getcwd().split('\\')[2] == 'lucas':
        score_filename = 'E:/Lucas GAN/Dados/4- Mechanical_scores/%s/%sD/%s/%s.csv' %(origins[origin],dimension,simmetry,score)
    else:
        score_filename = 'D:/Lucas GAN/Dados/4- Mechanical_scores/%s/%sD/%s/%s.csv' %(origins[origin],dimension,simmetry,score)

    return score_filename

def create_unit(element,size,simmetry):
  if simmetry == 'p4':
    unit_size = 2*size
    # fold_size = np.random.choice(4,1)[0]
    unit = np.ones((2*size,2*size))*(-1)
    h,w = element.shape
    for i in range(h):
      for j in range(w):
        el = element[i,j]
        
        j_ = [j,2*w-1-i,2*h-1-j,i]
        i_ = [i,j,2*w-1-i,2*h-1-j]
        # (1,7)->(7,14)->(14,8)->(8,1)
        for (k,l) in list(zip(i_,j_)):
          unit[k,l]  = el

  return unit

def create_arrange(unit,rows,cols):
  size = unit.shape[0]
  arrange = np.zeros((rows*size,cols*size))
  for i in range(unit.shape[0]):
    for j in range(unit.shape[1]):
      for row in range(rows):
        for col in range(cols):
          arrange[j+row*size,i+col*size] = unit[j,i]
  
  return arrange

score_filename = get_score_filename(origin,dimension,simmetry,score)
data = np.loadtxt(score_filename,delimiter=',')
score_value = np.round(data[idx,-1],2)

geom = data[idx,1:-1]
element = geom.reshape((int(len(geom)**0.5),int(len(geom)**0.5)))
unit = create_unit(element, element.shape[1], simmetry)
arrange = create_arrange(unit, 3, 3)

fig,ax = plt.subplots(1,3)
fig.set_size_inches((16,5))
fig.suptitle(f'Origin:{origins[origin]} Dimension:{dimension}D Simmetry:{simmetry} {score}:{score_value}',fontsize=16)
ax[0].imshow(element,cmap='Greys');
# ax[0].axis('off')

ax[1].imshow(unit,cmap='Greys');
# ax[1].axis('off')

ax[2].imshow(arrange,cmap='Greys');
# ax[2].axis('off')
plt.show()