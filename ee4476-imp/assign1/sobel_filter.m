function [ out ] = sobel_filter( img )
sobel_mask_h = [1 2 1;0 0 0;-1 -2 -1];
sobel_mask_v = sobel_mask_h.';
g_h = conv2(img,sobel_mask_h);
g_v = conv2(img,sobel_mask_v);
g = sqrt(g_h.^2 + g_v.^2);
out = uint8(g);
end

