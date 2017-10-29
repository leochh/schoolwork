import os
import numpy as np
from PIL import Image
import matplotlib.pyplot as plt
import point_processing as pp


IMAGE_PATH = [os.path.join(os.getcwd(), 'sample_data', 'Img{}.jpg'.format(i)) for i in range(1,12)]
image_path = IMAGE_PATH[0]
im = Image.open(image_path)
im_gray = im.convert(mode='L')

# im_np = pp.load_image_into_numpy_array(im)
# color_channel = 1  # 0,1,2 = Red,Green,Blue
# temp = np.zeros(im_np.shape, dtype='float64')
# temp[:,:,color_channel] = im_np[:,:,color_channel]
# temp[:,:,:] = im_np[:,:,::-1]
# plt.imshow(temp)
# plt.show()

im_np_gray = pp.load_image_into_numpy_array(im_gray)
# level = 3
# t = pp.lloyd_quantize(im_np_gray, level)
# im_np_sliced = pp.gray_level_window_slice(im_np_gray, t, [0, -1])
# im_np_sliced = pp.n_bit_plane_slice(im_np_gray,1)
# im_np_sliced = pp.contrast_stretch(im_np_gray, [0.1, 0.9])
im_np_histeq = pp.histeq(im_np_gray)

# plt.hist(im_np_histeq.flatten(), 256, [0,255],fc='k',ec='k')
plt.imshow(im_np_histeq, cmap='gray')
plt.show()

