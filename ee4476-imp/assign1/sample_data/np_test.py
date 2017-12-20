import numpy as np

a = np.array([[0,1,0],
          [1,1,1],
          [0,1,0]])

b = np.array([[0, 255, 0],
              [0,0,0],
              [0,0,0]])

c = np.logical_and(a, b).any()
print(c)
