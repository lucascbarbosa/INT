import os

dimension = '2'
simmetry = 'p4'
score = 'isotropy'

geometries_dir = 'E:/Lucas GAN/Dados/1- Arranged_geometries/GAN/%s/%s/' % (simmetry, score)
vtk_dir = 'E:/Lucas GAN/Dados/2- Geometry_models/GAN/%sD/%s/%s/' % (dimension, simmetry, score)
young_dir = 'E:/Lucas GAN/Dados/3- Mechanical_properties/young/GAN/%sD/%s/%s/' % (dimension, simmetry, score)
models_dir = 'E:/Lucas GAN/Dados/5- GAN_models/%sD/%s/%s/'%(dimension,simmetry,score)
log_dir = 'E:/Lucas GAN/Dados/6- Simulation_logs/GAN/%sD/%s/' % (dimension, simmetry)

geometries_filename = os.listdir(geometries_dir)
models_filename = os.listdir(models_dir)

i = 1
for geometries_filename in geometries_filename:
    geom_filenames = os.listdir(os.path.join(geometries_dir,geometries_filename))
    for geom_filename in geom_filenames:
        os.replace(geometries_dir+geometries_filename+'/'+geom_filename,geometries_dir+geom_filename)
        # print(geometries_dir+geometries_filename+'/'+geom_filename,geometries_dir+geom_filename)