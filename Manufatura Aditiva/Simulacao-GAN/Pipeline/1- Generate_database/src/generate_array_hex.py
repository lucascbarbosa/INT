import numpy as np
from skimage import measure
from skimage.measure import find_contours
import matplotlib.pyplot as plt
from hexalattice.hexalattice import *
from time import time

class GeneratorHex(object):
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
    # colors_edge = [np.ones((1,3))*(int(self.get_ext_voids(hex_centers[i]-data_origin,data_size[0]))) for i in range(arr.shape[0])]
    colors_edge = [(0,0,0) for i in range(arr.shape[0])]

    plot_single_lattice_custom_colors(
        hex_centers[:, 0], 
        hex_centers[:, 1], 
        face_color=colors_face,
        edge_color=colors_face,
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

  def save_array(self, element_size, array, array_path, delimiter):
    array_ = []
    array_.append(element_size)
    array_ += list(array.ravel())[:]
    array = np.array(array_)
    np.savetxt(array_path, array, delimiter=delimiter)

  def get_porosity(self, geom, total_pixels):
    voids = total_pixels - np.where(geom == 1)[0].shape[0]

    return voids/total_pixels

  def remove_isolated(self, arr, isolated):

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
      pos = center - np.array([-size_x/2-1, 0])
    else:
      pos = center - np.array([size_x/2+1, 0])
    
    q = np.rad2deg(np.arctan(pos[1]/pos[0]))
    
    return np.abs(q) > 30
  
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
      
      self.element_shape = np.array([
        self.size, 
        int(self.size*np.sqrt(3)) - 4
      ])

      element = np.ones(self.element_shape)

      hex_centers,_ = create_hex_grid(nx=element.shape[1], ny=element.shape[0])

      element_size, element_origin = self.get_size_origin(hex_centers)

      for i in range(element.shape[0]):
        for j in range(element.shape[1]):
          idx = i*element.shape[1] + j
          center = hex_centers[idx] - element_origin
          if self.get_ext_voids(center, element_size[0]):
            element[i,j] = 0.

      idxs = np.where(element==1)
      self.element_total_pixels = idxs[0].shape[0]
      idxs_choice= np.random.choice(np.arange(idxs[0].shape[0]),self.num_seeds)
      
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
          
      #     contour_coords = np.array(contour_coords_).reshape((len(contour_coords_),2))
          
      #     size = contour_coords.shape[0]
      #     new_voids_coords_idxs = np.random.choice(size,int(self.porosity*size), replace=False)
      #     new_voids_coords = contour_coords[new_voids_coords_idxs,:]
      #     for new_void_coords in new_voids_coords:
      #       element[new_void_coords[0],new_void_coords[1]] = 1.
      #       to_add -= 1
      #       if to_add < 1:
      #         break
    
    if self.simmetry == 'p3m1':

      self.element_shape = np.array([
        self.size, 
        int(self.size*np.sqrt(3)) - 4
      ])

      element = np.ones(self.element_shape)

      hex_centers,_ = create_hex_grid(nx=element.shape[1], ny=element.shape[0])

      element_size, element_origin = self.get_size_origin(hex_centers)

      for i in range(element.shape[0]):
        for j in range(element.shape[1]):
          idx = i*element.shape[1] + j
          center = hex_centers[idx] - element_origin
          if self.get_ext_voids(center, element_size[0]):
            element[i,j] = 0.

      idxs = np.where(element==1)
      self.element_total_pixels = idxs[0].shape[0]
      idxs_choice= np.random.choice(np.arange(idxs[0].shape[0]),self.num_seeds//2)
      
      seeds_y = idxs[0][idxs_choice]
      seeds_x = idxs[1][idxs_choice]

      for seed_y,seed_x in list(zip(seeds_y,seeds_x)):
        element[seed_y,seed_x] = 0.
        element[seed_y, element.shape[1]-1-seed_x] = 0.

      self.set_pixels(idxs[0].shape[0])

      while np.where(element==1)[0].shape[0] > self.num_solid_pixels:
        contours = np.array(find_contours(element, level=0.9, fully_connected='high', positive_orientation='low'),dtype=object)
        for _, contour in enumerate(contours):
          contour_coords = np.around(contour.astype(np.double)).astype(np.uint8)
          size = contour.shape[0]
          new_voids_coords_idxs = np.random.choice(size,int(self.porosity*size))
          new_voids_coords = contour_coords[new_voids_coords_idxs]
          for new_void_coords in new_voids_coords:
            element[new_void_coords[0],new_void_coords[1]] = 0.
            element[new_void_coords[0],element.shape[1]-1-new_void_coords[1]] = 0.

      to_remove = self.remove_isolated(element,1.0)

      try:
        element[to_remove[:,0],to_remove[:,1]] = 0.0
      except:
        pass

      to_remove = np.where(element==1)[0].shape[0] - self.num_solid_pixels

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
            element[new_void_coords[0],element.shape[1]-1-new_void_coords[1]] = 0.
            to_remove -= 2
            if to_remove < 1:
              break
      
      to_add = self.num_solid_pixels - np.where(element==1)[0].shape[0]

      while to_add > 1:
        contours = np.array(find_contours(1-element, level=0.9, fully_connected='high', positive_orientation='low'),dtype=object)
        for _, contour in enumerate(contours):
          contour_coords = np.around(contour.astype(np.double)).astype(int)
          contour_coords = np.unique(contour_coords, axis=0)
          # print(np.where(self.get_ext_voids(contour_coords,element_size[0])))
          contour_coords_ = []
          for contour_coord in contour_coords:
            idx = contour_coord[0]*element.shape[1] + contour_coord[1]
            center = hex_centers[idx] - element_origin
            if not self.get_ext_voids(center, element_size[0]):
              contour_coords_.append(contour_coord)
          
          contour_coords = np.array(contour_coords_).reshape((len(contour_coords_),2))
          
          size = contour_coords.shape[0]
          new_voids_coords_idxs = np.random.choice(size,int(self.porosity*size), replace=False)
          new_voids_coords = contour_coords[new_voids_coords_idxs,:]
          for new_void_coords in new_voids_coords:
            element[new_void_coords[0],new_void_coords[1]] = 1.
            element[new_void_coords[0],element.shape[1]-1-new_void_coords[1]] = 1.
            to_add -= 2
            if to_add < 1:
              break

    return element, hex_centers

  def check_element(self, element, centers_element, desired_porosity, tol=0.02, min_connections=1):

    labels = measure.label(element,connectivity=1)
    main_label = 0
    main_label_count = 0
    idxs_tl = []
    idxs_tr = []
    idxs_bl = []
    idxs_br = []
    connections_top = 0
    connections_bot = 0
    passed_top = False
    passed_bot = False

    for label in range(1,len(np.unique(labels))):
      label_count = np.where(labels==label)[0].shape[0]
      if label_count > main_label_count:
        main_label = label
        main_label_count = label_count
    
    porosity = self.get_porosity(element, self.element_total_pixels)

    void_count = 0
    for label in range(1,len(np.unique(labels))):
      if label not in [0,main_label]:
        void_count += np.where(labels==label)[0].shape[0]
        element[np.where(labels==label)] = 0.
    
    porosity = self.get_porosity(element,  self.element_total_pixels)

    if porosity <= desired_porosity + tol and porosity >= desired_porosity - tol:

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

          if sum(edge_filter) in [1,2]:
            if edge_filter[0]  == 0:
              coords = [i, j]
              idx = i*element.shape[1] + j
            elif edge_filter[0] == 1:
              coords = [i, j-2]
              idx = i*element.shape[1] + j - 2
            
            center = centers_element[idx] - element_origin
            
            if center[0] < element_origin[0] and center[1] > element_origin[1]:
              idxs_tl.append(coords)
            if center[0] > element_origin[0] and center[1] > element_origin[1]:
              idxs_tr.append(coords)
            if center[0] < element_origin[0] and center[1] < element_origin[1]:
              idxs_bl.append(coords)
            if center[0] > element_origin[0] and center[1] < element_origin[1]:
              idxs_br.append(coords)

      idxs_tl = np.array(idxs_tl).reshape((len(idxs_tl),2))
      idxs_tr = np.array(idxs_tr).reshape((len(idxs_tr),2))
      idxs_bl = np.array(idxs_bl).reshape((len(idxs_bl),2))
      idxs_br = np.array(idxs_br).reshape((len(idxs_br),2))

      for i in range(1, element.shape[0]//2):
        idxs_bl_1 = idxs_bl[np.where(idxs_bl[:,0] == i-1)]
        idxs_bl_2 = idxs_bl[np.where(idxs_bl[:,0] == i)]
        idxs_br_ = idxs_br[np.where(idxs_br[:,0] == i)]
        #  the bottom r-l connection must be satisfied to validate the unit
        try:
          if ((element[idxs_bl_1[0,0],idxs_bl_1[0,1]] == 1 or element[idxs_bl_2[0,0],idxs_bl_2[0,1]] == 1 or element[idxs_bl_2[1,0],idxs_bl_2[1,1]] == 1) and element[idxs_br_[1,0],idxs_br_[1,1]] == 1) or (element[idxs_bl_1[1,0],idxs_bl_1[1,1]] == 1 and element[idxs_br_[1,0],idxs_br_[1,1]] == 1):
            connections_bot += 1
            passed_bot = True
        except:
          pass

      for i in range(element.shape[0]//2,element.shape[0]-1):
        idxs_tl_1 = idxs_tl[np.where(idxs_tl[:,0] == i+1)]
        idxs_tl_2 = idxs_tl[np.where(idxs_tl[:,0] == i)]
        idxs_tr_ = idxs_tr[np.where(idxs_tr[:,0] == i)]
        # the top r-l connection must be satisfied to validate the element
        try:
          if ((element[idxs_tl_1[0,0],idxs_tl_1[0,1]] == 1 or element[idxs_tl_1[1,0],idxs_tl_1[1,1]] == 1  or element[idxs_tl_2[0,0],idxs_tl_2[0,1]] == 1) and element[idxs_tr_[1,0],idxs_tr_[1,1]] == 1) or (element[idxs_tl_2[0,0],idxs_tl_2[0,1]] == 1 and element[idxs_tr_[0,0],idxs_tr_[0,1]] == 1):
            connections_top += 1
            passed_top = True
        except: 
          pass
      # print(connections_bot,connections_top)

    # return connections_top > min_connections and connections_bot > min_connections
    porosity = self.get_porosity(element,  self.element_total_pixels)
    return passed_bot and passed_top and porosity > desired_porosity - tol and porosity < desired_porosity + tol

  def create_unit(self, element, centers_element):
    if self.simmetry[1:2] == '3':
      element_size, element_origin = self.get_size_origin(centers_element)
      
      unit = np.zeros((2*element.shape[0],element.shape[1]+2))
      self.unit_shape = unit.shape

      centers_unit,_ = create_hex_grid(nx=unit.shape[1], ny=unit.shape[0])

      unit_size, unit_origin =  self.get_size_origin(centers_unit)

      pixel_size = (centers_unit[1,0]-centers_unit[0,0])/np.sqrt(3)

      for i in range(element.shape[0]):
        for j in range(element.shape[1]):
          idx = i*element.shape[1] + j
          center_element = centers_element[idx] - element_origin
          centers_offset = [0, unit_size[1]/4]
          if not self.get_ext_voids(center_element, element_size[0]):
            center_unit = center_element  - centers_offset + unit_origin
            i0,j0 = self.center2idx(unit.shape[1], centers_unit, center_unit)
            unit[i0,j0] = element[i,j]
            
            q1 = 2*np.pi/3
            R1 = self.get_R(q1)
            center_unit1 = np.matmul(R1,center_unit) + [0.5*pixel_size*np.sqrt(3), 1.5*pixel_size]
            i1,j1 = self.center2idx(unit.shape[1],centers_unit, center_unit1)
            if unit[i1,j1] == 0:
              unit[i1,j1] = element[i,j]

            q2 = -2*np.pi/3
            R2 = self.get_R(q2)
            center_unit2 = np.matmul(R2,center_unit) + [-1*pixel_size*np.sqrt(3), 1.5*pixel_size]
            i2,j2 = self.center2idx(unit.shape[1],centers_unit, center_unit2)
            if unit[i2,j2] == 0:
              unit[i2,j2] = element[i,j]
            
    return unit, centers_unit
  
  def create_arrange(self, element, unit, units, centers_unit):
    rows = int(np.sqrt(units))
    cols = int(np.sqrt(units))
    
    arrange = np.zeros((int((1+(rows-1)*3/4)*self.unit_shape[0]),int((cols+0.5)*self.unit_shape[1])))
    centers_arrange,_ = create_hex_grid(nx=arrange.shape[1], ny=arrange.shape[0])
    arrange_size, arrange_origin =  self.get_size_origin(centers_arrange)

    h,w = unit.shape
    unit_size, unit_origin =  self.get_size_origin(centers_unit)
    centers_offset = [((2*cols-1)/4)*unit_size[0], ((rows-1)*3/8)*unit_size[1]]
    pixel_size = (centers_unit[1,0]-centers_unit[0,0])/np.sqrt(3)
    for i in range(h):
      for j in range(w):
        idx = i*unit.shape[1] + j
        center_unit = centers_unit[idx] - unit_origin
        center_arrange = center_unit  - centers_offset + arrange_origin

        for k in range(2):
          for l in range(2):
            disp = np.array([
              l*(unit_size[0]+pixel_size*np.sqrt(3))+(k%2)*(unit_size[0]/2-0.25*pixel_size*np.sqrt(3)),
              k*(0.75*unit_size[1]+0.75*pixel_size) + ((-1)**(l%2==0))*0.75*pixel_size
              ])
            center = center_arrange + disp 
            i_, j_ = self.center2idx(arrange.shape[1], centers_arrange, center)

            if unit[i,j]:
              try:
                arrange[i_,j_] = unit[i,j]
              except:
                pass
    return arrange

units = 9
simmetry = 'p3'
size =  16
desired_porosity = 0.5
seeds = 6
gen = GeneratorHex(units, simmetry, size, desired_porosity, seeds)

size = 10
for i in range(size):
  passed = False
  while passed == False:
    element, centers_element = gen.create_element()
    passed = gen.check_element(element, centers_element, desired_porosity, min_connections=1)
    passed = True

  # gen.show_img(element,(6*np.sqrt(3),6))

  unit, centers_unit= gen.create_unit(element, centers_element)
  # gen.show_img(unit,(6*np.sqrt(3),6))

  arrange = gen.create_arrange(element, unit, units, centers_unit)
  gen.show_img(arrange,(6*np.sqrt(3),6))
  
  plt.show()

