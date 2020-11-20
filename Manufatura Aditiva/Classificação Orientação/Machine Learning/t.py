import mlflow

mlflow.set_experiment(experiment_name='Test')

with mlflow.start_run(run_name='teste'):
    mlflow.log_param('a',1)
    mlflow.log_metric('b',2)