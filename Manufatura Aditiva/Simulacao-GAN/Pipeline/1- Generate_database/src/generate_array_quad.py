import numpy as np
from skimage import measure
from skimage.measure import find_contours
from math import sqrt

class GeneratorQuad(object):
  def __init__(self,units,simmmetry,size,porosity,num_seeds):
    self.units = units
    self.simmetry = simmmetry
    self.size = size
    self.porosity = porosity
    self.num_seeds = num_seeds

  def set_pixels(self, total_pixels):
    self.num_void_pixels = int(total_pixels*self.porosity)
    self.num_solid_pixels = total_pixels-self.num_void_pixels

  def save_array(self, element_size, array, array_path, delimiter):
    array_ = []
    array_.append(element_size)
    array_ += list(array.ravel())[:]
    array = np.array(array_)
    np.savetxt(array_path, array, delimiter=delimiter)

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

  def create_element(self):

    if self.simmetry == 'p4':
      
      element = np.ones((self.size,self.size))
      seeds_x = np.random.choice(np.arange(1,self.size-1),self.num_seeds)
      seeds_y = np.random.choice(np.arange(1,self.size-1),self.num_seeds)

      for seed_x,seed_y in list(zip(seeds_x,seeds_y)):
        element[seed_x,seed_y] = 0.

      self.set_pixels(element.shape[0]*element.shape[1])
      
      while np.where(element==0)[0].shape[0] < self.num_void_pixels:
        contours = np.array(find_contours(element, level=0.9, fully_connected='high', positive_orientation='low'),dtype=object)
        for _, contour in enumerate(contours):
          contour_coords = np.around(contour.astype(np.double)).astype(np.uint8)
          size = contour.shape[0]
          new_voids_coords_idxs = np.random.choice(size,int(self.porosity*size))
          new_voids_coords = contour_coords[new_voids_coords_idxs]
          for new_void_coords in new_voids_coords:
            element[new_void_coords[0],new_void_coords[1]] = 0.

      to_remove = self.remove_isolated(element,1.0)

      try:
        element[to_remove[:,0],to_remove[:,1]] = 0.0
      except:
        pass

      to_remove = self.num_void_pixels - np.where(element==0)[0].shape[0]

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

      to_add = self.num_solid_pixels - np.where(element==1)[0].shape[0]

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

    if self.simmetry == 'p4m':
      element = np.ones((self.size,self.size))
      seeds_x = np.random.choice(np.arange(1,self.size-1),int(self.num_seeds/2))
      seeds_y = np.random.choice(np.arange(1,self.size-1),int(self.num_seeds/2))

      for seed_x,seed_y in list(zip(seeds_x,seeds_y)):
        element[seed_x,seed_y] = 0.
        element[self.size-seed_y-1,self.size-seed_x-1] = 0.

      self.set_pixels(element.shape[0]*element.shape[1])

      while np.where(element==0)[0].shape[0] < self.num_void_pixels:
        contours = np.array(find_contours(element, level=0.9, fully_connected='high', positive_orientation='low'),dtype=object)
        for _, contour in enumerate(contours):
          contour_coords = np.around(contour.astype(np.double)).astype(np.uint8)
          size = contour.shape[0]
          new_voids_coords_idxs = np.random.choice(size,int(self.porosity*size))
          new_voids_coords = contour_coords[new_voids_coords_idxs]
          for new_void_coords in new_voids_coords:
            element[new_void_coords[0],new_void_coords[1]] = 0.
            element[self.size-new_void_coords[1]-1,self.size-new_void_coords[0]-1] = 0.
      
      to_remove = self.remove_isolated(element,1.0)
      
      try:
        element[to_remove[:,0],to_remove[:,1]] = 0.0
      except:
        pass

      to_remove = self.num_void_pixels - np.where(element==0)[0].shape[0]

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
            element[self.size-new_void_coords[1]-1,self.size-new_void_coords[0]-1] = 0.
            to_remove -= 2
            if to_remove < 1:
              break
      
      to_add = self.num_solid_pixels - np.where(element==1)[0].shape[0]

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
            element[self.size-new_void_coords[1]-1,self.size-new_void_coords[0]-1] = 1.
            to_add -= 2
            if to_add < 1:
              break
    
    if self.simmetry == 'p4g':
      element = np.ones((self.size,self.size))
      seeds_x = np.random.choice(np.arange(1,self.size-1),int(self.num_seeds/2))
      seeds_y = np.random.choice(np.arange(1,self.size-1),int(self.num_seeds/2))

      for seed_x,seed_y in list(zip(seeds_x,seeds_y)):
        element[seed_x,seed_y] = 0.
        element[seed_y,seed_x] = 0.

      self.set_pixels(element.shape[0]*element.shape[1])

      while np.where(element==0)[0].shape[0] < self.num_void_pixels:
        contours = np.array(find_contours(element, level=0.9, fully_connected='high', positive_orientation='low'),dtype=object)
        for _, contour in enumerate(contours):
          contour_coords = np.around(contour.astype(np.double)).astype(np.uint8)
          size = contour.shape[0]
          new_voids_coords_idxs = np.random.choice(size,int(self.porosity*size))
          new_voids_coords = contour_coords[new_voids_coords_idxs]
          for new_void_coords in new_voids_coords:
            element[new_void_coords[0],new_void_coords[1]] = 0.
            element[new_void_coords[1],new_void_coords[0]] = 0.
      
      to_remove = self.remove_isolated(element,1.0)
      
      try:
        element[to_remove[:,0],to_remove[:,1]] = 0.0
      except:
        pass

      to_remove = self.num_void_pixels - np.where(element==0)[0].shape[0]

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
            element[new_void_coords[1],new_void_coords[0]] = 0.
            to_remove -= 2
            if to_remove < 1:
              break
      
      to_add = self.num_solid_pixels - np.where(element==1)[0].shape[0]

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
            element[new_void_coords[1],new_void_coords[0]] = 1.
            to_add -= 2
            if to_add < 1:
              break

    return element

  def create_unit(self,element):
    if self.simmetry[:2] in ['p4']:
      self.unit_size = 2*self.size
      # fold_size = np.random.choice(4,1)[0]
      unit = np.ones((2*self.size,2*self.size))*(-1)
      for i in range(self.size):
        for j in range(self.size):
          el = element[i,j]
          j_ = [j,self.size-1-i,2*self.size-1-j,i+self.size]
          i_ = [i+self.size,j,self.size-1-i,2*self.size-1-j]
          # (1,7)->(7,14)->(14,8)->(8,1)
          for (k,l) in list(zip(i_,j_)):
            unit[k,l]  = el
    
    if self.simmetry in ['p4g','p4m']:
      self.unit_size = 2*self.size
      # fold_size = np.random.choice(4,1)[0]
      unit = np.ones((2*self.size,2*self.size))*(-1)
      h,w = element.shape
      for i in range(h):
        for j in range(w):
          el = element[i,j]
          
          j_ = [j,2*self.size-1-j,2*self.size-1-j,j]
          i_ = [i+self.size,i+self.size,self.size-1-i,self.size-1-i]
          # (1,2)-> (1,13) -> (14,13) -> (14,2)
          for (k,l) in list(zip(i_,j_)):
            unit[k,l]  = el

    return unit

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