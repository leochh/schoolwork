import os
from PIL import Image
import matplotlib.pyplot as plt
import point_processing as pp
import matlab_func
import filters


IMAGE_PATH = [os.path.join(os.getcwd(), 'sample_data', 'Img{}.jpg'.format(i)) for i in range(1,12)]
image_path = IMAGE_PATH[5]

im = Image.open(image_path)
im_np_color = pp.load_image_into_numpy_array(im)
im_gray = im.convert(mode='L')
im_np_gray = pp.load_image_into_numpy_array(im_gray)

# im_r = pp.select_color_channel(im_np_color, 0)
# plt.imshow(im_r)
# plt.show()


# level = 3
# t = pp.lloyd_quantize(im_np_gray, level)
# im_np_sliced = pp.gray_level_window_slice(im_np_gray, t, [0, -1])
# im_np_sliced = pp.n_bit_plane_slice(im_np_gray,1)
# im_np_sliced = pp.contrast_stretch(im_np_gray, [0.1, 0.9])
# im_np_histeq = pp.histeq(im_np_gray)
# plt.hist(im_np_histeq.flatten(), 256, [0,255],fc='k',ec='k')
# plt.imshow(im_np_histeq, cmap='gray')
# plt.show()


# im_filtered = filters.sobel(im_np_gray, direction='+')
# im_filtered = filters.laplacian_of_gaussian(im_np_gray)
# im_filtered = filters.median(im_np_gray)
# im_filtered = filters.laplacian(im_np_gray, 2)
# im_filtered = filters.line_detector(im_np_gray, direction='*')
# plt.hist(im_filtered.flatten(), 256, [0,255],fc='k',ec='k')
# plt.imshow(im_filtered, cmap='gray')
# plt.show()


# mat = matlab_func.MatlabFunction()
# mask = np.ones([3,3]) / 9
# im_out = mat.conv2(im_np_gray, mask)
# im_out = mat.sobel_filter(im_np_gray)
# plt.imshow(im_out, cmap='gray')
# plt.show)
