import os
from PIL import Image
import matplotlib.pyplot as plt
import point_processing as pp
import filters
import matlab_func
import numpy as np
import tesserocr
from scipy.signal import wiener

IMAGE_PATH = [os.path.join(os.getcwd(), 'sample_data', 'Img{}.jpg'.format(i)) for i in range(1,12)]
image_path = IMAGE_PATH[9]

im = Image.open(image_path)
im_np_color = pp.load_image_into_numpy_array(im)
im_gray = im.convert(mode='L')
im_np_gray = pp.load_image_into_numpy_array(im_gray)


# Image 1, 2, 3
# im_np_sliced = pp.n_bit_plane_slice(im_np_gray, 1)
# im_show = Image.fromarray(np.uint8(im_np_sliced))
# plt.hist(im_np_sliced.flatten(), 256, [0,255],fc='k',ec='k')
# plt.imshow(im_np_sliced, cmap='gray')
# plt.show()


# Image 4
# im_alpha_trimmed_mean = filters.alpha_trimmed_mean(im_np_gray, window_size=3, alpha=2)
# im_thresh_otsu = filters.otsu_threshold(im_alpha_trimmed_mean.astype(np.uint8), 100)
# im_show = Image.fromarray(np.uint8(im_thresh_otsu*255))
# plt.hist(im_thresh_otsu.flatten(), 256, [0,255],fc='k',ec='k')
# plt.imshow(im_thresh_otsu, cmap='gray')
# plt.show()


# Image 6
# level = 2
# thresh = filters.k_means_thresh(im_np_gray, level)
# t = np.pad(np.uint8(thresh), (1,), 'constant', constant_values=(0, 255))
# t = pp.lloyd_quantize(im_np_gray, level)
# im_np_sliced = pp.gray_level_window_slice(im_np_gray, t, [0, 255])
# im_show = Image.fromarray(np.uint8(im_np_sliced))
# plt.hist(im_np_sliced.flatten(), 256, [0,255],fc='k',ec='k')
# plt.imshow(im_np_sliced, cmap='gray')
# plt.show()


# Show Image and Text
# im_show.show()
# print(tesserocr.image_to_text(im_show))







# im_np_wiener = wiener(im_np_gray)
# plt.imshow(im_np_wiener, 'gray')
# plt.show()


# plt.hist(im_np_gray.flatten(), 256, [0,255],fc='k',ec='k')
# plt.show()

# im_r = pp.select_color_channel(im_np_color, 0)
# plt.imshow(im_r)
# plt.show()

# im_alpha_trimmed_mean = filters.alpha_trimmed_mean(im_np_gray, window_size=3, alpha=2)
# plt.imshow(im_alpha_trimmed_mean, cmap='gray')
# plt.show()


# im_thresh_otsu = filters.otsu_threshold(im_np_gray.astype(np.uint8), 100)
# plt.hist(im_thresh_otsu.flatten(), 256, [0,255],fc='k',ec='k')
# plt.imshow(im_thresh_otsu, cmap='gray')
# plt.show()

# im_show = pp.convert_numpy_array_to_image(im_thresh_otsu)
# im_show.show()
# print(tesserocr.image_to_text(im_show))

# im_alpha_trimmed_mean = filters.alpha_trimmed_mean(im_np_gray, window_size=3, alpha=2)
# im_np_sliced = pp.n_bit_plane_slice(im_alpha_trimmed_mean, 1)

# level = 2
# t = pp.lloyd_quantize(im_np_gray, level)
# im_np_sliced = pp.gray_level_window_slice(im_np_gray, t, [0, 255])
# thresh = filters.k_means_thresh(im_np_gray, 2)
# print(thresh)
# im_np_sliced_1 = pp.n_bit_plane_slice(im_np_gray, 1)
# im_np_sliced = pp.contrast_stretch(im_np_gray, [0.1, 0.9])
# im_np_histeq = pp.histeq(im_np_gray)
# plt.hist(im_np_histeq.flatten(), 256, [0,255],fc='k',ec='k')
# plt.imshow(im_np_histeq, cmap='gray')
# plt.imshow(im_np_sliced, cmap='gray')
# plt.imshow(np.sqrt(im_np_sliced**2 + im_np_sliced_1**2).astype(np.uint8), cmap='gray')
# plt.show()


# im_filtered = filters.line_detector(im_np_sliced, direction='*')
# im_filtered = filters.sobel(im_np_sliced, direction='+')

# im_filtered = filters.alpha_trimmed_mean(im_np_gray, window_size=3, alpha=2)
# im_filtered = filters.sobel(im_alpha_trimmed_mean, direction='*')
# im_filtered = filters.sobel(im_np_gray, direction='*')
# im_filtered = filters.laplacian_of_gaussian(im_np_gray)
# im_filtered = filters.mean(im_np_gray)
# im_filtered = filters.laplacian(im_np_gray, type=3)
# im_filtered = filters.line_detector(im_np_gray, direction='*')
# plt.hist(im_filtered.flatten(), 256, [0,255],fc='k',ec='k')
# plt.imshow(pp.gray_level_reversal(im_filtered), cmap='gray')
# plt.imshow(im_filtered, cmap='gray')
# plt.show()

# plt.imshow(im_filtered, cmap='gray')
# plt.show()

# im_show = Image.fromarray(np.uint8(im_np_sliced))
# im_show.show()
# print(tesserocr.image_to_text(im_show))

# mat = matlab_func.MatlabFunction()
# mask = np.ones([3,3]) / 9
# im_out = mat.conv2(im_np_gray, mask)
# im_out = mat.sobel_filter(im_np_gray)
# plt.imshow(im_out, cmap='gray')
# plt.show)
