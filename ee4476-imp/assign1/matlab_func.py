import matlab.engine
import numpy as np
import math


class MatlabFunction():
    def __init__(self):
        self.eng = matlab.engine.start_matlab()

    def conv2(self, a1, a2):
        # Pass variables to matlab
        a1_mat = matlab.double(a1.tolist())
        a2_mat = matlab.double(a2.tolist())
        out = self.eng.conv2(a1_mat, a2_mat)
        out_uint8 = self.eng.uint8(out)
        return out_uint8

    def sobel_filter(self, im_np):
        im_mat = matlab.double(im_np.tolist())
        out = self.eng.sobel_filter(im_mat)
        return out

    def contrast_stretch(self, im_np):
        im_mat = matlab.double(im_np.tolist())
        img = self.eng.mat2gray(im_mat)
        low_high = self.eng.stretchlim(img)
        out = self.eng.imadjust(img, low_high, [])
        out_np = self.mat2np(out) * 255.
        return out_np.astype(np.uint8)

    def mat2np(self, in_array):
        out_array = []
        for _ in range(in_array.size[0]):
            lst = in_array._data[_::in_array.size[0]].tolist()
            out_array.append(lst)
        out_np = np.array(out_array)
        return out_np


