from src.generate_geometry import Generator
import sys
import numpy as np
import os

# Input hyperparameters

units = int(sys.argv[1]) #9
simmetry = sys.argv[2] #p4/m
size = int(sys.argv[3]) #16
porosity = float(sys.argv[4])  #0.5
num_seeds = int(sys.argv[5]) #3/4
samples = int(sys.argv[6]) #10'000

if os.getcwd().split('\\')[2] == 'lucas':

  # Dirs paths
  arrays_dir = 'E:/Lucas GAN/Dados/1- Arranged_geometries/RTGA/'
else:
  arrays_dir = 'D:/Lucas GAN/Dados/1- Arranged_geometries/RTGA/'

plot = False
save_array = False

try:
  data = sys.argv[7]
  if data == '-p': plot = True
  elif data == '-s': save_array = True
except:
  pass

try:
  data = sys.argv[8]
  if data == '-p': plot = True
  elif data == '-s': save_array = True
except:
  pass

gen = Generator(units, simmetry, size, porosity, num_seeds)
start = len(os.listdir(arrays_dir+simmetry))

correct_samples = 0
while correct_samples < samples:
  element = gen.create_element()
  unit = gen.create_unit(element)
  passed, element = gen.check_unit(unit,porosity*0.1)
  porosity = np.float32(gen.get_porosity(element)).round(4)
  arch = gen.create_arch(unit)
  if passed:
    if plot:
      # gen.show_img(unit)
      gen.show_img(arch)
    if save_array:
      gen.save_array(element,arrays_dir+simmetry+'/%05d_porosity_%.4f.txt'%(correct_samples+start+1,porosity),' ') 
    correct_samples += 1