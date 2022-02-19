from PIL.Image import FLIP_LEFT_RIGHT
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.preprocessing import MinMaxScaler
import os
# import mlflow
import time
import sys
from skimage import measure

from tensorflow.python.ops.array_ops import batch_gather
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'

import tensorflow as tf
from tensorflow.keras import backend as K

import keras
from keras.models import Model
from keras.layers import Dense, Flatten, Conv1D, Conv2D, Input, Conv1DTranspose, Conv2DTranspose, Concatenate, MaxPool1D, Dropout, Reshape, Lambda, InputLayer, LeakyReLU, BatchNormalization
from keras.optimizers import adam_v2
from keras.losses import MeanSquaredError
from keras.metrics import BinaryCrossentropy


class GAN(object):
    def __init__(self,alpha,lr,porosity,num_epochs,batch_size,cutoff):
        self.alpha = alpha
        self.lr = lr
        self.porosity = porosity
        self.num_epochs = num_epochs
        self.batch_size = batch_size
        self.cutoff = cutoff

    def config(self):
        physical_devices = tf.config.list_physical_devices('GPU') 
        tf.config.experimental.set_memory_growth(physical_devices[0], True)
        if len(physical_devices) == 0:
            print("Erro: Nenhuma GPU disponível")

    def load_data(self,score_filename):

        data = np.loadtxt(score_filename,delimiter=',')
        X = data[:,1:-1]
        self.size = int(np.sqrt(X.shape[1]))
        X = X.reshape((X.shape[0],self.size,self.size,1))

        y = data[:,-1]
        y = y.reshape((y.shape[0],1))

        scaler = MinMaxScaler()
        y = scaler.fit_transform(y).round(10)
        cutoff = 0.85
        idxs_good = np.where(y>cutoff)[0]
        idxs_bad = np.where(y<=cutoff)[0]

        y = np.zeros(y.shape)
        y[idxs_good] = 1.0

        X_good = X[idxs_good]

        # set shapes
        self.input_G = 128
        self.output_G = self.input_D = X_good.shape[1:]
        self.output_D = 1

        return X_good
    
    def setup_G(self):
        size = int(self.size/2)
        in_G = Input(shape=(self.input_G,))

        # foundation for 7x7 image
        n_nodes = 128 * size * size
        out_G = Dense(n_nodes,activation=LeakyReLU(alpha=0.2))(in_G)
        out_G = Reshape((size, size, 128))(out_G)
        # upsample to 14x14
        out_G = Conv2DTranspose(128, (4,4), strides=(2,2), padding='same',activation=LeakyReLU(alpha=0.2))(out_G)
        out_G = Conv2D(1, (size,size), activation='sigmoid', padding='same')(out_G)


        out_density = Lambda(lambda x:x)(out_G)

        model = Model(name='Generator',inputs=in_G,outputs=[out_G,out_density])

        return model
        
    def style_loss(self,alpha):
        def custom_loss(y_true,y_pred):
            y_pred = tf.reshape(y_pred,shape=(y_pred.shape[0],y_pred.shape[1]*y_pred.shape[2]))
            y_true = tf.reshape(y_true,shape=(y_true.shape[0],y_true.shape[1]*y_true.shape[2]))
            size = y_pred.shape[1]
            por_true = K.sum(y_true,axis=-1)/size
            por_pred = K.sum(y_pred,axis=-1)/size
            mse = MeanSquaredError()
            return alpha*mse(por_true,por_pred)
        return custom_loss

    def setup_D(self):
        in_D = Input(shape=self.input_D)
        out_D = Conv2D(64, (3,3), strides=(2, 2), padding='same', activation=LeakyReLU(alpha=0.2))(in_D)
        out_D = Dropout(0.4)(out_D)
        out_D = Conv2D(64, (3,3), strides=(2, 2), padding='same', activation=LeakyReLU(alpha=0.2))(out_D)
        out_D = Dropout(0.4)(out_D)
        out_D = Flatten()(out_D)
        out_D = Dense(1, activation='sigmoid')(out_D)

        # compile model
        in_density = Input(shape=self.input_D)
        out_density = Lambda(lambda x: x)(in_density)

        optimizer = adam_v2.Adam(learning_rate=self.lr, beta_1=0.5)
        model = Model(name='Discriminator',inputs=[in_D,in_density],outputs=[out_D,out_density])

        model.compile(loss=['binary_crossentropy',self.style_loss(self.alpha)], optimizer=optimizer, metrics=['accuracy'])
        return model

    def setup_GAN(self):
        optimizer = adam_v2.Adam(learning_rate=self.lr, beta_1=0.5)
        self.D_model.trainable = False
        in_G = self.G_model.input
        out_GAN = self.D_model(self.G_model(in_G))
        model = Model(name='GAN',inputs=in_G,outputs=out_GAN)
        model.compile(loss=['binary_crossentropy',self.style_loss(self.alpha)], \
                    optimizer=optimizer, \
                    metrics=['accuracy'])
        return model

    def generate_fake_samples(self, n_samples):
        # generate points in latent space
        X_input = self.generate_input_G(n_samples)
        # predict outputs
        X,_ = self.G_model.predict(X_input)
        # create 'fake' class labels (0)
        y = np.zeros((n_samples, 1))
        return X,y

    def generate_input_G(self, n_samples):
        # generate points in the latent space
        X_input = np.random.randn(self.input_G * n_samples)
        # reshape into a batch of inputs for the network
        X_input = X_input.reshape(n_samples, self.input_G)
        return X_input

    def generate_real_samples(self,dataset, n_samples):
        # choose random instances
        ix = np.random.randint(0, dataset.shape[0], n_samples)
        # retrieve selected images
        X = dataset[ix]
        # generate 'real' class labels (1)
        y = np.ones((n_samples, 1))
        return X, y
    
    def train(self,data,score,model_dir,plot=False,verbose=False):
        # setup G and D
        self.G_model = gan.setup_G()
        self.D_model = gan.setup_D()
        self.GAN_model = gan.setup_GAN()
    
        batch_per_epoch = int(data.shape[0] /self.batch_size)
        half_batch = int(self.batch_size/2)

        G_losses = []
        D_losses = []

        G_loss_best = 999.0
        D_loss_best = 999.0
        
        # mlflow.keras.autolog()

        for i in range(self.num_epochs):
            G_losses_epoch = []
            D_losses_epoch = []
            for j in range(batch_per_epoch):
                X_real,y_real = self.generate_real_samples(data,half_batch)
                X_fake,y_fake = self.generate_fake_samples(half_batch)            

                X, y = np.vstack((X_real, X_fake)), np.vstack((y_real, y_fake))
            
                D_loss = self.D_model.train_on_batch(x=[X,X], y=[y,porosity*np.ones(X.shape)])
                D_loss = D_loss[0]
                D_losses_epoch.append(D_loss)
                
                X_GAN = self.generate_input_G(self.batch_size)
                y_GAN = np.ones((self.batch_size, 1))
                G_loss= self.GAN_model.train_on_batch(x=X_GAN, y=[y_GAN,porosity*np.ones(X.shape)])
                G_loss = G_loss[0]
                G_losses_epoch.append(G_loss)
                
                if verbose:
                    print('>%d, %d/%d, D_loss=%.3f, G_loss=%.3f' % (i+1, j+1, batch_per_epoch,  D_loss, G_loss))
            G_losses.append(G_losses_epoch)
            D_losses.append(D_losses_epoch)
            G_loss_epoch = np.mean(G_losses_epoch)
            D_loss_epoch = np.mean(D_losses_epoch)

            if (i+1) % 5 == 0 and i >= self.num_epochs-50 and G_loss_epoch + D_loss_epoch < G_loss_best + D_loss_best:
                D_loss_best = D_loss_epoch
                G_loss_best = G_loss_epoch
                # files = os.listdir(model_dir)
                # for file in files:
                #     if file.split('_')[0] == score:
                #         os.remove('C:/Users/lucas.barbosa/Documents/GitHub/INT/Manufatura Aditiva/Simulacao-GAN/Pipeline/4- Machine_learning/GAN/models/'+file)
                self.G_model.save(model_dir+'%s_epoch_%d_loss_%.4f.h5'%(score,i+1,G_loss_best))
                self.G_best = self.G_model

        G_losses = np.array(G_losses)
        D_losses = np.array(D_losses)

        if plot:
            fig = plt.figure()
            fig.set_size_inches((10,8)) 
            plt.plot(list(range(1,self.num_epochs+1)),np.mean(D_losses,axis=1),label='D Loss')
            plt.title('Loss')
            plt.ylabel('Loss')
            plt.xlabel('Epoch')
            plt.plot(list(range(1,self.num_epochs+1)),np.mean(G_losses,axis=1),label='G Loss')
            plt.legend()
            plt.show()


        return G_loss_best,D_loss_best


    def generate_arrays(self,top,simmetry,tol,plot=False,save=False):
        path = r"D:/Lucas GAN/Dados/1- Arranged_geometries/Arrays/GAN/%s/"%(simmetry)
        test_size = 100000
        X_test = self.generate_input_G(test_size)

        generated_geoms,_ = self.G_best.predict(X_test)
        size = generated_geoms.shape[1]

        porosities =  []
        pors = []

        for generated_geom in generated_geoms:
            p = generated_geom.ravel().round().sum()/(size*size)
            if p <= 0.52 and p >= 0.48:
                pors.append(p)
            porosities.append(p)

        sns.histplot(porosities,bins=32)
        plt.show()

        # Filter per porosity
        def porosity_match(geoms,porosity,tol):
            geoms_ = []
            passed = 0
            for i in range(geoms.shape[0]):
                g =geoms[i,:,:,0]
                size = g.shape[0]
                g = g.reshape((size*size,))
                p = np.sum(g)/(size*size)
                if p >= (1.0-tol)*porosity and p <= (1.0+tol)*porosity:
                    geoms_.append(g.reshape((size,size)))
                    passed += 1
            return np.array(geoms_).reshape((passed,size,size,1))

        def create_unit(element,size,simmetry):
            if simmetry == 'p4':
                unit_size = 2*size
                fold_size = np.random.choice(4,1)[0]
                unit = np.ones((unit_size,unit_size))*(-1)
                h,w = element.shape
                for i in range(h):
                    for j in range(w):
                        el = element[i,j]
                        i_ = i+size*(fold_size//2)
                        j_ = j+size*(fold_size%2)
                        unit[i_,j_] = el
                        for k in [i_,2*size-1-i_]:
                            for l in [j_,2*size-1-j_]:
                                unit[k,l] = el
                        
            return unit

        def check_geometry(geometry,tol,size,simmetry):
            unit = create_unit(geometry,size,simmetry)
            unit_size = 2*size
            labels = measure.label(unit,connectivity=1)
            main_label = 0
            main_label_count = 0
            for label in range(1,len(np.unique(labels))):
                label_count = np.where(labels==label)[0].shape[0]
                if label_count > main_label_count:
                    main_label = label
                    main_label_count = label_count

            if np.where(labels==0)[0].shape[0]+np.where(labels==main_label)[0].shape[0] >(1.0-tol)*unit_size*unit_size:
                for label in range(1,len(np.unique(labels))):
                    if label not in [0,main_label]:
                        unit[np.where(labels==label)] = 0.

                    if unit[0,:].sum() > 0 and unit[:,0].sum() > 0:
                        return True, unit[:size,:size]

                    else:
                        return False,unit

            else:
                return False, unit

        
        geometries = porosity_match(generated_geoms,porosity,tol)
        size = geometries.shape[1]
        geometries_ = []

        for i in range(geometries.shape[0]):
            geom = geometries[i].reshape((size,size))
            passed,geom_ = check_geometry(geom,tol,size,simmetry)
            if passed:
                geometries_.append(geom_)

        geometries = np.array(geometries_).reshape((len(geometries_),size,size,1))
        # Round pixels
        geometries = geometries.round()

        # Get scores
        top = 20
        scores = self.D_model.predict([geometries,geometries])[0]
        top_idxs = scores[:,0].argsort()[-top:]

        # Add solid boundary
        geometries_expanded = []
        for i in range(geometries.shape[0]):
            geom = geometries[i]    
            geometries_expanded.append(geom)

        geometries = np.array(geometries_expanded).reshape((geometries.shape[0],geometries.shape[1],geometries.shape[2],geometries.shape[3]))

        p = 1
        for top_idx in top_idxs:
            geom = geometries[top_idx]
            unit = create_unit(geom.reshape((size,size)),size,simmetry)
            if plot:
                plt.imshow(unit,cmap="Greys")
                # print("Score: %.2f Porosity: %.2f"%(scores[top_idx,0],geom.ravel().sum()/((size+2)*(size+2))))
                plt.show()
            filename = path+"%05d_porosity_%.4f.txt"%(p,geom.ravel().sum()/((size+2)*(size+2)))
            np.savetxt(filename,geom.ravel(),delimiter='/n',fmt='%s')
            p += 1    
        

if __name__ == "__main__":
    dimension = sys.argv[1]
    simmetry = sys.argv[2]
    score = sys.argv[3]

    # mlflow.set_experiment(experiment_name='GAN_%s'%score)
    if os.getcwd().split('\\')[2] == 'lucas':
        score_filename = 'E:/Lucas GAN/Dados/4- Scores/RTGA/%sD/%s/%s.csv' %(dimension,simmetry,score)
        model_dir = 'E:/Lucas GAN/Dados/5- Models/%sD/%s/' %(dimension,simmetry)

    else:
        score_filename = 'D:/Lucas GAN/Dados/4- Scores/RTGA/%sD/%s/%s.csv' %(dimension,simmetry,score)
        model_dir = 'D:/Lucas GAN/Dados/5- Models/%sD/%s/' %(dimension,simmetry)
    porosity = 0.5
    top = 1000
    tol = 0.1

    alpha = 1e-1
    lr = 1e-4
    num_epochs = 200 #iso:100 hs:300
    batch_size = 64
    cutoff = 0.79 #iso:0.78 hs: 0.75

    # config GAN
    gan = GAN(alpha,lr,porosity,num_epochs,batch_size,cutoff)
    gan.config()
    data = gan.load_data(score_filename)

    # train
    start_time = time.time()
    G_loss,D_loss = gan.train(data,score,model_dir,True)
    end_time = time.time()
    run_time = end_time-start_time

    # # generate arrays
    # gan.generate_arrays(top,simmetry,tol,False,True)

    # with mlflow.start_run() as run:
    #     mlflow.log_param('alpha',alpha)
    #     mlflow.log_param('lr',lr)
    #     mlflow.log_param('num_epochs',num_epochs)
    #     mlflow.log_param('batch_size',batch_size)
    #     mlflow.log_param('cutoff',cutoff)
    #     mlflow.log_param('run_time',run_time)
    #     mlflow.log_metric('G_loss',G_loss)
    #     mlflow.log_metric('D_loss',D_loss)
        
        # mlflow.log_artifact(knn_hyppar_path)