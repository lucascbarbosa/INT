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

# Dirs paths
images_dir = 'D:/Lucas GAN/Dados/1- Arranged_geometries/Images/RTGA/'
arrays_dir = 'D:/Lucas GAN/Dados/1- Arranged_geometries/Arrays/RTGA/'

show = False
save_img = False
save_array = False

try:
  data = sys.argv[7]
  if data == '-s': show = True
  elif data == '-i': save_img = True
  elif data == '-a': save_array = True
except:
  pass

try:
  data = sys.argv[8]
  if data == '-s': show = True
  elif data == '-i': save_img = True
  elif data == '-a': save_array = True
except:
  pass

try:
  data = sys.argv[9]
  if data == '-s': show = True
  elif data == '-i': save_img = True
  elif data == '-a': save_array = True
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
    if show:
      gen.show_img(unit)
      gen.show_img(arch)
    if save_img:
      gen.save_img(unit,images_dir+simmetry+'/%05d_porosity_%.4f.png'%(correct_samples+start+1,porosity))
    if save_array:
      gen.save_array(element,arrays_dir+simmetry+'/%05d_porosity_%.4f.txt'%(correct_samples+start+1,porosity),' ') 
    correct_samples += 1