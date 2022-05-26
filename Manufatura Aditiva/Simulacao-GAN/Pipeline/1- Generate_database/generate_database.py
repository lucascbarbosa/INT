from sympy import E
from src.generate_geometry_hex import GeneratorHex
from src.generate_geometry_quad import GeneratorQuad
from hexalattice.hexalattice import *
import sys
import numpy as np
import os
import matplotlib.pyplot as plt
from time import time

def plot_geom(element, unit, arrange, simmetry):
  if simmetry[:2] in ['p4']:
    fig,ax = plt.subplots(1,3)
    fig.set_size_inches((16,5))
    ax[0].imshow(element,cmap='Greys');
    # ax[0].axis('off')

    ax[1].imshow(unit,cmap='Greys');
    # ax[1].axis('off')

    ax[2].imshow(arrange,cmap='Greys');
    # ax[2].axis('off')
  
  if simmetry[:2] in ['p3','p6']:
    centers_element,_ = create_hex_grid(nx=element.shape[1], ny=element.shape[0])
    arr = element.ravel()
    colors_face = [np.ones((1,3))*(1-arr[i]) for i in range(arr.shape[0])]
    plot_single_lattice_custom_colors(
      centers_element[:, 0], 
      centers_element[:, 1], 
      face_color=colors_face,
      edge_color=colors_face,
      min_diam=1.,
      plotting_gap=0,
      rotate_deg=0
    )

    # centers_unit,_ = create_hex_grid(nx=unit.shape[1], ny=unit.shape[0])
    # arr = unit.ravel()
    # colors = [np.ones((1,3))*(1-arr[i]) for i in range(arr.shape[0])]
    # plot_single_lattice_custom_colors(
    #   centers_unit[:, 0], 
    #   centers_unit[:, 1], 
    #   face_color=colors,
    #   edge_color=colors,
    #   min_diam=1.,
    #   plotting_gap=0,
    #   rotate_deg=0
    # )

    # centers_arrange,_ = create_hex_grid(nx=arrange.shape[1], ny=arrange.shape[0])
    # arr = arrange.ravel()
    # colors = [np.ones((1,3))*(1-arr[i]) for i in range(arr.shape[0])]
    # plot_single_lattice_custom_colors(
    #   centers_arrange[:, 0], 
    #   centers_arrange[:, 1], 
    #   face_color=colors,
    #   edge_color=colors,
    #   min_diam=1.,
    #   plotting_gap=0,
    #   rotate_deg=0
    # )
    
  plt.show()

# Input hyperparameters
units = int(sys.argv[1]) #9
simmetry = sys.argv[2] 
size = int(sys.argv[3]) #16
desired_porosity = float(sys.argv[4]) 
num_seeds = int(sys.argv[5]) 
tol = float(sys.argv[6]) #0.02
samples = int(sys.argv[7]) #10'000

if os.getcwd().split('\\')[2] == 'lucas':

  # Dirs paths
  arrays_dir = 'E:/Lucas GAN/Dados/1- Arranged_geometries/RTGA/'
else:
  arrays_dir = 'D:/Lucas GAN/Dados/1- Arranged_geometries/RTGA/'

plot = False # -p
save_array = False # -s
plot_hist = False # -h

try:
  data = sys.argv[8]
  if data == '-p': plot = True
  elif data == '-s': save_array = True
  elif data == '-h': plot_hist = True
except:
  pass

try:
  data = sys.argv[9]
  if data == '-p': plot = True
  elif data == '-s': save_array = True
  elif data == '-h': plot_hist = True
except:
  pass

try:
  data = sys.argv[10]
  if data == '-p': plot = True
  elif data == '-s': save_array = True
  elif data == '-h': plot_hist = True
except:
  pass

start_time = time()

if simmetry[:2] in ['p3','p6']:
  gen = GeneratorHex(units, simmetry, size, desired_porosity, num_seeds)
  start = len(os.listdir(arrays_dir+simmetry))
  porosities = []
  correct_samples = 0
  while correct_samples < samples:
    element, centers_element = gen.create_element()
    passed = gen.check_element(element, centers_element, desired_porosity, min_connections=1)
    porosity = np.float32(gen.get_porosity(element,gen.element_total_pixels)).round(4)
    if passed:
      print(passed)
      porosities.append(porosity)
      if plot:
        unit, centers_unit= gen.create_unit(element, centers_element)
        arrange = gen.create_arrange(element, unit, units, centers_unit)
        plot_geom(element, unit, arrange, simmetry)
      if save_array:
        gen.save_array(element,arrays_dir+simmetry+'/%05d_porosity_%.4f.txt'%(correct_samples+start+1,porosity),' ') 
      correct_samples += 1

  if plot_hist:
    plt.hist(porosities, bins=10)
    plt.show()

if simmetry[:2] in ['p4']:
  gen = GeneratorQuad(units, simmetry, size, desired_porosity, num_seeds)
  start = len(os.listdir(arrays_dir+simmetry))
  porosities = []

  correct_samples = 0
  while correct_samples < samples:
    element = gen.create_element()
    unit = gen.create_unit(element)
    passed, element = gen.check_unit(unit,desired_porosity,tol)
    porosity = np.float32(gen.get_porosity(element)).round(4)
    if passed:
      porosities.append(porosity)
      if plot:
        arrange = gen.create_arrange(unit)
        plot_geom(element, unit, arrange, simmetry)
      if save_array:
        gen.save_array(element,arrays_dir+simmetry+'/%05d_porosity_%.4f.txt'%(correct_samples+start+1,porosity),' ') 
      correct_samples += 1

  if plot_hist:
    plt.hist(porosities, bins=10)
    plt.show()

end_time = time()
print('TET: %f'%(end_time-start_time))