import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.metrics import f1_score
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import make_pipeline
from sklearn.neighbors import KNeighborsClassifier
from sklearn.linear_model import SGDClassifier
from sklearn.svm import SVC
from sklearn.tree import DecisionTreeClassifier
from sklearn.cluster import KMeans
from sklearn.model_selection import GridSearchCV, KFold, StratifiedShuffleSplit
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
import mlflow
sns.set()

def get_hyperparams(X_train,X_test,y_train,y_test,kfold,param_grid, model,modelname,w,h,filename):
    
    gs = GridSearchCV(estimator=model,
                      param_grid=param_grid,
                      cv=kfold)
    best_gs = gs.fit(X_train,y_train)
    n = len(param_grid)
    scores = best_gs.cv_results_['mean_test_score']
    scores = scores.reshape(len(scores),)
    if n == 1:
        label = list(param_grid.keys())[0]
        par = list(param_grid.values())[0]
        plt.title(modelname)
        plt.plot(par,scores)
        plt.ylabel('F1-score')
        plt.xlabel(label)
        plt.savefig(filename)
        
    if n == 2:
        
        label1,label2 = param_grid.keys()
        par1,par2 = param_grid.values()
        scores_df = pd.DataFrame(columns=par1,index=par2)
        for i in range(len(par1)*len(par2)):
            col = i % len(par1)
            row = i // len(par1)
            scores_df.iloc[row,col] = scores[i]

        scores_df = scores_df.astype(float)

        fig= plt.figure(figsize=(w,h))
        heatmap = sns.heatmap(scores_df)        
        plt.title(modelname)
        plt.xlabel(label1)
        plt.ylabel(label2)
        fig = heatmap.get_figure()
        fig.savefig(filename)

    plt.clf()

    return best_gs.best_params_

def plot_results(model,modelname,filename):
    h = .01

    x_min, x_max = X.iloc[:,0].min(), X.iloc[:,0].max() 
    y_min, y_max = X.iloc[:,1].min(), X.iloc[:,1].max()

    xx, yy = np.meshgrid(np.arange(x_min, x_max, h),
                        np.arange(y_min, y_max, h))

    Z = model.predict(np.c_[xx.ravel(), yy.ravel()])

    Z = Z.reshape(xx.shape)
    plt.figure()

    # Create color maps
    cmap_light = ListedColormap(['#FFAAAA', '#AAAAFF','#AAFFAA','#AFAFAF'])
    cmap_bold  = ListedColormap(['#FF0000', '#0000FF','#00FF00','#000000'])

    plt.pcolormesh(xx, yy, Z, cmap=cmap_light)

    sns.scatterplot(x = 'Tensão na força máxima', y = 'Deformação na ruptura', data= dados,                      hue = 'Plano ID', palette=cmap_bold)
    plt.xlim(xx.min(), xx.max())
    plt.ylim(yy.min(), yy.max())
    plt.xlabel('Tensão na força máxima')
    plt.ylabel('Deformacao na ruptura')
    plt.title(modelname)
    plt.savefig(filename)

