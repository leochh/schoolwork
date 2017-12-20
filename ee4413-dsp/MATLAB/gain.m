function [g,w,p] = gain(num,den)
w = 0:pi/255:pi;
h = freqz(num,den,w);
g = 20*log10(abs(h));
p = phase(h);