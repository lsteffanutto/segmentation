clear, close all, clc;

A=double(imread('cameraman.tif'));
figure, imshow(uint8(A))
[X,Y]=meshgrid(-5:5);
sigma=0.75;
Hx=-X.*exp(-(X.^2+Y.^2)/(2*sigma^2))/(2*pi*sigma^4); %dérivée horizontale et verticale de la gaussienne
Hy=-Y.*exp(-(X.^2+Y.^2)/(2*sigma^2))/(2*pi*sigma^4);
Gx=conv2(A,Hx,'same'); %2fltres dérivateurs
Gy=conv2(A,Hy,'same');
G=(Gx.*Gx+Gy.*Gy).^0.5;
figure, imshow(G, [0 50]), colormap(flipud(gray(256))); %flipud = flip de matrice dans la verticale