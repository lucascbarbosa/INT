import matplotlib.pyplot as plt
from hexalattice.hexalattice import *

import numpy as np
import os
import sys

from sklearn.metrics import precision_score
from sklearn.model_selection import permutation_test_score

def get_score_filename(origin, dimension, simmetry, score):
  origins = {'-r':'RTGA','-g':'GAN'}
  if os.getcwd().split('\\')[2] == 'lucas':
      score_filename = 'E:/Lucas GAN/Dados/4- Mechanical_scores/%s/%sD/%s/%s.csv' %(origins[origin],dimension,simmetry,score)
  else:
      score_filename = 'D:/Lucas GAN/Dados/4- Mechanical_scores/%s/%sD/%s/%s.csv' %(origins[origin],dimension,simmetry,score)

  return score_filename

def get_ext_voids(center, size_x):
  if center[0] < 0:
    pos = center - np.array([-size_x/2-1, 0])
  else:
    pos = center - np.array([size_x/2+1, 0])
  
  q = np.rad2deg(np.arctan(pos[1]/pos[0]))
  
  return np.abs(q) > 30

def get_R(q):
  c = np.cos(q)
  s = np.sin(q)
  R = np.array([[c, -s],[s,c]])
  return R

def center2idx(size, centers, center):
  dists = centers - center
  dists = np.sqrt(dists[:,0]**2 + dists[:,1]**2)
  idx = np.argmin(dists,axis=0)
  if toprint:
    print(np.argsort(dists)[:5])
    print(centers[np.argsort(dists)[:5]])
  i = idx // size
  j = idx % size
  return i,j

def get_size_origin(centers):
  size = np.array(
      [np.round(max(centers[:,0]) - min(centers[:,0]),1),
      np.round(max(centers[:,1]) - min(centers[:,1]),1)])

  origin = np.array(
      [(max(centers[:,0]) + min(centers[:,0]))/2, 
      (max(centers[:,1]) + min(centers[:,1]))/2])
  
  return size, origin

toprint = False

def create_unit(element, element_shape, simmetry):
  if simmetry[1:] == '4':
    element_size = element_shape[0]
    unit_size = 2*element_size
    # fold_size = np.random.choice(4,1)[0]
    unit = np.ones((2*element_size,2*element_size))*(-1)
    for i in range(element_size):
      for j in range(element_size):
        el = element[i,j]
        j_ = [j,element_size-1-i,unit_size-1-j,i+element_size]
        i_ = [i+element_size,j,element_size-1-i,unit_size-1-j]
        # (1,7)->(7,14)->(14,8)->(8,1)
        for (k,l) in list(zip(i_,j_)):
          unit[k,l]  = el
    return unit
  
  if simmetry[1:] in ['4g','4m']:
    element_size = element_shape[0]
    unit_element_size = 2*element_size
    # fold_element_size = np.random.choice(4,1)[0]
    unit = np.ones((2*element_size,2*element_size))*(-1)
    h,w = element.shape
    for i in range(h):
      for j in range(w):
        el = element[i,j]
        j_ = [j,unit_element_size-1-j,unit_element_size-1-j,j]
        i_ = [i+element_size,i+element_size,element_size-1-i,element_size-1-i]
        # (1,2)-> (1,13) -> (14,13) -> (14,2)
        for (k,l) in list(zip(i_,j_)):
          unit[k,l]  = el
    return unit

  if simmetry[1:2] == '3':
    centers_element,_ = create_hex_grid(nx=element_shape[1], ny=element_shape[0])
    element_size, element_origin = get_size_origin(centers_element)
    
    unit = np.zeros((2*element.shape[0],element.shape[1]+2))

    centers_unit,_ = create_hex_grid(nx=unit.shape[1], ny=unit.shape[0])

    unit_size, unit_origin =  get_size_origin(centers_unit)

    pixel_size = (centers_unit[1,0]-centers_unit[0,0])/np.sqrt(3)

    for i in range(element.shape[0]):
      for j in range(element.shape[1]):
        idx = i*element.shape[1] + j
        center_element = centers_element[idx] - element_origin
        centers_offset = [0, unit_size[1]/4]
        if not get_ext_voids(center_element, element_size[0]):
          center_unit = center_element  - centers_offset + unit_origin
          i0,j0 = center2idx(unit.shape[1], centers_unit, center_unit)
          unit[i0,j0] = element[i,j]

          q1 = 2*np.pi/3
          R1 = get_R(q1)
          center_unit1 = np.matmul(R1,center_unit) + [0.5*pixel_size*np.sqrt(3), 1.5*pixel_size]
          i1,j1 = center2idx(unit.shape[1], centers_unit, center_unit1)
          if unit[i1,j1] == 0:
            unit[i1,j1] = element[i,j]
          
          q2 = -2*np.pi/3
          R2 = get_R(q2)
          center_unit2 = np.matmul(R2,center_unit) + [-1*pixel_size*np.sqrt(3), 1.5*pixel_size]
          i2,j2 = center2idx(unit.shape[1], centers_unit, center_unit2)
          if unit[i2,j2] == 0:
            unit[i2,j2] = element[i,j]
    return unit, centers_unit


