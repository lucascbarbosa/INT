import os

path = 'E:/Lucas GAN/Dados/2- Models/RTGA/2D/p4/'

arrays_dir = os.listdir(path)
for array_dir in arrays_dir:
    geom_filenames = os.listdir(path+array_dir+'/')
    for geom_filename in geom_filenames:
        if geom_filename[0] == 'o':
            os.rename(path+array_dir+'/'+geom_filename,path+array_dir+'/p'+geom_filename)
