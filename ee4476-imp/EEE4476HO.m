a=1;
a
whos
a=[1 2 3 1]
a(2)
a(1)
a=1;
a
whos
a=[1 2 3 1]
a(2)
f=[1 1 1; 1 2 1; 1 1 1]
h=[0 1 2; 0 3 4]
help conv
help conv2
g=conv2(f,h)
ls image.*
f=imread('Image.tiff');
imshow(f)
impixelinfo;
help imshow
help imread
whos
imhist(f)
figure
imshow(f)
fEq=histeq(f);
whos
figure
imshow(fEq)
figure;
imhist(fEq)
f1=f/2;
f0=f;
whos
f=double(f);
whos
f=f/2;
figure(1)
figure(3)
imshow(f)
imshow(uint8(f))
f=uint8(f)
f=uint8(f);
imshow(f)
figure
imhist(f)
close all
whos
f=f0;
imshow(f)
F=fft2(f);
whos
figure
imshow(abs(F),[])
S=log(1+abs(F));
imshow(S,[])
S=log(1+abs(fftshift(F)));
imshow(S,[])
h=ones(5,5)
h=h/25;
h=h/25
h=ones(5,5)
h=h/25
g=filter2(h,f);
figure
imshow(g)
imshow(uint8(g))
d=abs(double(f)-double(g));
figure
imshow(uint8(d))
imshow(uint8(d),[])
imshow(uint8(d),[0 100])
imshow(uint8(d),[0 50])
imshow(uint8(d),[0 20])
whos
mesh(d)
mesh(f)
mesh(double(f))
clear all
whos
f=imread('Image2.jpg');
close all
imshow(f)
impixelinfo;
whos
f0=f;
f=f(:,:,2);
whos
figure
imshow(f)
F=fft2(f);
S=log(1+abs(double(fftshift(F))));
figure
imshow(S,[])
imdistline
L=lpfilter('ideal',256,256,30);
figure
imshow(L)
imshow(fftshift(L))
FL=F.*L;
SL=log(1+abs(double(fftshift(FL))));
imshow(SL,[])
fL=ifft2(FL);
figure
imshow(uint8(fL));
L=lpfilter('gaussian',256,256,15);
FL=F.*L;
fL=ifft2(FL);
figure
imshow(uint8(fL));


f=imread('zoonplate.bmp');
imshow(f)
f=double(f);
imshow(f)
F=fft2(f);
S=log(1+abs(fftshift(F(:,:,2))));
imshow(S,[])
f=f(:,:,2);
L=lpfilter('gaussian',1024,1024,15);
F=fft2(f);
FL=F.*L;
fL=ifft2(FL);
figure
imshow(uint8(fL));
L=lpfilter('gaussian',1024,1024,100);
F=fft2(f);
FL=F.*L;
fL=ifft2(FL);
imshow(uint8(fL));