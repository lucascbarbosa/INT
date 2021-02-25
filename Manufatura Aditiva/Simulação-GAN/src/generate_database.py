import numpy as np
from PIL import Image
from scipy.ndimage import sobel,measurements
from skimage.measure import find_contours
import matplotlib.pyplot as plt
from math import sqrt

class Generator(object):

  def __init__(self,units,simmmetry,size,porosity,num_seeds):
    self.units = units
    self.simmetry = simmmetry
    self.size = size
    self.porosity = porosity
    num_pixels = size*size
    self.num_void_pixels = int(num_pixels*self.porosity)
    self.num_solid_pixels = int(num_pixels-self.num_void_pixels)
    self.num_seeds = num_seeds

  def show_img(self,imgdata):
    plt.imshow(imgdata,cmap='Greys')
    plt.show()
  
  def get_porosity(self,element):
    voids = np.where(element == 0.0)[0].shape[0]
    return voids/(self.size**2)

  def crete_element(self,show=False):
    element = np.ones((self.size,self.size))
    seeds_x = np.random.choice(self.size,self.num_seeds)
    seeds_y = np.random.choice(self.size,self.num_seeds)

    for seed_x,seed_y in list(zip(seeds_x,seeds_y)):
      element[seed_x,seed_y] = 0
    
    while np.where(element==0)[0].shape[0] < self.num_void_pixels:
      contours = np.array(find_contours(element, level=0.9, fully_connected='high', positive_orientation='low'))
      for _, contour in enumerate(contours):
        contour_coords = contour.round().astype(int)
        size = contour.shape[0]
        new_voids_coords_idxs = np.random.choice(size,int(self.porosity*size))
        new_voids_coords = contour_coords[new_voids_coords_idxs]
        for new_void_coords in new_voids_coords:
          element[new_void_coords[0],new_void_coords[1]] = 0
    
    to_remove = np.where(element==0)[0].shape[0]-self.num_void_pixels
    solids_idx_x = np.random.choice(np.where(element==0)[0],to_remove)
    solids_idx_y = np.random.choice(np.where(element==0)[1],to_remove)

    for solid_idx_x,solid_idx_y in list(zip(solids_idx_x,solids_idx_y)):
      element[solid_idx_x,solid_idx_y] = 1.
    
    # self.show_img(element)
    phases = measurements.label(element)[0]
    uniques,counts =  np.unique(phases, return_counts=True)
    percolated_solid = counts.argsort()[-2:][::-1]
    percolated_solid = percolated_solid[np.where(percolated_solid!=0)[0]][0]
    isolated_solids = np.delete(uniques,[0,percolated_solid])
    percolated_idxs = []

    for idx in zip(*np.where(phases==percolated_solid)):
      percolated_idxs.append(idx)

    for isolated_solid in isolated_solids:
      isolated_solid_ys = np.where(phases==isolated_solid)[0]
      isolated_solid_xs = np.where(phases==isolated_solid)[1]
      
      distance_mins = []
      i_mins = []
      j_mins = []

      for isolated_solid_x,isolated_solid_y in list(zip(isolated_solid_xs,isolated_solid_ys)):
        distance_min = self.size*sqrt(2)
        i_min, j_min = 0, 0
        for i,j in percolated_idxs:
          distance = abs(i-isolated_solid_y)+abs(j-isolated_solid_x)
          if distance < distance_min:
            distance_min = distance
            i_min = i
            j_min = j
        i_mins.append(i_min)
        j_mins.append(j_min)
        distance_mins.append(distance_min)

      distance_min = min(distance_mins)
      distance_min_idx = distance_mins.index(distance_min)
      isolated_solid_x, isolated_solid_y = isolated_solid_xs[distance_min_idx], isolated_solid_ys[distance_min_idx]
      i = i_mins[distance_min_idx]
      j = j_mins[distance_min_idx]
      
      while isolated_solid_x < j:
        isolated_solid_x += 1
        element[isolated_solid_y,isolated_solid_x] = 1.0

      while isolated_solid_x > j:
        isolated_solid_x -= 1
        element[isolated_solid_y,isolated_solid_x] = 1.0

      while isolated_solid_y < i:
        isolated_solid_y += 1
        element[isolated_solid_y,isolated_solid_x] = 1.0

      while isolated_solid_y > i:
        isolated_solid_y -= 1
        element[isolated_solid_y,isolated_solid_x] = 1.0
    if show:
      self.show_img(element)
    return element

  def create_unit(self,show=False):
    element = self.crete_element(show)
    if self.simmetry == 'p4':
      self.unit_size = 2*self.size
      fold_size = np.random.choice(4,1)[0]
      unit = np.ones((2*self.size,2*self.size))*(-1)
      h,w = element.shape
      print(fold_size)
      for i in range(h):
        for j in range(w):
          el = element[i,j]
          i_ = i+self.size*(fold_size//2)
          j_ = j+self.size*(fold_size%2)
          unit[i_,j_] = el
          for k in [i_,2*self.size-1-i_]:
            for l in [j_,2*self.size-1-j_]:
              unit[k,l] = el
          
    if show:
      self.show_img(unit)
    return unit

  def create_arch(self,show=False):
    unit = self.create_unit(show)
    cols = rows = int(sqrt(self.units))
    arch = np.ones((cols*self.unit_size,cols*self.unit_size))
    print(arch.shape)
    h,w = unit.shape
    for i in range(h):
      for j in range(w):
        for k in range(rows):
          for l in range(cols):
            arch[i+k*self.unit_size,j+l*self.unit_size] = unit[i,j]
        
    if show:
      self.show_img(arch)

if __name__ == "__main__":
  
  # Hyperparameters
  units = 9
  simmetry = 'p4'
  size = 16
  porosity = 0.5
  num_seeds = 3

  gen = Generator(units, simmetry, size, porosity, num_seeds)

  gen.create_arch(True)

    