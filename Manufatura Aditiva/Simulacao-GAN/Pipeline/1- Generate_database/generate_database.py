from src.generate_geometry import Generator
import sys
import numpy as np
import os
import matplotlib.pyplot as plt

def plot_geom(element, unit, arrange):
  fig,ax = plt.subplots(1,3)
  fig.set_size_inches((16,5))
  ax[0].imshow(element,cmap='Greys');
  # ax[0].axis('off')

  ax[1].imshow(unit,cmap='Greys');
  # ax[1].axis('off')

  ax[2].imshow(arrange,cmap='Greys');
  # ax[2].axis('off')
  plt.show()

# Input hyperparameters

units = int(sys.argv[1]) #9
simmetry = sys.argv[2] #p4/m/g
size = int(sys.argv[3]) #16
porosity = float(sys.argv[4])  #0.5
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

gen = Generator(units, simmetry, size, porosity, num_seeds)
start = len(os.listdir(arrays_dir+simmetry))

porosities = []

correct_samples = 0
while correct_samples < samples:
  element = gen.create_element()
  unit = gen.create_unit(element)
  passed, element = gen.check_unit(unit,tol)
  porosity = np.float32(gen.get_porosity(element)).round(4)
  arrange = gen.create_arrange(unit)
  # passed = True
  if passed:
    porosities.append(porosity)
    if plot:
      plot_geom(element, unit, arrange)
    if save_array:
      gen.save_array(element,arrays_dir+simmetry+'/%05d_porosity_%.4f.txt'%(correct_samples+start+1,porosity),' ') 
    correct_samples += 1

if plot_hist:
  plt.hist(porosities, bins=10)
  plt.show()