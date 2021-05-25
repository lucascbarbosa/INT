from src.generate_geometry import Generator
import sys
import numpy as np
import matplotlib.pyplot as plt

# Input hyperparameters

units = int(sys.argv[1]) #9
simmetry = sys.argv[2] #'p4'
size = int(sys.argv[3]) #16
porosity = float(sys.argv[4])  #0.5
num_seeds = int(sys.argv[5]) #3
samples = int(sys.argv[6]) #10'000

# Dirs paths
images_dir = 'C:/Users/lucas/Documents/Github/INT/Manufatura Aditiva/Simulacao-GAN/Dados/1- Arranged_geometries/Images/'
arrays_dir = 'C:/Users/lucas/Documents/Github/INT/Manufatura Aditiva/Simulacao-GAN/Dados/1- Arranged_geometries/Arrays/'

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

# pors = []

gen = Generator(units, simmetry, size, porosity, num_seeds)

for i in range(1000,samples+1000):
  element = gen.create_element()
  porosity = np.float32(gen.get_porosity(element)).round(4)
  if show:
    gen.show_img(element)
  if save_img:
    gen.save_img(element,images_dir+'%05d_porosity_%.4f.png'%(i+1,porosity))
  if save_array:
    gen.save_array(element,arrays_dir+'%05d_porosity_%.4f.txt'%(i+1,porosity),' ') 

  # pors.append(gen.get_porosity(element))

# plt.hist(pors, bins=20)
# plt.show()