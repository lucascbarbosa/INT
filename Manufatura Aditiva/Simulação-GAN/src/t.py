import numpy as  np

a = np.array([[1,2],[3,4]])
def mirror(seq):
    output = list(seq[::-1])
    output.extend(seq[1:])
    return output

print(np.array(mirror([mirror(sublist) for sublist in a])))