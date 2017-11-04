import numpy as np
from scipy import signal
from skimage.filters.rank import otsu, enhance_contrast
from skimage.filters import threshold_li
from skimage.morphology import disk

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


def mean(im_np, type=1):
    m_1 = np.array([[1,1,1],
                    [1,1,1],
                    [1,1,1]]) / 9
    m_2 = np.array([[0,1,0],
                    [1,4,1],
                    [0,1,0]]) / 8
    m_3 = np.array([[1,2,1],
                    [2,4,2],
                    [1,2,1]]) / 16
    m_4 = np.array([[1,1,1,1,1],
                    [1,1,1,1,1],
                    [1,1,1,1,1],
                    [1,1,1,1,1],
                    [1,1,1,1,1]]) / 25
    m_5 = np.array([[1,4,7,4,1],
                    [4,16,26,16,4],
                    [7,26,41,26,7],
                    [4,16,26,16,4],
                    [1,4,7,4,1]]) / 273
    if type == 1:
        im_out = signal.convolve2d(im_np, m_1)
    elif type == 2:
        im_out = signal.convolve2d(im_np, m_2)
    elif type == 3:
        im_out = signal.convolve2d(im_np, m_3)
    elif type == 4:
        im_out = signal.convolve2d(im_np, m_4)
    elif type == 5:
        im_out = signal.convolve2d(im_np, m_5)
    return im_out


def laplacian(im_np, type=1):
    mask_1 = np.array([[0,-1,0],
                       [-1,4,-1],
                       [0,-1,0]])
    mask_2 = np.array([[-1,-1,-1],
                       [-1,8,-1],
                       [-1,-1,-1]])
    mask_3 = - mask_1
    mask_4 = - mask_2
    if type == 1:
        lap = mask_1
    elif type == 2:
        lap = mask_2
    elif type == 3:
        lap = mask_3
    elif type == 4:
        lap = mask_4
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


def otsu_threshold(im_np, rad):
    local_otsu = otsu(im_np, disk(rad))
    thresh_image = im_np >= local_otsu
    return thresh_image


def contrast_enhan(im_np, rad):
    im_new = enhance_contrast(im_np, disk(rad))
    return im_new


def li_threshold(im_np):
    thresh = threshold_li(im_np)
    thresh_image = im_np >= thresh
    return thresh_image


def alpha_trimmed_mean(im_np, window_size=3, alpha=2):
    pad_length = window_size // 2
    im_np_pad = np.pad(im_np, (pad_length,), 'edge')
    im_height, im_width = np.shape(im_np_pad)
    im_new = np.zeros(np.shape(im_np))
    for m in range(pad_length, im_height - pad_length):
        for n in range(pad_length, im_width - pad_length):
            window_elements = im_np_pad[m-pad_length:m+pad_length+1, n-pad_length:n+pad_length+1]
            ordered_elements = np.sort(window_elements, axis=None)
            im_new[m-pad_length, n-pad_length] = np.mean(
                ordered_elements[int(alpha/2):int(-(alpha/2))]).astype(np.uint8)
    return im_new


def k_means_thresh(im_np, cluster=2):
    # centroid[current centroid value:sum:count]
    centroid = np.zeros([cluster, 3])
    for k in range(cluster):
        centroid[k, 0] = (k + .5) / cluster * 255
    im_height, im_width = im_np.shape
    while True:
        check_done = True
        for m in range(im_height):
            for n in range(im_width):
                min_dist = 99999
                cent_count = 0
                target_cent = 0
                for c in range(cluster):
                    distance = abs(im_np[m,n] - centroid[c, 0])
                    if distance < min_dist:
                        min_dist = distance
                        target_cent = cent_count
                    cent_count += 1
                centroid[target_cent, 1] += im_np[m,n]
                centroid[target_cent, 2] += 1
        for c in range(cluster):
            new_cent = centroid[c, 1] / centroid[c, 2]
            if abs(centroid[c, 0] - new_cent) >= 1:
                centroid[c, 0] = new_cent
                centroid[c, 1] = 0
                centroid[c, 2] = 0
                check_done = False
        if check_done:
            break
    thresh = np.zeros([cluster - 1])
    for c in range(1, cluster):
        thresh[c - 1] = (centroid[c - 1, 0] + centroid[c, 0]) / 2
    return thresh




