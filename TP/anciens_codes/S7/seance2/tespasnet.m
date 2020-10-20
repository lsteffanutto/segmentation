clear, close all, clc;

A=double(imread('zidane.jpg'))/255;
figure, imshow(A); %image normal
title('image A');
drawnow;

[h,w,d]=size(A);
H=ones(40)/1600;
A_floue(:,:,1) = conv2(A(:,:,1),H,'same'); %convolution de chacune des composantes RGB ('A_floue' convolué);
A_floue(:,:,2) = conv2(A(:,:,2),H,'same');
A_floue(:,:,3) = conv2(A(:,:,3),H,'same');
cx = 492;
cy = 190;
r = 140;
[X, Y] = meshgrid(1:w, 1:h);
mask = ones(h,w);
mask((X-cx).^2+(Y-cy).^2<r^2)=0;
figure, imshow(mask.*A + (1-mask).*A_floue);
title('somme des 2 images');
drawnow;

