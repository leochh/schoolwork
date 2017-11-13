import numpy as np


def img2fft(im_np):
    im_np_f = np.fft.fft2(im_np)
    im_np_f_shift = np.fft.fftshift(im_np_f)
    return im_np_f_shift


def fft2img(im_np_f_shift):
    im_np_f = np.fft.ifftshift(im_np_f_shift)
    im_np = np.abs(np.fft.ifft2(im_np_f))
    return im_np


def mag_resp(im_np_f):
    mag = 20 * np.log(np.abs(im_np_f) + 1)
    return mag


def lpf(im_np_f, window_height=10, window_width=10):
    im_np_f_height, im_np_f_width = im_np_f.shape
    cheight, cwidth = im_np_f_height/2, im_np_f_width/2
    new_im_np_f = np.zeros(im_np_f.shape, dtype=complex)
    h_low, h_high = int(cheight-window_height/2), int(cheight+window_height/2)
    w_low, w_high = int(cwidth-window_width/2), int(cwidth+window_width/2)
    new_im_np_f[h_low:h_high, w_low:w_high] = im_np_f[h_low:h_high, w_low:w_high]
    return new_im_np_f


def filter1(im_np_f):
    im_np_f_height, im_np_f_width = im_np_f.shape
    cheight, cwidth = int(im_np_f_height/2), int(im_np_f_width/2)
    new_im_np_f = np.copy(im_np_f)
    for k in range(1,8):
        cen_h1 = cheight+12*k
        cen_h2 = cheight-11*k
        new_im_np_f[cen_h1-1:cen_h1+1, cwidth-9:cwidth-2] = 0
        new_im_np_f[cen_h2-1:cen_h2+1, cwidth-9:cwidth-2] = 0
        new_im_np_f[cen_h1-1:cen_h1+1, cwidth+2:cwidth+9] = 0
        new_im_np_f[cen_h2-1:cen_h2+1, cwidth+2:cwidth+9] = 0
    return new_im_np_f


def filter2(im_np_f, window_height=10, window_width=10):
    im_np_f_height, im_np_f_width = im_np_f.shape
    cheight, cwidth = int(im_np_f_height/2), int(im_np_f_width/2)
    new_im_np_f = np.zeros(im_np_f.shape, dtype=complex)
    h_low, h_high = int(cheight-window_height/2), int(cheight+window_height/2)
    w_low, w_high = int(cwidth-window_width/2), int(cwidth+window_width/2)
    new_im_np_f[h_low:h_high, :] = im_np_f[h_low:h_high, :]
    new_im_np_f[:, w_low:w_high] = im_np_f[:, w_low:w_high]
    return new_im_np_f


def filter3(im_np_f):
    im_np_f_height, im_np_f_width = im_np_f.shape
    cheight, cwidth = int(im_np_f_height/2), int(im_np_f_width/2)
    new_im_np_f = np.copy(im_np_f)
    for k in range(1,3):
        cen_w1 = cwidth+88*k
        cen_w2 = cwidth-87*k
        for p in range(1,6):
            cen_h1 = cheight+66*p
            cen_h2 = cheight-65*p
            new_im_np_f[cen_h1-10:cen_h1+10, cen_w1-2:cen_w1+2] = 0
            new_im_np_f[cen_h1-10:cen_h1+10, cen_w2-2:cen_w2+2] = 0
            new_im_np_f[cen_h2-10:cen_h2+10, cen_w1-2:cen_w1+2] = 0
            new_im_np_f[cen_h2-10:cen_h2+10, cen_w2-2:cen_w2+2] = 0
    return new_im_np_f

def filter4(im_np_f):
    im_np_f_height, im_np_f_width = im_np_f.shape
    cheight, cwidth = int(im_np_f_height/2), int(im_np_f_width/2)
    new_im_np_f = np.copy(im_np_f)
    for k in range(1,2):
        cen_w1 = cwidth+196*k
        cen_w2 = cwidth-195*k
        for p in range(1,2):
            cen_h1 = cheight+116*p
            cen_h2 = cheight-115*p
            new_im_np_f[cen_h1-5:cen_h1+5, cen_w1-5:cen_w1+5] = 0
            new_im_np_f[cen_h1-5:cen_h1+5, cen_w2-5:cen_w2+5] = 0
            new_im_np_f[cen_h2-5:cen_h2+5, cen_w1-5:cen_w1+5] = 0
            new_im_np_f[cen_h2-5:cen_h2+5, cen_w2-5:cen_w2+5] = 0
    for k in range(1,2):
        cen_w1 = cwidth+268*k
        cen_w2 = cwidth-267*k
        new_im_np_f[cheight-250:cheight-5, cen_w1-2:cen_w1+2] = 0
        new_im_np_f[cheight-250:cheight-5, cen_w2-2:cen_w2+2] = 0
        new_im_np_f[cheight+5:cheight+250, cen_w1-2:cen_w1+2] = 0
        new_im_np_f[cheight+5:cheight+250, cen_w2-2:cen_w2+2] = 0
    return new_im_np_f
