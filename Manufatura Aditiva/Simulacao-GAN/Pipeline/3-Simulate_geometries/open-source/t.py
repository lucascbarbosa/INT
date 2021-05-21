from multiprocessing import Process
import time

def f(name):
    print('hello', name)
    time.sleep(1)

if __name__ == '__main__':
    processes = []
    start = time.time()
    for _ in range(10):
        process = Process(target=f, args=('bob',))
        processes.append(process)
        process.start()
    
    for process in processes:
        process.join()
    
    end = time.time()
    print(f'Elapsed time: {end-start}')