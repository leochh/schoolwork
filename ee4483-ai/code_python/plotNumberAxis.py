import matplotlib.pyplot as plt
import numpy as np

fig = plt.figure()
ax = fig.add_subplot(111)

a = [0,1,1.75,1.912931,2.625,3.5,7]
plt.hlines(0,0,10)
plt.ylim(-1,1)
y = np.zeros(np.shape(a))
plt.plot(a,y,'.',ms=6)
ax.text(0,-0.1,r'0')
ax.text(1,-0.1,r'1')
ax.annotate(r'$x_{mid_1}$',xy=(1.75,0.01),xytext=(1.75,0.15),
            arrowprops=dict(arrowstyle="->"))
ax.annotate(r'$\sqrt[3]{x_0}$',xy=(1.912931,-0.01),xytext=(1.912931,-0.2),
            arrowprops=dict(arrowstyle="->"))
ax.annotate(r'$x_{mid_2}$',xy=(2.625,0.01),xytext=(2.625,0.15),
            arrowprops=dict(arrowstyle="->"))
ax.text(3.5,-0.1,r'$x_{mid_0}$')
ax.text(7,-0.1,r'$x_0$')
plt.axis('off')
plt.draw()