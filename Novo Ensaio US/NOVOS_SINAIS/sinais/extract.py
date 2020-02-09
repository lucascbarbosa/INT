# tekwfm.py usage examples

import time
import matplotlib.pyplot as plt # https://matplotlib.org/
import numpy as np #
import tekwfm
import os



def extract(myfile):
    """print date of trigger and plot scaled wfm 'myfile'"""
    volts, tstart, tscale, tfrac, tdatefrac, tdate = tekwfm.read_wfm(myfile)
    # print trigger time stamp
    print('local trigger time for: {}'.format(myfile))
    print('trigger: {}'.format(time.ctime(tdate)))
    # create time vector
    toff = tfrac * tscale
    samples, frames = volts.shape
    tstop = samples * tscale + tstart
    t = np.linspace(tstart+toff, tstop+toff, num=samples, endpoint=False)
    # plot 
    plt.figure(1)
    plt.axvline(linewidth=1, color='r') # trigger annotation
    plt.plot(t, volts)
    plt.xlabel('time (s)')
    plt.ylabel('volts (V)')
    plt.title('single waveform')
    plt.savefig('imgs/{}.png'.format(myfile.split('/')[1]))
    plt.show()
"""
listarq = os.listdir('sinais')
print(listarq)
for arq in listarq:
    extract('sinais/'+arq)
"""
extract('sinais/sample_1.wfm')

