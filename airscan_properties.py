#!/usr/bin/env python3
'''
File name: airscan_properties.py
Author: Jami L Johnson, Miriam Timmerman
Date created: 3/31/2015
Python version: 3
'''

from palplots.visualize import Plot
from numpy import argmax, eye, size
import numpy as np
import numpy.fft as fft
import matplotlib.pyplot as plt
from obspy.core import read, Stream, Trace
from scipy.optimize import curve_fit
from numpy import exp
from scipy.stats import linregress
from scipy import signal

def funct(x,a):
    coeff = -1
    return 6*exp(coeff*a*x)

def nextpow2(i):
    n = 1
    while n < i: n *= 2
    return n

def normalize(v):
    norm=np.linalg.norm(v)
    if norm==0: 
       return v
    return v/norm

filename='airscan_laser_phantom_tape_shield_HE'

stream = read(filename+'.h5', format='H5', apply_calib=True)

stream.detrend('demean')
stream.sort(keys=['x_position'])
stream.filter('highpass',freq=100e3)
stream.filter('lowpass',freq=1e6)

for trace in stream:
    trace.stats.x_position = abs(trace.stats.x_position - stream[len(stream)-1].stats.x_position)/10 # convert to cm
    trace.data[0:int(18e-6/trace.stats.delta)] = 0 # trim trigger noise

# ---------------
# unfilled wiggle
# ---------------
plt.rcParams['font.size']=12

fig = plt.figure()
ax = fig.add_subplot(111)
newstream = stream.copy()
newstream.sort(keys=['x_position'])
newstream.remove(newstream[0])
times = np.arange(0,newstream[0].stats.npts*newstream[0].stats.delta, newstream[0].stats.delta)*1e6  
inc = newstream[1].stats.x_position - newstream[0].stats.x_position # spacing between x-position

# wiggle plot of raw data
i=0
beg = 0
end = int(350e-6/trace.stats.delta)
print( 'dx=',  stream[1].stats.x_position - stream[0].stats.x_position)
for trace in newstream: 
    trace.data*=inc*150
    trace.data = trace.data + trace.stats.x_position # arrange to plot vs position
    trace.data = trace.data[beg:end]
    ax.plot(trace.data, times[0:len(trace.data)], color='black')
    ax.set_aspect(0.008)

plt.xlim((newstream[0].stats.x_position-inc-0.01,newstream[len(newstream)-1].stats.x_position+inc+0.01))
plt.xlabel('$z$ (cm)')
plt.ylabel('Time ($\mu$s)')
plt.ylim((350,0))
plt.show()

# velocity vs. semblance plot
semblance = []
vel = np.linspace(342,346.5,30)
summ = np.zeros((len(vel),300))

i=0
ax = plt.figure().add_subplot(111)
for v in vel:
    newstream = stream.copy()
    for trace in newstream:
        x1 = trace.stats.x_position/100 #position in m
        t1 = x1/v #time in s
        i1 = int(t1/trace.stats.delta) #index
        trace.data = trace.data[i1:i1+300]
        summ[i,:] = summ[i,:] + np.transpose(trace.data)
    semblance.append(max(summ[i,:])/len(stream))
    i+=1
semblance = semblance/max(semblance)
plt.plot(vel,semblance)
ax.set_aspect(2.5)
plt.xlabel('Velocity (m/s)')
plt.ylabel('Semblance (A.U.)')
plt.show()

i= np.where(semblance == max(semblance))[0][0]
v = vel[i]
print( 'Velocity of air is %s m/s '%v)

for trace in stream:
    x1 = trace.stats.x_position/100 # position in m
    t1 = x1/v # time in s
    i1 = int(t1/trace.stats.delta)
    trace.data = trace.data[i1:i1+300]

# air-gap corrected data
fig, ax = Plot().wiggle(stream, dimension='x',show=False)
ax.set_ylim((25,10))
ax.set_xlabel('$z$ (cm)')
plt.show()

# ----------------------------------
# attenuation coefficient
# ----------------------------------
i = 0
maxPower = []
maxFreq = []
gapPower = []
masterPower = []

stream.remove(stream[0])
ref = stream[len(stream)-1]


#create array with only direct wave
for trace in stream:   
    corr = np.correlate(ref.data,trace.data,'full')
    #the time delay between the two signals is determined by the argument of the maximum
    delay = int(ref.stats.npts-argmax(corr))    
    trace.data = trace.data[delay+120:delay+210]
   
    if abs(trace.data[35]) < 1e-3:
        stream.remove(trace)
    else:
        t = np.linspace(0,trace.stats.npts*trace.stats.delta,num=trace.stats.npts)
    
        trace.detrend()

        fig=plt.figure(2)
        plt.plot(t*1e6,trace.data*1e3)
        plt.ylabel('Amplitude (mV)')
        plt.xlabel('Relative Time ($\mu$s)')
        
        # Determine frequency spectrum
        n = nextpow2(2*len(trace)) 
        FFT = fft.rfft(trace,n) 
        freqs = fft.rfftfreq(n, trace.stats.delta) 
        power = 20*np.log10(FFT)
        masterPower.append(power)

        # determine dominant frequency
        maxPower.append(max(power))
        index = np.where(power == max(power))[0][0]
        maxFreq.append(abs(freqs[index]))
        gapPower.append(trace.stats.x_position)

        #Plot frequency spectra
        fig=plt.figure(3)
        plt.plot(freqs*1e-6,power)
        plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
        plt.xlim((0,1))
        plt.xlabel('Frequency (MHz)')
        plt.ylabel('Power (dB)')
    
