import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
from skimage.filters import median
from filters import mean
from filters import laplacian_of_gaussian
from point_processing import plot_multi_img
import fourier_transform as ft

def imshow(im_np):
    plt.imshow(im_np, 'gray')
    plt.show()

def histshow(im_np):
    plt.hist(im_np.flatten(), 256, [0,255],fc='k',ec='k')
    plt.show()

im_np = np.zeros((100, 100))
im_np[:, 0:50] = 250

im_np_2 = np.zeros((100, 100))
for m in range(0, 3, 2):
    for n in range(0, 3, 2):
        im_np_2[25*m:25*(m+1), 25*n:25*(n+1)] = 255
for m in range(1, 4, 2):
    for n in range(1, 4, 2):
        im_np_2[25*m:25*(m+1), 25*n:25*(n+1)] = 255

# imshow(im_np)
imshow(im_np_2)

# new_im_np = median(im_np.astype(np.uint8))
# new_im_np_2 = median(im_np_2.astype(np.uint8))
# new_im_np = mean(im_np.astype(np.uint8))
# new_im_np_2 = mean(im_np_2.astype(np.uint8))

# imshow(new_im_np)
# imshow(new_im_np_2)
# histshow(new_im_np)
# histshow(new_im_np_2)

# plot_multi_img(['image1', 'mean1', 'image2', 'mean2'], [im_np, new_im_np, im_np_2, new_im_np_2], [2,2])

mask = np.array([[1,1,1],
                 [1,-8,1],
                 [1,1,1]])
#
# image = np.array([[15,15,5],
#                  [10,25,20],
#                  [5,20,11]])
# print(np.mean(im_np))
# im = laplacian_of_gaussian(im_np)
# print(np.mean(im))
# im2 = laplacian_of_gaussian(im)
# print(np.mean(im2))
# imshow(im2)

im = signal.convolve2d(im_np_2, -mask)
# im2 = signal.convolve2d(im, mask)
# im3 = signal.convolve2d(im2, mask)
# im4 = signal.convolve2d(im3, mask)
# im5 = signal.convolve2d(im4, mask)
imshow(im[1:-1,1:-1]+im_np_2)
# im_ori = ft.img2fft(im_np_2)
# im_f = ft.img2fft(im)
# mag = ft.mag_resp(im_ori)
# mag1 = ft.mag_resp(im_f)
# imshow(mag)
# imshow(mag1)
# print(im_f[2,2])
