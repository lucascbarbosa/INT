from hexalattice.hexalattice import *
import numpy as np
import matplotlib.pyplot as plt
import numpy as np

def filter_arr(el):
    return el[1] == 2

arr = np.array([[0,1],[1,2]])
print(np.where(filter_arr(arr)))    
# size = 5
# hex_centers,h_ax = create_hex_grid(nx=size, ny=size)

# arr = np.array([[0,1,0,1,0],[1,1,0,0,1],[0,1,1,1,0],[0,0,0,1,0],[0,0,1,1,1]])

# arr = arr.reshape(size*size)
# colors = []
# for i in range(arr.shape[0]):
#     colors.append(np.ones((1,3))*255*(1-arr[i]))

# colors = [np.ones((1,3))*(1-arr[i]) for i in range(arr.shape[0])]
# colors = np.array(colors).reshape((size*size,3))

# plot_single_lattice_custom_colors(
#     hex_centers[:, 0], 
#     hex_centers[:, 1], 
#     face_color=colors,
#     edge_color=colors,
#     min_diam=1.,
#     plotting_gap=0,
#     rotate_deg=0)

# plt.show()