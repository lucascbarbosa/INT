import numpy as np
from PIL import Image
from scipy.ndimage import sobel,measurements
from skimage.measure import find_contours
import matplotlib.pyplot as plt
from math import sqrt
import sys

class Generator(object):

  def __init__(self,units,simmmetry,size,porosity,num_seeds):
    self.units = units
    self.simmetry = simmmetry
    self.size = size
    self.porosity = porosity
    num_pixels = size**2
    self.num_void_pixels = int(num_pixels*self.porosity)
    self.num_solid_pixels = int(num_pixels-self.num_void_pixels)
    self.num_seeds = num_seeds

  def show_img(self,imgdata):
    plt.imshow(imgdata,cmap='Greys')
    plt.show()

  def save_img(self,imgdata,img_path):
    fig = plt.figure(frameon=False)
    ax = plt.Axes(fig, [0., 0., 1., 1.])
    ax.set_axis_off()
    fig.add_axes(ax)
    ax.imshow(imgdata,cmap='Greys')
    fig.savefig(img_path)
    plt.close(fig)

  def save_array(self,array,array_path, delimiter):
    np.savetxt(array_path, array.ravel(), delimiter=delimiter)

  def get_porosity(self,element):
    voids = np.where(element == 0.0)[0].shape[0]

    return voids/(self.size**2)

  def create_element(self):

    element = np.ones((self.size,self.size))
    seeds_x = np.random.choice(self.size,self.num_seeds)
    seeds_y = np.random.choice(self.size,self.num_seeds)

    for seed_x,seed_y in list(zip(seeds_x,seeds_y)):
      element[seed_x,seed_y] = 0.
    
    while np.where(element==0)[0].shape[0] < self.num_void_pixels:
      contours = np.array(find_contours(element, level=0.9, fully_connected='high', positive_orientation='low'),dtype=object)
      for _, contour in enumerate(contours):
        contour_coords = np.around(contour.astype(np.double)).astype(np.uint8)
        size = contour.shape[0]
        new_voids_coords_idxs = np.random.choice(size,int(self.porosity*size))
        new_voids_coords = contour_coords[new_voids_coords_idxs]
        for new_void_coords in new_voids_coords:
          element[new_void_coords[0],new_void_coords[1]] = 0.

    element[0,:] = 1.
    element[element.shape[0]-1,:] = 1.
    element[:,0] = 1.
    element[:,element.shape[0]-1] = 1.

    to_remove = self.num_void_pixels - np.where(element==0)[0].shape[0]

    if to_remove > 1:
      while to_remove > 1:
        contours = np.array(find_contours(element, level=0.9, fully_connected='high', positive_orientation='low'),dtype=object)
        for _, contour in enumerate(contours):
          contour_coords = np.around(contour.astype(np.double)).astype(int)
          contour_coords = np.unique(contour_coords, axis=0)
          size = contour_coords.shape[0]
          new_voids_coords_idxs = np.random.choice(size,int(self.porosity*size), replace=False)
          new_voids_coords = contour_coords[new_voids_coords_idxs,:]
          for new_void_coords in new_voids_coords:
            element[new_void_coords[0],new_void_coords[1]] = 0.
            to_remove -= 1
            if to_remove < 1:
              break

    element[0,:] = 1.
    element[element.shape[0]-1,:] = 1.
    element[:,0] = 1.
    element[:,element.shape[0]-1] = 1.

    to_add = self.num_solid_pixels - np.where(element==1)[0].shape[0]

    if to_add > 1:
      while to_add > 1:
        contours = np.array(find_contours(1-element, level=0.9, fully_connected='high', positive_orientation='low'),dtype=object)
        for _, contour in enumerate(contours):
          contour_coords = np.around(contour.astype(np.double)).astype(int)
          contour_coords = np.unique(contour_coords, axis=0)
          size = contour_coords.shape[0]
          new_voids_coords_idxs = np.random.choice(size,int(self.porosity*size), replace=False)
          new_voids_coords = contour_coords[new_voids_coords_idxs,:]
          for new_void_coords in new_voids_coords:
            element[new_void_coords[0],new_void_coords[1]] = 1.
            to_add -= 1
            if to_add < 1:
              break

    phases = measurements.label(element)[0]
    uniques,counts =  np.unique(phases, return_counts=True)
    percolated_solid = counts.argsort()[-2:][::-1]
    percolated_solid = percolated_solid[np.where(percolated_solid!=0)[0]][0]
    isolated_solids = np.delete(uniques,[0,percolated_solid])
    percolated_idxs = []

    for isolated_solid in isolated_solids:
      element[np.where(phases==isolated_solid)[0]] = 0.0

    element[0,:] = 1.
    element[element.shape[0]-1,:] = 1.
    element[:,0] = 1.
    element[:,element.shape[0]-1] = 1.
    
    print(element)

    # remove isolated 0s
    void_phases = measurements.label(1-element)[0]

    print(void_phases)
    
    for phase in np.unique(void_phases):
      if np.where(void_phases==phase)[0].shape[0] == 1:
        element[np.where(void_phases==phase)[0]] = 1.0
    
    print(element)
    
    return element

  def create_unit(self):
    element = self.create_element()
    if self.simmetry == 'p4':
      self.unit_size = 2*self.size
      fold_size = np.random.choice(4,1)[0]
      unit = np.ones((2*self.size,2*self.size))*(-1)
      h,w = element.shape
      for i in range(h):
        for j in range(w):
          el = element[i,j]
          i_ = i+self.size*(fold_size//2)
          j_ = j+self.size*(fold_size%2)
          unit[i_,j_] = el
          for k in [i_,2*self.size-1-i_]:
            for l in [j_,2*self.size-1-j_]:
              unit[k,l] = el
          
    return unit

  def create_arch(self):
    unit = self.create_unit()
    cols = rows = int(sqrt(self.units))
    arch = np.ones((cols*self.unit_size,cols*self.unit_size))
    h,w = unit.shape
    for i in range(h):
      for j in range(w):
        for k in range(rows):
          for l in range(cols):
            arch[i+k*self.unit_size,j+l*self.unit_size] = unit[i,j]

    return arch