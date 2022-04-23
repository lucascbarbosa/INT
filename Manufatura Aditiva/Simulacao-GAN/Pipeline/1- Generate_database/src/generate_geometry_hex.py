from re import L, S
import numpy as np
from PIL import Image
from numpy.core.defchararray import array
from scipy.ndimage import sobel,measurements
from scipy.spatial.transform import Rotation as R
from skimage import measure
from skimage.measure import find_contours
import matplotlib.pyplot as plt
from math import sqrt
import sys
from hexalattice.hexalattice import *

class Generator(object):
  def __init__(self,units,simmmetry,size,porosity,num_seeds):
    self.units = units
    self.simmetry = simmmetry
    self.size = size
    self.porosity = porosity
    self.num_seeds = num_seeds

  def show_img(self,imgdata, figsize):
    hex_centers,h_ax = create_hex_grid(nx=imgdata.shape[1], ny=imgdata.shape[0])
    arr = imgdata.ravel()

    data_size, data_origin = self.get_size_origin(hex_centers)
    
    colors_face = [np.ones((1,3))*(1-arr[i]) for i in range(arr.shape[0])]
    colors_edge = [np.ones((1,3))*(int(self.get_ext_voids(hex_centers[i]-data_origin,data_size[0]))) for i in range(arr.shape[0])]

    plot_single_lattice_custom_colors(
        hex_centers[:, 0], 
        hex_centers[:, 1], 
        face_color=colors_face,
        edge_color=colors_edge,
        min_diam=1.,
        plotting_gap=0,
        rotate_deg=0)
    
    # plt.figure(figsize=figsize)
    # plt.imshow(imgdata,cmap='Greys')

  def save_img(self,imgdata,img_path):
    fig = plt.figure(frameon=False)
    ax = plt.Axes(fig, [0., 0., 1., 1.])
    ax.set_axis_off()
    fig.add_axes(ax)
    ax.imshow(imgdata,cmap='Greys')
    fig.savefig(img_path)
    plt.close(fig)

  def set_pixels(self, total_pixels):
    self.num_void_pixels = int(total_pixels*self.porosity)
    self.num_solid_pixels = total_pixels-self.num_void_pixels

  def save_array(self,array,array_path, delimiter):
    np.savetxt(array_path, array.ravel(), delimiter=delimiter)

  def get_porosity(self,geom):
    voids = np.where(geom == 0.0)[0].shape[0]

    return voids/(geom.shape[0]**2)

  def remove_isolated(self,arr,isolated):

    coords = []
    arr_ = np.copy(arr)

    for origin in range(4):
      col_origin = (origin % 2)*(len(arr)-1)
      row_origin = int(origin/2)*(len(arr)-1)
      dy = (-1)**int(origin/2)
      dx = (-1)**int(origin%2)
      for row in range(1,len(arr)-1):
        for col in range(1,len(arr)-1):
          arr = np.copy(arr_)
          is_isolated = False

          if arr[row,col] == isolated:
            for i in range(row_origin-1,row+dy,dy):
              for j in range(col_origin-1,col+dx,dx):
                if arr[i,j] == isolated:
                  arr[i,j] = max([arr[i-dy,j],arr[i,j-dx]])
            
            if arr[row-1,col] == 1.0-isolated and arr[row+1,col] == 1.0-isolated and arr[row,col-1] == 1.0-isolated and arr[row,col+1] == 1.0-isolated:
              is_isolated=True
            if is_isolated:
              coords.append([row,col])

    return np.unique(np.array(coords),axis=0)
  
  def get_ext_voids(self,center, size_x):
      
      if center[0] < 0:
        pos = center - np.array([-size_x / 2, 0])
      else:
        pos = center - np.array([size_x / 2, 0])
      
      q = np.rad2deg(np.arctan(pos[1]/pos[0]))
      
      return np.abs(q) >= 30

  def get_size_origin(self,centers):
    size = np.array(
        [np.round(max(centers[:,0]) - min(centers[:,0]),1),
        np.round(max(centers[:,1]) - min(centers[:,1]),1)])

    origin = np.array(
        [(max(centers[:,0]) + min(centers[:,0]))/2, 
        (max(centers[:,1]) + min(centers[:,1]))/2])
    
    return size, origin
  
  def center2idx(self, size, centers, center):
    dists = centers - center
    dists = np.sqrt(dists[:,0]**2 + dists[:,1]**2)
    idx = np.argmin(dists,axis=0)
    i = idx // size
    j = idx % size
    return i,j

  def get_R(self, q):
    c = np.cos(q)
    s = np.sin(q)
    R = np.array([[c, -s],[s,c]])
    return R

  def create_element(self):

    if self.simmetry == 'p3':
      
      size_x = int(self.size*np.sqrt(3)) - 4
      size_y = self.size

      element = np.ones((size_y, size_x))

      hex_centers,_ = create_hex_grid(nx=element.shape[1], ny=element.shape[0])

      element_size, element_origin = self.get_size_origin(hex_centers)
      print(element_size[0]/element_size[1])

      for i in range(element.shape[0]):
        for j in range(element.shape[1]):
          idx = i*element.shape[1] + j
          center = hex_centers[idx] - element_origin
          if self.get_ext_voids(center, element_size[0]):
            element[i,j] = 0.

      # idxs = np.where(element==1)
      # idxs_choice= np.random.choice(np.arange(idxs[0].shape[0]),self.num_seeds)
      
      # seeds_y = idxs[0][idxs_choice]
      # seeds_x = idxs[1][idxs_choice]

      # for seed_y,seed_x in list(zip(seeds_y,seeds_x)):
      #   element[seed_y,seed_x] = 0.

      # self.set_pixels(idxs[0].shape[0])

      # while np.where(element==1)[0].shape[0] > self.num_solid_pixels:
      #   contours = np.array(find_contours(element, level=0.9, fully_connected='high', positive_orientation='low'),dtype=object)
      #   for _, contour in enumerate(contours):
      #     contour_coords = np.around(contour.astype(np.double)).astype(np.uint8)
      #     size = contour.shape[0]
      #     new_voids_coords_idxs = np.random.choice(size,int(self.porosity*size))
      #     new_voids_coords = contour_coords[new_voids_coords_idxs]
      #     for new_void_coords in new_voids_coords:
      #       element[new_void_coords[0],new_void_coords[1]] = 0.

      # to_remove = self.remove_isolated(element,1.0)

      # try:
      #   element[to_remove[:,0],to_remove[:,1]] = 0.0
      # except:
      #   pass

      # to_remove = np.where(element==1)[0].shape[0] - self.num_solid_pixels

      # while to_remove > 1:
      #   contours = np.array(find_contours(element, level=0.9, fully_connected='high', positive_orientation='low'),dtype=object)
      #   for _, contour in enumerate(contours):
      #     contour_coords = np.around(contour.astype(np.double)).astype(int)
      #     contour_coords = np.unique(contour_coords, axis=0)
      #     size = contour_coords.shape[0]
      #     new_voids_coords_idxs = np.random.choice(size,int(self.porosity*size), replace=False)
      #     new_voids_coords = contour_coords[new_voids_coords_idxs,:]
      #     for new_void_coords in new_voids_coords:
      #       element[new_void_coords[0],new_void_coords[1]] = 0.
      #       to_remove -= 1
      #       if to_remove < 1:
      #         break
      
      # to_add = self.num_solid_pixels - np.where(element==1)[0].shape[0]

      # while to_add > 1:
      #   contours = np.array(find_contours(1-element, level=0.9, fully_connected='high', positive_orientation='low'),dtype=object)
      #   for _, contour in enumerate(contours):
      #     contour_coords = np.around(contour.astype(np.double)).astype(int)
      #     contour_coords = np.unique(contour_coords, axis=0)
      #     # print(np.where(self.get_ext_voids(contour_coords,element_size[0])))
      #     contour_coords_ = []
      #     for contour_coord in contour_coords:
      #       idx = contour_coord[0]*element.shape[1] + contour_coord[1]
      #       center = hex_centers[idx] - element_origin
      #       if not self.get_ext_voids(center, element_size[0]):
      #         contour_coords_.append(contour_coord)
          
      #     contour_coords_ = np.array(contour_coords_).reshape((len(contour_coords_),2))
          
      #     size = contour_coords.shape[0]
      #     new_voids_coords_idxs = np.random.choice(size,int(self.porosity*size), replace=False)
      #     new_voids_coords = contour_coords[new_voids_coords_idxs,:]
      #     for new_void_coords in new_voids_coords:
      #       element[new_void_coords[0],new_void_coords[1]] = 1.
      #       to_add -= 1
      #       if to_add < 1:
      #         break
      
    return element, hex_centers

  def create_unit(self,element, centers_element):
    if self.simmetry[:2] in ['p3']:
      
      element_size, element_origin = self.get_size_origin(centers_element)
      
      unit = np.zeros((2*element.shape[0],element.shape[1]))

      centers_unit,_ = create_hex_grid(nx=unit.shape[1], ny=unit.shape[0])

      unit_size, unit_origin =  self.get_size_origin(centers_unit)
      for i in range(element.shape[0]):
        for j in range(element.shape[1]):
          idx = i*element.shape[1] + j
          center_element = centers_element[idx] - element_origin
          centers_offset = [0, unit_size[1]/4]
          if not self.get_ext_voids(center_element, element_size[0]):
            unit[i,j] = element[i,j]
            center_unit = center_element  - centers_offset + unit_origin
            
            q1 = 2*np.pi/3
            R1 = self.get_R(q1)
            center_unit1 = np.matmul(R1,center_unit)
            i1,j1 = self.center2idx(unit.shape[1],centers_unit, center_unit1)
            unit[i1,j1] = element[i,j]

            q2 = -2*np.pi/3
            R2 = self.get_R(q2)
            center_unit2 = np.matmul(R2,center_unit)
            i2,j2 = self.center2idx(unit.shape[1],centers_unit, center_unit2)
            unit[i2,j2] = element[i,j]
  
    return unit
  
  def check_element(self, element, centers_element):
    edge_left = 0.
    edge_rigth = 0.
    idxs_bl = []
    idxs_br = []
    idxs_tl = []
    idxs_tr = []

    element_size, element_origin = self.get_size_origin(centers_element)

    edge_filter = [0, 0, 0]

    for i in range(element.shape[0]):
      for j in range(element.shape[1]):
        edge_filter[0] = edge_filter[1]
        edge_filter[1] = edge_filter[2]
        idx = i*element.shape[1] + j
        center = centers_element[idx] - element_origin
        if self.get_ext_voids(center, element_size[0]):
          edge_filter[2] = 0.
        else:
          edge_filter[2] = 1.
        if sum(edge_filter) in [1, 2]:
          print(edge_filter)
          if center[0] < element_origin[0] and center[1] < element_origin[1]:
            idxs_bl.append([i,j])
          if center[0] > element_origin[0] and center[1] < element_origin[1]:
            idxs_br.append([i,j])
          if center[0] < element_origin[0] and center[1] > element_origin[1]:
            idxs_tl.append([i,j])
          if center[0] > element_origin[0] and center[1] > element_origin[1]:
            idxs_tr.append([i,j])

    solids_tl = 0
    solids_tr = 0
    solids_bl = 0
    solids_br = 0

    for idx_tl in idxs_tl:
      solids_tl += element[idx_tl[0], idx_tl[1]]
    for idx_tr in idxs_tr:
      solids_tr += element[idx_tr[0]-1, idx_tr[1]]
    for idx_bl in idxs_bl:
      solids_bl += element[idx_bl[0], idx_bl[1]]
    for idx_br in idxs_br:
      solids_br += element[idx_br[0]+1, idx_br[1]]
    
    # print(idxs_tl)
    # print(idxs_tr)
    # print(idxs_bl)
    # print(idxs_br)
  
    print(solids_tl)  
    print(solids_tr)
    print(solids_bl)
    print(solids_br)

  def check_unit(self,unit,desired_porosity,tol):
    labels = measure.label(unit,connectivity=1)
    main_label = 0
    main_label_count = 0
    passed = True

    for label in range(1,len(np.unique(labels))):
      label_count = np.where(labels==label)[0].shape[0]
      if label_count > main_label_count:
        main_label = label
        main_label_count = label_count

    void_count = 0
    for label in range(1,len(np.unique(labels))):
      if label not in [0,main_label]:
        void_count += np.where(labels==label)[0].shape[0]
        unit[np.where(labels==label)] = 0.
    
    porosity = self.get_porosity(unit)

    if porosity > desired_porosity - tol and porosity < desired_porosity + tol:
    # if np.where(labels==0)[0].shape[0]+np.where(labels==main_label)[0].shape[0] > (1.0-tol)*unit.shape[0]*unit.shape[0]:
      for label in range(1,len(np.unique(labels))):
        if label not in [0,main_label]:
          unit[np.where(labels==label)] = 0.

      if unit[0,:].sum() > 0 and unit[:,0].sum() > 0:
        # check if there is connectivity right-left
        connections_rl = 0
        for i in range(unit.shape[0]):
          if (unit[i,0] == 1 and unit[i,-1] == 1):
            connections_rl += 1

        # check if there is connectivity top-bottom
        connections_tb = 0
        for j in range(unit.shape[1]):
          if (unit[0,j] == 1 and unit[i,-1] == 1):
            connections_tb += 1

        if connections_rl == 0 or connections_tb == 0:
          passed = False
        
      else:
        passed = False
        
    else:
      passed = False

    return passed, unit[int(unit.shape[0]/2):,:int(unit.shape[0]/2)]

  def create_arrange(self,unit):
    cols = rows = int(sqrt(self.units))
    arrange = np.ones((cols*self.unit_size,cols*self.unit_size))
    h,w = unit.shape
    for i in range(h):
      for j in range(w):
        for k in range(rows):
          for l in range(cols):
            arrange[i+k*self.unit_size,j+l*self.unit_size] = unit[i,j]

    return arrange

gen = Generator(9, 'p3', 16, 0.5, 6)
for i in range(1):
  element, centers_element = gen.create_element()
  gen.show_img(element,(6*np.sqrt(3),6))
  gen.check_element(element, centers_element)
  # unit = gen.create_unit(element, centers_element)
  # gen.show_img(unit,(6*np.sqrt(3),6))
  plt.show()

