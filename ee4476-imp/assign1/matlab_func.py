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
        out_uint8 = self.eng.sobel_filter(im_mat)
        return out_uint8