plt.show()

masterPower = np.array(masterPower)
attenuation = []
freqAtt = []
residuals = []
err = []
xerr=[]
for i in range(6,16,1): # frequencies up to ~1MHz
    power_trace = []
    for j in range(0,len(stream)):
        power_trace.append(masterPower[j,i])
    fitCoeffs_0, fitCoeffs_1, r_value, p_value, std_err = linregress(gapPower, power_trace)
    err.append(std_err)

    fit = []
    for k in range(0,len(gapPower)):
        fit.append(fitCoeffs_0*gapPower[k] + fitCoeffs_1)
        
    attenuation.append(np.real(fitCoeffs_0))
    freqAtt.append(freqs[i]*1e-3)
    plt.plot(gapPower,fit, label=str(int(freqs[i]*1e-3))+'kHz')    

plt.legend()
plt.xlabel('$z$ (cm)')
plt.ylabel('Power (dB)')
plt.show()
plt.plot(freqAtt,np.absolute(attenuation),'ko')
plt.xlim((min(freqAtt),max(freqAtt)))
plt.xlabel('Frequency (kHz)')
plt.ylabel('Attenuation (dB/cm)')
plt.show()


#attenuation coefficient vs freq curve
attCoeffs, c = np.polyfit(freqAtt,attenuation,1,cov=True)

att = []
for l in range(0,len(freqAtt)):
    att.append(-attCoeffs[0]*freqAtt[l] - attCoeffs[1])

attenuation_minus = []
for i in range(0,len(attenuation)):
    attenuation_minus.append(-1*attenuation[i])
plt.subplot(1,2,1)
plt.plot(freqAtt,attenuation_minus,'ko')
plt.plot(freqAtt,att,'k')
plt.xlabel('Frequency (kHz)')
plt.ylabel('Attenuation Coefficient (dB cm$^{-1}$)')
plt.show()

# attenuation of dominant frequency
pfitCoeffs = np.polyfit(gapPower,maxPower,1)
pfit = []
for k in range(0,len(gapPower)):
        pfit.append(pfitCoeffs[0]*gapPower[k] + pfitCoeffs[1])
print( 'Attenuation in maximum frequency: ', np.real(pfitCoeffs[0]), '(db/cm)')
plt.plot(gapPower,maxPower,'ro')
plt.plot(gapPower,pfit,'k')
plt.xlabel('$z$ (cm)')
plt.ylabel('Max Power (dB) at 250 kHz')
plt.show()

# amplitude vs. air-gap
maximum = []
minimum = []
gap = []
i=0
for trace in stream:
    maximum.append(max(trace)*1e3)
    minimum.append(min(trace)*1e3)
    gap.append(trace.stats.x_position)

if abs(max(maximum)) > abs(max(minimum)):
    plt.scatter(gap,maximum,s=10,c='blue')
else:
    plt.scatter(gap,minimum,s=10,c='blue')
plt.xlabel('$z$ (cm)')
plt.ylabel('Maximum Amplitude (A.U.)')
plt.show()

gap = np.array(gap)
popt, pcov = curve_fit(funct,gap,maximum)
popt[0] = popt[0]*-1
maximum = np.array(maximum)

plt.subplot2grid((1,2),(0,1))
for i in range(0,len(err)):
    plt.errorbar(freqAtt[i],attenuation_minus[i],yerr=err[i],fmt='ko',ecolor='k')
plt.plot(freqAtt,att,'k')
plt.xlabel('Frequency (kHz)')
plt.ylabel('Attenuation Coefficient (dB cm$^{-1}$)')

plt.subplot2grid((1,2,),(0,0))
plt.scatter(gap,maximum,s=10,c='blue')
plt.yscale('log')
plt.xlim((0,10))
plt.xlabel('$z$ (cm)')
plt.ylabel('Maximum Amplitude (A.U.)')
plt.show()

print ('standard deviation max: ', np.std(maximum), 'mV')
print ('variation coefficient max: ', abs(100*(np.std(maximum)/np.average(maximum))),'%\n')
print ('standard deviation min: ', np.std(minimum), 'mV')
print ('variation coefficient min: ', abs(100*(np.std(minimum)/np.average(minimum))),'%\n')
print ('average max frequency: ', np.average(maxFreq)*1e-3, 'kHz')
print ('standard deviation max freq: ', np.std(maxFreq)*1e-3, 'kHz')
print ('variation coefficient max freq: ', abs(100*(np.std(maxFreq)/np.average(maxFreq))), '%\n')

cmat = np.corrcoef(np.array(stream[:]))
l = len(cmat)
M = eye(l)
correlations = cmat-M
cmean = np.average(correlations)
print ('The average correlation coefficient is %.2f' %cmean)

