import os
import numpy as np
from PIL import Image
import matplotlib.pyplot as plt
import point_processing as pp
import fourier_transform as ft
import filters as mf
import matlab_func
import tesserocr
from scipy.misc import imresize

IMAGE_PATH = [os.path.join(os.getcwd(), 'sample_data', 'Img{}.jpg'.format(i)) for i in range(1,12)]
image_path = IMAGE_PATH[7]

im = Image.open(image_path)
im_original_color = pp.load_image_into_numpy_array(im)
im_gray = im.convert(mode='L')
im_original_gray = pp.load_image_into_numpy_array(im_gray)

def imshow(im_np):
    plt.imshow(im_np, 'gray')
    plt.show()

def histshow(im_np):
    plt.hist(im_np.flatten(), 256, [0,255],fc='k',ec='k')
    plt.show()

# histshow(im_original_gray)
# imshow(im_original_gray)

# im_np_gray_f = ft.img2fft(im_original_gray)
# mag = ft.mag_resp(im_np_gray_f)
# imshow(mag)

# Image 1, 2, 3
# im_final = pp.n_bit_plane_slice(im_original_gray, 1)
# im_show = Image.fromarray(np.uint8(im_final))
# histshow(im_final)
# imshow(im_final)

# Image 4, 5
# im_step_1 = mf.alpha_trimmed_mean(im_original_gray, window_size=3, alpha=2)
# im_final = mf.otsu_threshold(im_step_1.astype(np.uint8), 100)
# im_show = Image.fromarray(np.uint8(im_final))
# histshow(im_final)
# imshow(im_final)

# Image 6, 7
# level = 2
# 1. k-means method
# thresh = mf.k_means_thresh(im_original_gray, level)
# t = np.pad(np.uint8(thresh), (1,), 'constant', constant_values=(0, 255))
# 2. Lloyd method
# t = pp.lloyd_quantize(im_original_gray, level)
# im_final = pp.gray_level_window_slice(im_original_gray, t, [0, 255])
# im_show = Image.fromarray(np.uint8(im_final))
# histshow(im_final)
# imshow(im_final)

# Image 8
# im_step_1 = imresize(im_original_gray, (im_original_gray.shape[0] * 4, im_original_gray.shape[1] * 4))
# level = 2
# t = pp.lloyd_quantize(im_step_1, level)
# im_final = pp.gray_level_window_slice(im_step_1, t, [0, 255])
# im_show = Image.fromarray(np.uint8(im_final))
# histshow(im_final)
# imshow(im_final)

# Image 9
# mat = matlab_func.MatlabFunction()
# im_step_1 = mat.contrast_stretch(im_original_gray)
# im_step_2 = mf.otsu_threshold(im_step_1, 30)
# im_final = mf.line_mask(im_step_2, im_original_gray)
# im_show = Image.fromarray(np.uint8(im_final))
# histshow(im_final)
# imshow(im_final)

# Show Image and Text
# im_show.show()
# print(tesserocr.image_to_text(im_show))

