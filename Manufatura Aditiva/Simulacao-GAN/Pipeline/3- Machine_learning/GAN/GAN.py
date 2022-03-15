from keras.metrics import BinaryCrossentropy
from keras.losses import MeanSquaredError
from keras.optimizers import adam_v2
from keras.layers import Dense, Flatten, Conv1D, Conv2D, Input, Conv1DTranspose, Conv2DTranspose, Concatenate, MaxPool1D, Dropout, Reshape, Lambda, InputLayer, LeakyReLU, BatchNormalization
from keras.models import Model, load_model
import keras
from tensorflow.keras import backend as K
import tensorflow as tf
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


class GAN(object):
    def __init__(self, porosity, alpha, lr, num_epochs, batch_size, cutoff):
        self.porosity = porosity
        self.alpha = alpha
        self.lr = lr
        self.num_epochs = num_epochs
        self.batch_size = batch_size
        self.cutoff = cutoff

    def config(self):
        physical_devices = tf.config.list_physical_devices('GPU')
        tf.config.experimental.set_memory_growth(physical_devices[0], True)
        if len(physical_devices) == 0:
            print("Erro: Nenhuma GPU disponível")
        tf.config.run_functions_eagerly(True)

    def load_data(self, score_filename, verbose=False):

        data = np.loadtxt(score_filename, delimiter=',')
        X = data[:, 1:-1]
        self.size = int(np.sqrt(X.shape[1]))
        X = X.reshape((X.shape[0], self.size, self.size, 1))

        y = data[:, -1]
        y = y.reshape((y.shape[0], 1))

        scaler = MinMaxScaler()
        y = scaler.fit_transform(y).round(10)
        idxs_good = np.where(y > cutoff)[0]
        idxs_bad = np.where(y <= cutoff)[0]
        if verbose:
            print(f"Good = %.2f %%" %
                    (100*len(idxs_good)/(len(idxs_good)+len(idxs_bad))))

        y = np.zeros(y.shape)
        y[idxs_good] = 1.0

        X_good = X[idxs_good]
        self.data = X_good

        # set shapes
        self.input_G = 128
        self.output_G = self.input_D = X_good.shape[1:]
        self.output_D = 1

    def setup_G(self):
        size = int(self.size/2)
        in_G = Input(shape=(self.input_G,))

        # foundation for 8x8 image
        n_nodes = 128 * size * size
        out_G = Dense(n_nodes, activation=LeakyReLU(alpha=0.2))(in_G)
        out_G = LeakyReLU(alpha=0.2)(out_G)
        out_G = Reshape((size, size, 128))(out_G)
        # upsample to 16x16
        out_G = Conv2DTranspose(128, (4, 4), strides=(
            2, 2), padding='same', activation=LeakyReLU(alpha=0.2))(out_G)
        out_G = LeakyReLU(alpha=0.2)(out_G)
        out_G = Conv2D(1, (size, size), activation='sigmoid',
                       padding='same')(out_G)

        out_density = Lambda(lambda x: x)(out_G)

        model = Model(name='Generator', inputs=in_G,
                      outputs=[out_G, out_density])

        return model

    def style_loss(self):
        def custom_loss(y_true, y_pred):
            size = y_pred.shape[1]*y_pred.shape[2]
            y_pred = K.round(y_pred)
            por_true = K.sum(K.sum(K.sum(y_true, axis=1), axis=1), axis=1)/size
            por_pred = K.sum(K.sum(K.sum(y_pred, axis=1), axis=1), axis=1)/size
            mse = (por_true-por_pred)**2
            return mse
        return custom_loss

    def setup_D(self):
        in_D = Input(shape=self.input_D)
        out_D = Conv2D(64, (3, 3), strides=(2, 2), padding='same',
                       activation=LeakyReLU(alpha=0.2))(in_D)
        out_D = Dropout(0.4)(out_D)
        out_D = Conv2D(64, (3, 3), strides=(2, 2), padding='same',
                       activation=LeakyReLU(alpha=0.2))(out_D)
        out_D = Dropout(0.4)(out_D)
        out_D = Flatten()(out_D)
        out_D = Dense(1, activation='sigmoid')(out_D)

        # compile model
        opt = adam_v2.Adam(learning_rate=0.0002, beta_1=0.5)

        in_density = Input(shape=self.input_D)
        out_density = Lambda(lambda x: x)(in_density)

        optimizer = adam_v2.Adam(learning_rate=lr, beta_1=0.5)
        model = Model(
            name='Discriminator',
            inputs=[in_D, in_density],
            outputs=[out_D, out_density])

        model.compile(
            loss=['binary_crossentropy', self.style_loss()],
            loss_weights=[1.0, alpha],
            optimizer=optimizer,
            metrics=['accuracy']
            )
        return model

    def setup_GAN(self, G_model, D_model):
        optimizer = adam_v2.Adam(learning_rate=self.lr, beta_1=0.5)
        D_model.trainable = False
        in_G = G_model.input
        out_GAN = D_model(G_model(in_G))
        model = Model(name='GAN', inputs=in_G, outputs=out_GAN)
        model.compile(
            loss=['binary_crossentropy', self.style_loss()],
            loss_weights=[1.0, self.alpha],
            optimizer=optimizer,
            metrics=['accuracy']
            )
        return model

    def generate_fake_samples(self, n_samples):
        # generate points in latent space
        X_input = self.generate_input_G(n_samples)
        # predict outputs
        X, _ = self.G_model.predict(X_input)
        # create 'fake' class labels (0)
        y = np.zeros((n_samples, 1))
        return X, y

    def generate_input_G(self, n_samples):
        # generate points in the latent space
        X_input = np.random.randn(self.input_G * n_samples)
        # reshape into a batch of inputs for the network
        X_input = X_input.reshape(n_samples, self.input_G)
        return X_input

    def generate_real_samples(self, n_samples):
        # choose random instances
        ix = np.random.randint(0, self.data.shape[0], n_samples)
        # retrieve selected images
        X = self.data[ix]
        # generate 'real' class labels (1)
        y = np.ones((n_samples, 1))
        return X, y

    def summarize_performance(self, epoch, n_samples=100):
        # prepare real samples
        X_real, y_real = self.generate_real_samples(n_samples)
        # evaluate discriminator on real examples
        _, _, _, acc_real, _ = self.D_model.evaluate(
            x=[X_real, X_real], y=[y_real, self.porosity*np.ones(X_real.shape)], verbose=0)
        # prepare fake examples
        X_fake, y_fake = self.generate_fake_samples(n_samples)
        # evaluate discriminator on fake examples
        _, _, _, acc_fake, _ = self.D_model.evaluate(
            x=[X_fake, X_fake], y=[y_fake, self.porosity*np.ones(X_fake.shape)], verbose=0)
        # summarize discriminator performance
        return acc_real, acc_fake

    def train(self, score, tmp_models_dir, tol_porosity, plot=False, verbose_loss=False, verbose_acc=False):
        # setup G and D
        self.G_model = gan.setup_G()
        self.D_model = gan.setup_D()
        self.GAN_model = gan.setup_GAN(self.G_model, self.D_model)

        batch_per_epoch = int(self.data.shape[0] / self.batch_size)
        half_batch = int(self.batch_size/2)

        G_losses = []
        D_losses = []

        # mlflow.keras.autolog()

        for i in range(self.num_epochs):
            G_losses_epoch = []
            D_losses_epoch = []
            for j in range(batch_per_epoch):
                X_real, y_real = self.generate_real_samples(half_batch)
                X_fake, y_fake = self.generate_fake_samples(half_batch)

                X, y = np.vstack((X_real, X_fake)), np.vstack((y_real, y_fake))

                if not verbose_loss:
                    D_loss = self.D_model.train_on_batch(
                        x=[X, X], y=[y, porosity*np.ones(X.shape)])
                    D_loss = D_loss[0]
                else:
                    D_loss = self.D_model.train_on_batch(
                        x=[X, X], y=[y, porosity*np.ones(X.shape)], return_dict=True)
                    print(D_loss)
                    D_loss = D_loss['loss']

                D_losses_epoch.append(D_loss)

                X_GAN = self.generate_input_G(self.batch_size)
                y_GAN = np.ones((self.batch_size, 1))

                if not verbose_loss:
                    G_loss = self.GAN_model.train_on_batch(
                        x=X_GAN, y=[y_GAN, porosity*np.ones(X.shape)])
                    G_loss = G_loss[0]
                else:
                    G_loss = self.GAN_model.train_on_batch(
                        x=X_GAN, y=[y_GAN, porosity*np.ones(X.shape)], return_dict=True)
                    print(G_loss)
                    G_loss = G_loss['loss']

                G_loss = self.GAN_model.train_on_batch(
                    x=X_GAN, y=[y_GAN, porosity*np.ones(X.shape)])
                G_loss = G_loss[0]
                G_losses_epoch.append(G_loss)

                if verbose_loss:
                    print('>%d, %d/%d, D_loss=%.3f, G_loss=%.3f' %
                          (i+1, j+1, batch_per_epoch,  D_loss, G_loss))

            G_losses.append(np.array(G_losses_epoch).mean())
            D_losses.append(np.array(D_losses_epoch).mean())

            if (i+1) % 10 == 0:
                acc_real, acc_fake = self.summarize_performance(i+1)
                X_test = self.generate_input_G(1000)
                geoms, _ = self.G_model.predict(X_test)
                geoms = np.array(geoms)
                por_match, _ = self.porosity_match(geoms, tol_porosity)
                self.G_model.save(tmp_models_dir+f'G_epoch_{i+1}_por_{por_match}_acc_{acc_fake}.h5')
                self.D_model.save(tmp_models_dir+f'D_epoch_{i+1}.h5')

                if verbose_acc:
                    print('>Epoch: %i Accuracy real: %.0f%%, fake: %.0f%%' %
                          (i+1, acc_real*100, acc_fake*100))

        G_losses = np.array(G_losses)
        D_losses = np.array(D_losses)

        if plot:
            fig = plt.figure()
            fig.set_size_inches((10, 8))
            plt.plot(list(range(1, num_epochs+1)), D_losses, label='D Loss')
            plt.title('Loss')
            plt.ylabel('Loss')
            plt.xlabel('Epoch')
            plt.plot(list(range(1, num_epochs+1)), G_losses, label='G Loss')
            plt.legend()
            plt.show()

    def porosity_match(self, geoms, tol):
        geoms_ = []
        passed = 0
        for i in range(geoms.shape[0]):
            g = geoms[i, :, :, 0]
            size = g.shape[0]
            g = g.ravel().round()
            p = np.sum(g)/(size*size)
            if p >= self.porosity-tol and p <= self.porosity+tol:
                geoms_.append(g.reshape((size, size)))
                passed += 1

        return passed/len(geoms), np.array(geoms_).reshape((passed, size, size, 1))

    def create_unit(self, element, simmetry):
        if simmetry == 'p4':
            unit_size = 2*self.size
            fold_size = np.random.choice(4, 1)[0]
            unit = np.ones((unit_size, unit_size))*(-1)
            h, w = element.shape
            for i in range(h):
                for j in range(w):
                    el = element[i, j]
                    i_ = i+self.size*(fold_size//2)
                    j_ = j+self.size*(fold_size % 2)
                    unit[i_, j_] = el
                    for k in [i_, 2*self.size-1-i_]:
                        for l in [j_, 2*self.size-1-j_]:
                            unit[k, l] = el
        return unit

    def check_geometry(self, geometry, tol, size, simmetry):
        unit = self.create_unit(geometry, simmetry)
        unit_size = 2*self.size
        labels = measure.label(unit, connectivity=1)
        main_label = 0
        main_label_count = 0
        for label in range(1, len(np.unique(labels))):
            label_count = np.where(labels == label)[0].shape[0]
            if label_count > main_label_count:
                main_label = label
                main_label_count = label_count

        if np.where(labels == 0)[0].shape[0]+np.where(labels == main_label)[0].shape[0] > (1.0-tol)*unit_size*unit_size:
            for label in range(1, len(np.unique(labels))):
                if label not in [0, main_label]:
                    unit[np.where(labels == label)] = 0.

                if unit[0, :].sum() > 0 and unit[:, 0].sum() > 0:
                    return True, unit[:size, :size]

                else:
                    return False, unit

        else:
            return False, unit

    def select_model(self, tmp_models_dir, epoch):
        for file in os.listdir(tmp_models_dir+'G/'):
            print(int(file.split('_epoch_')[1].split('.')[0]))
            if int(file.split('_epoch_')[1].split('.')[0]) == epoch:
                G_model = load_model(tmp_models_dir+'G/'+file)
                D_model = load_model(tmp_models_dir+'D/'+file)
        return G_model, D_model

    def generate_arrays(self, G_model, D_model, saved_geoms, simmetry, tol_porosiy, tol_unit, tmp_models_dir, arrays_dir, plot=False, save=False):
        test_size = saved_geoms*100
        X_test = self.generate_input_G(test_size)

        generated_geoms, _ = G_model.predict(X_test)
        size = generated_geoms.shape[1]

        _, geometries = self.porosity_match(generated_geoms, tol_porosity)
        size = geometries.shape[1]
        geometries_ = []

        for i in range(geometries.shape[0]):
            geom = geometries[i].reshape((size, size))
            passed, geom_ = self.check_geometry(
                geom, tol_unit, size, simmetry)
            if passed:
                geometries_.append(geom_)

        geometries = np.array(geometries_).reshape((len(geometries_), size, size, 1))
        # Round pixels
        geometries = geometries.round()

        # Get scores
        scores = D_model.predict([geometries, geometries])[0]
        top_idxs = scores[:, 0].argsort()[-saved_geoms:]

        p = 1
        for top_idx in top_idxs:
            geom = geometries[top_idx]
            unit = self.create_unit(geom.reshape((size, size)), size, simmetry)
            if plot:
                plt.imshow(unit, cmap="Greys")
                print("Score: %.2f Porosity: %.2f"%(scores[top_idx,0],geom.ravel().sum()/((size+2)*(size+2))))
                plt.show()
            filename = arrays_dir + "%05d_porosity_%.4f.txt" % (p, geom.ravel().sum()/((size+2)*(size+2)))
            np.savetxt(filename, geom.ravel(), delimiter='/n', fmt='%s')
            p += 1


if __name__ == "__main__":
    dimension = sys.argv[1]
    simmetry = sys.argv[2]
    score = sys.argv[3]

    # mlflow.set_experiment(experiment_name='GAN_%s'%score)
    if os.getcwd().split('\\')[2] == 'lucas':
        score_filename = 'E:/Lucas GAN/Dados/4- Scores/RTGA/%sD/%s/%s.csv' % (
            dimension, simmetry, score)
        models_dir = 'E:/Lucas GAN/Dados/5- Models/%sD/%s/' % (
            dimension, simmetry)
        arrays_dir = 'E:/Lucas GAN/Dados/1- Arranged_geometries/Arrays/GAN/%s/' % simmetry
        tmp_models_dir = 'C:/Users/lucas/OneDrive/Documentos/GitHub/INT/Manufatura Aditiva/Simulacao-GAN/Pipeline/3- Machine_learning/GAN/tmp_models/'
    else:
        score_filename = 'D:/Lucas GAN/Dados/4- Scores/RTGA/%sD/%s/%s.csv' % (
            dimension, simmetry, score)
        models_dir = 'D:/Lucas GAN/Dados/5- Models/%sD/%s/' % (
            dimension, simmetry)
        arrays_dir = 'D:/Lucas GAN/Dados/1- Arranged_geometries/Arrays/GAN/%s/' % simmetry
        tmp_models_dir = 'C:/Users/lucas/Documentos/GitHub/INT/Manufatura Aditiva/Simulacao-GAN/Pipeline/3- Machine_learning/GAN/tmp_models/'

    porosity = 0.5
    saved_geoms = 1000
    tol_porosity = 0.02
    tol_unit = 0.1

    alpha = 1e-2
    lr = 1e-4
    num_epochs = 10  # 200
    batch_size = 64
    cutoff = 0.82

    epoch = 10

    # config GAN
    gan = GAN(porosity, alpha, lr, num_epochs, batch_size, cutoff)
    gan.config()
    data = gan.load_data(score_filename,verbose=False)

    # train
    start_time = time.time()
    gan.train(score, tmp_models_dir, tol_porosity, plot=False, verbose_loss=False, verbose_acc=False)

    # get time
    end_time = time.time()
    run_time = end_time-start_time

    # select model
    G_model, D_model = gan.select_model(tmp_models_dir, epoch)


    # generate arrays
    gan.generate_arrays(G_model, D_model, saved_geoms, simmetry, tol_porosity, tol_unit,
                        tmp_models_dir, arrays_dir, plot=False, save=True)

    # with mlflow.start_run() as run:
    #     mlflow.log_param('alpha',alpha)
    #     mlflow.log_param('lr',lr)
    #     mlflow.log_param('num_epochs',num_epochs)
    #     mlflow.log_param('batch_size',batch_size)
    #     mlflow.log_param('cutoff',cutoff)
    #     mlflow.log_param('run_time',run_time)
    #     mlflow.log_metric('G_loss',G_loss)
    #     mlflow.log_metric('D_loss',D_loss)
