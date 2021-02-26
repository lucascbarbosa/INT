import numpy as  np

imgdata = np.zeros((10,10))
h,w = imgdata.shape
coords = [[1,3],[2,7],[4,2],[5,2]]

k = 1
for i,j in coords:
    imgdata[i,j] = k
    k += 1

for i,j in coords:
    imgdata[i,(w-1)-j] = imgdata[i,j]
    imgdata[(h-1)-i,j] = imgdata[i,j]
    imgdata[(h-1)-i,(w-1)-j] = imgdata[i,j]
print(imgdata)