if __name__ == "__main__":

    mlflow.set_experiment(experiment_name='Classificação de Orientação')

    #Import data
    dados = pd.read_csv('C:/Users/lucas/Documents/GitHub/INT/Manufatura Aditiva/Classificação Direção/Dados/Dados tratados.csv')
    X = dados[['Tensão na força máxima','Deformação na ruptura']]
    y = dados['Plano ID']

    #Tuning hyperparameters

    n_folds = 4
    test_size = 0.35

    X_train,X_test,y_train,y_test = train_test_split(X,y,test_size = test_size)
    kfold = KFold(n_folds,shuffle=True,random_state=42)

    w,h = 10,6

    #KNN
    min_k, max_k = 1,10
    ks = [i for i in range(min_k,max_k+1)]
    param_grid_knn = {'n_neighbors': ks}
    knn_hyppar_path = r"C:\Users\lucas\Documents\GitHub\INT\Manufatura Aditiva\Classificação Direção\Machine Learning\Artifacts\Hyperparameters results\knn_hyperparameters.png"
    k_opt= get_hyperparams(X_train,X_test,y_train,y_test,kfold,param_grid_knn, KNeighborsClassifier(),'KNN',w,h,knn_hyppar_path)['n_neighbors']
    
    #SGD
    alphas = np.arange(0.001,1.0, 0.001).round(3)
    param_grid_sgd={'alpha': alphas}
    sgd_hyppar_path = r"C:\Users\lucas\Documents\GitHub\INT\Manufatura Aditiva\Classificação Direção\Machine Learning\Artifacts\Hyperparameters results\sgd_hyperparameters.png"
    alpha_opt = get_hyperparams(X_train,X_test,y_train,y_test,kfold,param_grid_sgd,SGDClassifier(penalty='l2',random_state=42),'SGD',w,h,sgd_hyppar_path)['alpha']
    
    #SVC
    Cs = np.arange(.5,1.5,.1)
    Cs = Cs.round(1)
    gammas = np.arange(.5,1.5,.1)
    gammas = gammas.round(1)
    param_grid_svc={'C': Cs, 'gamma': gammas}
    svc_hyppar_path = r"C:\Users\lucas\Documents\GitHub\INT\Manufatura Aditiva\Classificação Direção\Machine Learning\Artifacts\Hyperparameters results\svc_hyperparameters.png"
    params = get_hyperparams(X_train,X_test,y_train,y_test,5,param_grid_svc,SVC(random_state=42,kernel='sigmoid'),'SVC',w,h,svc_hyppar_path)
    C_opt = params['C']
    gamma_opt = params['gamma'] 

    #Decision Trees
    max_depth = 10
    depths = [i for i in range(1,max_depth+1)]
    param_grid_trees = {'max_depth':depths}
    trees_hyppar_path = r"C:\Users\lucas\Documents\GitHub\INT\Manufatura Aditiva\Classificação Direção\Machine Learning\Artifacts\Hyperparameters results\trees_hyperparameters.png"
    max_depth_opt = get_hyperparams(X_train,X_test,y_train,y_test,kfold,param_grid_trees,DecisionTreeClassifier(random_state=42),'Decision Trees',w,h,trees_hyppar_path)['max_depth']
    
    #Test hyperparams

    n_splits = 4

    sss = StratifiedShuffleSplit(n_splits=n_splits, test_size=test_size, random_state=42)

    knn_score = 0.0
    sgd_score = 0.0
    svc_score = 0.0
    trees_score = 0.0

    for train_index, test_index in sss.split(X, y):    
        X_train,X_test,y_train,y_test = X.iloc[train_index],X.iloc[test_index],y.iloc[train_index],y.iloc[test_index]

        #KNN
        knn = make_pipeline(StandardScaler(),
                            KNeighborsClassifier(n_neighbors=5))
        knn.fit(X_train, y_train)
        pred_knn = knn.predict(X_test)
        knn_score += f1_score(y_test,pred_knn,average='weighted',pos_label="Plano ID")
        
        #SGD
        sgd = make_pipeline(StandardScaler(),
                            SGDClassifier(random_state=42,penalty='l2',alpha=0.004))
        sgd.fit(X_train, y_train)
        pred_sgd = sgd.predict(X_test)
        sgd_score += f1_score(y_test,pred_sgd,average='weighted',pos_label="Plano ID")
        
        #SVC
        svc = make_pipeline(StandardScaler(),
                            SVC(random_state=42,kernel='sigmoid',gamma='auto'))
        svc.fit(X_train,y_train)
        pred_svc = svc.predict(X_test)
        svc_score += f1_score(y_test,pred_svc,average='weighted',pos_label="Plano ID")
        
        #Decision Trees
        trees = make_pipeline(StandardScaler(),
                            DecisionTreeClassifier(random_state=42,max_depth=max_depth_opt))

        trees.fit(X_train,y_train)
        pred_trees = trees.predict(X_test)
        trees_score += f1_score(y_test,pred_trees,average='weighted',pos_label="Plano ID")
        
    knn_score /= float(n_splits)
    sgd_score /= float(n_splits)
    svc_score /= float(n_splits)
    trees_score /= float(n_splits)

    #Plot results
    knn_results_path = r"C:\Users\lucas\Documents\GitHub\INT\Manufatura Aditiva\Classificação Direção\Machine Learning\Artifacts\Algorithms results\knn_results.png"
    sgd_results_path = r"C:\Users\lucas\Documents\GitHub\INT\Manufatura Aditiva\Classificação Direção\Machine Learning\Artifacts\Algorithms results\sgd_results.png"
    svc_results_path = r"C:\Users\lucas\Documents\GitHub\INT\Manufatura Aditiva\Classificação Direção\Machine Learning\Artifacts\Algorithms results\svc_results.png"
    trees_results_path = r"C:\Users\lucas\Documents\GitHub\INT\Manufatura Aditiva\Classificação Direção\Machine Learning\Artifacts\Algorithms results\trees_results.png"
    plot_results(knn,'knn',knn_results_path)
    plot_results(sgd,'sgd',sgd_results_path)
    plot_results(svc,'svc',svc_results_path)
    plot_results(trees,'trees',trees_results_path)

    with mlflow.start_run():
        #KNN
        mlflow.sklearn.log_model(knn,'KNN')
        mlflow.log_param('KNN_k',k_opt)
        mlflow.log_metric('KNN_f1score',knn_score)
        mlflow.log_artifact(knn_hyppar_path)
        mlflow.log_artifact(knn_results_path)
        #SGD
        mlflow.sklearn.log_model(sgd,'SGD')
        mlflow.log_param('SGD_alpha',alpha_opt)
        mlflow.log_metric('SGD_f1score',sgd_score)
        mlflow.log_artifact(sgd_hyppar_path)
        mlflow.log_artifact(sgd_results_path)
        #SVC
        mlflow.sklearn.log_model(svc,'SVM')
        mlflow.log_param('SVC_C',C_opt)
        mlflow.log_param('SVC_gamma',gamma_opt)
        mlflow.log_metric('SVC_f1score',svc_score)
        mlflow.log_artifact(svc_hyppar_path)
        mlflow.log_artifact(svc_results_path)
        #Decision Trees
        mlflow.sklearn.log_model(trees,'Decision Trees')
        mlflow.log_param('Trees_max_depth',max_depth_opt)
        mlflow.log_metric('Trees_f1score',trees_score)
        mlflow.log_artifact(trees_hyppar_path)
        mlflow.log_artifact(trees_results_path)