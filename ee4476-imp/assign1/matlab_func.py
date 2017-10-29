import matlab
import numpy as np

class MatlabFunction():
    def __init__(self):
        self.eng = matlab.engine.start_matlab()

    def matlab_convolve(self,im_np):
        mask = np.ones([5,5]) / 25
        mask2 = np.array([[1.,2.,1.],
                          [0.,0.,0.],
                          [-1.,-2.,-1.]])
        # Pass variable to matlab
        im_mat = matlab.double(im_np.tolist())
        mask2_mat = matlab.double(mask2.tolist())
        out = self.eng.conv2(im_mat, mask2_mat)
        out_uint8 = self.eng.uint8(out)
        return out_uint8




