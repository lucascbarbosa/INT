from hexalattice.hexalattice import *
import numpy as np
import matplotlib.pyplot as plt

hex_centers,h_ax = create_hex_grid(nx=50, ny=50)

image_path = '1- Generate_database/src/apple.jpg'
colors = sample_colors_from_image_by_grid(
    image_path,
    hex_centers[:,0],
    hex_centers[:1])

plot_single_lattice_custom_colors(
    hex_centers[:, 0], 
    hex_centers[:, 1], 
    face_color=colors)

plt.show()