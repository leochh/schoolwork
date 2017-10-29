import numpy as np
import collections


def load_image_into_numpy_array(image):
    (im_width, im_height) = image.size
    if len(image.getbands()) == 3:
        img_array = np.array(image.getdata()).reshape((im_height, im_width, 3)).astype(np.uint8)
    if len(image.getbands()) == 1:
        img_array = np.array(image.getdata()).reshape((im_height, im_width)).astype(np.uint8)
    return img_array


def lloyd_quantize(im_np, level=2):
    pix_count = collections.Counter(np.ravel(im_np))
    pix_count_total = len(np.ravel(im_np))
    t = np.zeros([level+1])
    r = np.zeros([level])
    # Initialize t with even gray-level distribution
    for k in range(level+1):
        t[k] = k / level * 255
    while True:
        check_done = True
        for k in range(level):
            r_num = 0
            r_den = 0
            for f in range(t[k].astype(np.uint8), t[k+1].astype(np.uint8)+1):
                pf = pix_count[f] / pix_count_total
                r_num += f * pf
                r_den += pf
            r[k] = r_num / r_den
        for k in range(1, level):
            temp = round((r[k] + r[k-1]) / 2)
            if temp != t[k]:
                t[k] = temp
                check_done = False
        if check_done is True:
            break
    return t.astype(np.uint8)


def gray_level_window_slice(im_np, win, val):
    if len(val) != len(win)-1:
        raise ValueError('len(val) should be len(win) -1')
    new_im = np.zeros(im_np.shape)
    im_width, im_length = im_np.shape
    for x in range(im_width):
        for y in range(im_length):
            for k in range(1, len(win)):
                if win[k] > im_np[x, y] >= win[k-1]:
                    if val[k-1] == -1:
                        new_im[x, y] = im_np[x, y]
                    else:
                        new_im[x, y] = val[k-1]

    return new_im.astype(np.uint8)


def n_bit_plane_slice(im_np, b=1):
    new_im = np.zeros(im_np.shape)
    im_width, im_length = im_np.shape
    for x in range(im_width):
        for y in range(im_length):
            i_n = im_np[x, y] // (2 ** (8 - b))
            i_n_1 = im_np[x, y] // (2 ** (9 - b))
            new_im[x, y] = (i_n - i_n_1 * 2) * 255
    return new_im.astype(np.uint8)


def contrast_stretch(im_np, percentiles=np.array([0.05,0.95])):
    print(percentiles)
    pass


def histeq(im_np):
    pix_count = collections.Counter(np.ravel(im_np))
    pix_count_total = len(np.ravel(im_np))
    cf = np.zeros([256])
    for f in range(256):
        pf = pix_count[f] / pix_count_total
        if f == 0:
            cf[f] = pf
        else:
            cf[f] = cf[f-1] + pf
    c_min = min(cf)
    new_im = np.zeros(im_np.shape)
    im_width, im_length = im_np.shape
    for x in range(im_width):
        for y in range(im_length):
            new_im[x, y] = ((cf[im_np[x, y]] - c_min) / (1 - c_min) * 255 + 0.5) // 1
    return new_im.astype(np.uint8)