def create_arrange(unit, units, centers_unit=None):
  if simmetry[1:2] == '3':
    rows = int(np.sqrt(units))
    cols = int(np.sqrt(units))
    
    arrange = np.zeros((int((1+(rows-1)*3/4)*unit.shape[0]),int((cols+0.5)*unit.shape[1])))
    centers_arrange,_ = create_hex_grid(nx=arrange.shape[1], ny=arrange.shape[0])
    arrange_size, arrange_origin =  get_size_origin(centers_arrange)

    h,w = unit.shape
    unit_size, unit_origin =  get_size_origin(centers_unit)
    centers_offset = [((2*cols-1)/4)*unit_size[0], ((rows-1)*3/8)*unit_size[1]]
    pixel_size = (centers_unit[1,0]-centers_unit[0,0])/np.sqrt(3)

    for i in range(h):
      for j in range(w):
        idx = i*unit.shape[1] + j
        center_unit = centers_unit[idx] - unit_origin
        center_arrange = center_unit  - centers_offset + arrange_origin

        for k in range(rows):
          for l in range(cols):
            disp = np.array([
              l*unit_size[0]+(k%2)*unit_size[0]/2-0.5*pixel_size*np.sqrt(3),
              k*3*unit_size[1]/4 + (-1)**(l%2==0)*0.75*pixel_size
              ])
            center = center_arrange + disp 
            i_, j_ = center2idx(arrange.shape[1], centers_arrange, center)

            if unit[i,j]:
              try:
                arrange[i_,j_] = unit[i,j]
              except:
                pass
  
  if simmetry[1:2] == '4':
    cols = rows = int(np.sqrt(units))
    unit_size = unit.shape[0]
    arrange = np.ones((cols*unit_size,cols*unit_size))
    h,w = unit.shape
    for i in range(h):
      for j in range(w):
        for k in range(rows):
          for l in range(cols):
            arrange[i+k*unit_size,j+l*unit_size] = unit[i,j]
    
  return arrange


def plot_geom(origin, dimension, simmetry, element, unit, arrange, score, score_value):
  if simmetry[1:2] == '4':

    unit = create_unit(element, element.shape, simmetry)
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
  if simmetry[1:2] in ['3','6']:
    centers_element,_ = create_hex_grid(nx=element.shape[1], ny=element.shape[0])
    arr = element.ravel()
    colors_face = [np.ones((1,3))*(1-arr[i]) for i in range(arr.shape[0])]
    # colors_edge = [(0,0,0) for i in range(arr.shape[0])]

    fig,ax = plt.subplots(1,3)
    fig.set_size_inches((16,5))

    ax[0] = plot_single_lattice_custom_colors(
      centers_element[:, 0], 
      centers_element[:, 1], 
      face_color=colors_face,
      edge_color=colors_face,
      min_diam=1.,
      plotting_gap=0,
      rotate_deg=0, 
      h_fig=fig,
      h_ax=ax[0]
    )

    centers_unit,_ = create_hex_grid(nx=unit.shape[1], ny=unit.shape[0])
    arr = unit.ravel()
    colors_face = [np.ones((1,3))*(1-arr[i]) for i in range(arr.shape[0])]
    ax[1] = plot_single_lattice_custom_colors(
      centers_unit[:, 0], 
      centers_unit[:, 1], 
      face_color=colors_face,
      edge_color=colors_face,
      min_diam=1.,
      plotting_gap=0,
      rotate_deg=0, 
      h_fig=fig,
      h_ax=ax[1]
    )

    centers_arrange,_ = create_hex_grid(nx=arrange.shape[1], ny=arrange.shape[0])
    arr = arrange.ravel()
    colors_face = [np.ones((1,3))*(1-arr[i]) for i in range(arr.shape[0])]
    ax[2] = plot_single_lattice_custom_colors(
      centers_arrange[:, 0], 
      centers_arrange[:, 1], 
      face_color=colors_face,
      edge_color=colors_face,
      min_diam=1.,
      plotting_gap=0,
      rotate_deg=0, 
      h_fig=fig,
      h_ax=ax[2]
    )

  plt.show()


# ////////////////////////////////////////

dimension = sys.argv[1] 
origin = sys.argv[2]
simmetry = sys.argv[3]
units = int(sys.argv[4])
idx = int(sys.argv[5])

# dimension = 2 
# origin = "-r"
# simmetry = "p3"
# units = 9
# idx = 11

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
  array = np.array(f.readlines()).astype(float)
  element = array[1:]
  element_shape = [int(array[0]),int(element.shape[0]/array[0])]
  element = element.reshape(element_shape)
  if simmetry[1:2] == '4':
    unit_size = 2*element_shape
    unit = create_unit(element, element_shape, simmetry)
    arrange = create_arrange(unit, units)

  if simmetry[1:2] == '3':
    unit_size = [element_shape[0],2*element_shape[1]]
    unit,centers_unit = create_unit(element, element_shape, simmetry)
    arrange = create_arrange(unit, units, centers_unit)

plot_geom(origins[origin], dimension, simmetry, element, unit, arrange, score, score_value) 