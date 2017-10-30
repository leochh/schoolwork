import numpy as np
from scipy import signal


def sobel(im_np, direction='+'):
    sobel_h = np.array([[1,2,1],
                        [0,0,0],
                        [-1,-2,-1]])
    sobel_v = np.transpose(sobel_h)
    sobel_45p = np.array([[0,1,2],
                          [-1,0,1],
                          [-2,-1,0]])
    sobel_45n = np.array([[-2,-1,0],
                          [-1,0,1],
                          [0,1,2]])
    if direction == '+':
        g_h = signal.convolve2d(im_np, sobel_h)
        g_v = signal.convolve2d(im_np, sobel_v)
        im_out = np.sqrt(g_h**2 + g_v**2)
    elif direction == 'X' or 'x':
        g_h = signal.convolve2d(im_np, sobel_45p)
        g_v = signal.convolve2d(im_np, sobel_45n)
        im_out = np.sqrt(g_h**2 + g_v**2)
    return im_out


def laplacian_of_gaussian(im_np):
    log = np.array([[0,0,-1,0,0],
                    [0,-1,-2,-1,0],
                    [-1,-2,16,-2,-1],
                    [0,-1,-2,-1,0],
                    [0,0,-1,0,0]])
    im_out = signal.convolve2d(im_np, log)
    return im_out


def median(im_np):
    med = np.array([[1,1,1],
                    [1,1,1],
                    [1,1,1]]) / 9
    im_out = signal.convolve2d(im_np, med)
    return im_out


def laplacian(im_np, type=1):
    mask_1 = np.array([[0,-1,0],
                       [-1,-4,-1],
                       [0,-1,0]])
    mask_2 = np.array([[-1,-1,-1],
                       [-1,8,-1],
                       [-1,-1,-1]])
    if type == 1:
        lap = mask_1
    elif type == 2:
        lap = mask_2
    im_out = signal.convolve2d(im_np, lap)
    return im_out


def line_detector(im_np, direction='|'):
    line_h = np.array([[-1,-1,-1],
                       [2,2,2],
                       [-1,-1,-1]])
    line_v = np.transpose(line_h)
    line_45p = np.array([[2,-1,-1],
                         [-1,2,-1],
                         [-1,-1,2]])
    line_45n = np.array([[-1,-1,2],
                         [-1,2,-1],
                         [2,-1,-1]])
    if direction == '-':
        im_out = signal.convolve2d(im_np, line_h)
    elif direction == '|':
        im_out = signal.convolve2d(im_np, line_v)
    elif direction == '+':
        g_h = signal.convolve2d(im_np,line_h)
        g_v = signal.convolve2d(im_np,line_v)
        im_out = np.sqrt(g_h**2 + g_v**2)
    elif direction == '/':
        im_out = signal.convolve2d(im_np, line_45p)
    elif direction == '\\':
        im_out = signal.convolve2d(im_np, line_45n)
    elif direction == 'X' or 'x':
        g_h = signal.convolve2d(im_np,line_45p)
        g_v = signal.convolve2d(im_np,line_45n)
        im_out = np.sqrt(g_h**2 + g_v**2)
    elif direction == '*':
        g_h = signal.convolve2d(im_np,line_h)
        g_v = signal.convolve2d(im_np,line_v)
        s_h = signal.convolve2d(im_np,line_45p)
        s_v = signal.convolve2d(im_np,line_45n)
        im_out = np.sqrt(g_h**2 + g_v**2 + s_h**2 + s_v**2)
    return im_out
