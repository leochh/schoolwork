import numpy as np
import matplotlib.pyplot as plt
from skimage.filters import median
from filters import mean
from point_processing import plot_multi_img

def imshow(im_np):
    plt.imshow(im_np, 'gray')
    plt.show()

def histshow(im_np):
    plt.hist(im_np.flatten(), 256, [0,255],fc='k',ec='k')
    plt.show()

im_np = np.zeros((100, 100))

im_np[:, 0:50] = 255
im_np_2 = np.zeros((100, 100))
for m in range(0, 3, 2):
    for n in range(0, 3, 2):
        im_np_2[25*m:25*(m+1), 25*n:25*(n+1)] = 255
for m in range(1, 4, 2):
    for n in range(1, 4, 2):
        im_np_2[25*m:25*(m+1), 25*n:25*(n+1)] = 255

# imshow(im_np_2)
# new_im_np = median(im_np.astype(np.uint8))
# new_im_np_2 = median(im_np_2.astype(np.uint8))

new_im_np = mean(im_np.astype(np.uint8))
new_im_np_2 = mean(im_np_2.astype(np.uint8))

# imshow(new_im_np)
# imshow(new_im_np_2)
histshow(new_im_np*255)
histshow(new_im_np_2*25)

# plot_multi_img(['image1', 'mean1', 'image2', 'mean2'], [im_np, new_im_np, im_np_2, new_im_np_2], [2,2])
