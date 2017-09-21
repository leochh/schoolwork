import matplotlib.pyplot as plt
import numpy as np

fig = plt.figure()
ax = fig.add_subplot(111)

# -------Plot x>1 number axis-----------#
# a = [0,1,1.75,1.912931,2.625,3.5,7]
# plt.hlines(0,0,10)
# plt.ylim(-1,1)
# y = np.zeros(np.shape(a))
# plt.plot(a,y,'.',ms=6)
# ax.text(0,-0.1,r'0')
# ax.text(1,-0.1,r'1')
# ax.annotate(r'$x_{mid_1}$',xy=(1.75,0.01),xytext=(1.75,0.15),
#             arrowprops=dict(arrowstyle="->"))
# ax.annotate(r'$\sqrt[3]{x_0}$',xy=(1.912931,-0.01),xytext=(1.912931,-0.2),
#             arrowprops=dict(arrowstyle="->"))
# ax.annotate(r'$x_{mid_2}$',xy=(2.625,0.01),xytext=(2.625,0.15),
#             arrowprops=dict(arrowstyle="->"))
# ax.text(3.5,-0.1,r'$x_{mid_0}$')
# ax.text(7,-0.1,r'$x_0$')
# plt.axis('off')
# plt.draw()

# -------Plot x<1 number axis-----------#
# a = [0,0.4,0.7,0.7368,0.775,0.85,1]
# plt.hlines(0,0,1.2)
# plt.ylim(-1,1)
# y = np.zeros(np.shape(a))
# plt.plot(a,y,'.',ms=6)
# ax.text(0,-0.1,r'0')
# ax.text(1,-0.1,r'1')
# ax.annotate(r'$x_{mid_1}$',xy=(0.85,0.01),xytext=(0.8,0.15),
#             arrowprops=dict(arrowstyle="->"))
# ax.annotate(r'$\sqrt[3]{x_0}$',xy=(0.7368,-0.01),xytext=(0.73,-0.2),
#             arrowprops=dict(arrowstyle="->"))
# ax.annotate(r'$x_{mid_2}$',xy=(0.775,0.01),xytext=(0.7,0.15),
#             arrowprops=dict(arrowstyle="->"))
# ax.annotate(r'$x_{mid_0}$',xy=(0.7,0.01),xytext=(0.6,0.15),
#             arrowprops=dict(arrowstyle="->"))
# ax.text(0.4,-0.1,r'$x_0$')
# plt.axis('off')
# plt.show()

# --------Plot Newton-Raphson method sample-----------#
ax.spines['left'].set_position(('data',0))
ax.spines['bottom'].set_position(('data',0))
ax.spines['right'].set_color('none')
ax.spines['top'].set_color('none')

plt.xlim(-2,10)
plt.ylim(-100,500)
xcood = np.arange(-2, 10, 0.01)
x0 = 7

def f(x):
    return np.power(x,3) - x0

def tan(xn):
    fprime = 3 * xn * xn
    return f(xn) + fprime * (xcood - xn)

xarray = np.array([x0])
for t in range(2):
    a = xarray[t]
    ya = f(a)
    xarray = np.append(xarray,[a - ya/(3*a*a)])

m = 0
for t in xarray:
    tanx = tan(t)
    ycood = np.arange(-10, f(t)+25, 0.1)
    plt.plot(xcood,tanx,'-.r')
    plt.plot(np.repeat(t,np.shape(ycood)),ycood,'--b')
    ax.text(t-0.1,-30,r'$x_{%s}$' % m)
    m += 1

y = f(xcood)
plt.plot(xcood, y)

plt.show()
