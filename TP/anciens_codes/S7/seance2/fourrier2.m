clear all
close all
A=imread('trame.bmp');
figure, image(A), colormap(gray(256));
[h,w]=size(A);
B=log10(abs(fft2(A)));
fx=linspace(0,1-1/w,w);
fy=linspace(0,1-1/h,h); %tu vas de 0 à 1-1/h ( h points) et un pas de 1/h
figure, imagesc(fx,fy,B);
fx=linspace(-0.5,0.5-1/w,w); %w pair %comme tp son
fy=linspace(-0.5,0.5-1/h,h); %h pair
figure, imagesc(fx,fy,fftshift(B)); %bleu faible intensité, rouge forte intensité
%region homogene => coef frequence presque nulle donc presque de l'origine
%image objet frequences homogene separes par contour
%ici varie bcp horizontalement
%verticalement bof de variations