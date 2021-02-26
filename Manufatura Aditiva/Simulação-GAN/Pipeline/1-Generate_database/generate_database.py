from src.generate_geometry import Generator
import sys

# Input hyperparameters

units = int(sys.argv[1]) #9
simmetry = sys.argv[2] #'p4'
size = int(sys.argv[3]) #16
porosity = float(sys.argv[4])  #0.5
num_seeds = int(sys.argv[5]) #3

# Dirs paths
images_dir = 'C:/Users/lucas/Documents/Github/INT/Manufatura Aditiva/Simulação-GAN/Dados/Geometries/Images/'
arrays_dir = 'C:/Users/lucas/Documents/Github/INT/Manufatura Aditiva/Simulação-GAN/Dados/Geometries/Arrays/'

try:
  data = sys.argv[6]
  if data == '-s': show = True
  elif data == '-i': save_img = True
  elif data == '-a': save_array = True
except:
  pass

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


gen = Generator(units, simmetry, size, porosity, num_seeds)

size = (1000,1000)

for i in range(10):
  arch = gen.create_arch()
  if show:
    gen.show_img(arch)
  if save_img:
    gen.save_img(arch,images_dir+'porosity_%.1f_%05d.png'%(porosity,i+1),size)
  if save_array:
    gen.save_array(arch,arrays_dir+'porosity_%.1f_%05d.txt'%(porosity,i+1),' ')
