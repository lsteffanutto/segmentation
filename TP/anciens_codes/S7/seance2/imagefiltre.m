clear, close all, clc;

A=double(imread('monument.bmp'));
figure, imshow(uint8(A))
title('image monument de base');
drawnow;
[h, w]=size(A);
fx=linspace(-0.5, 0.5-1/w, w);
fy=linspace(-0.5, 0.5-1/h, h);
IfA=fftshift(log10(abs(fft2(A))));
figure, imagesc(fx, fy, IfA);
title('fft shift image monument de base');
drawnow;
H1=ones(3)/9;
H2=ones(5)/25;
[X, Y] = meshgrid(-5:5);
sigma=1.5;
H3=exp(-(X.^2+Y.^2)/(2*sigma^2))/(2*pi*sigma*sigma);
figure, freqz2(H1)
title('H1');
drawnow;
figure, freqz2(H2)
title('H2');
drawnow;
figure, freqz2(H3)
title('H3');
drawnow;

%% Filtrage
B=conv2(A,H1,'same');
figure, imshow(uint8(B));
title('convH1');
drawnow;
C=conv2(A,H2,'same');
figure, imshow(uint8(C));
title('convH2');
drawnow;
D=conv2(A,H3,'same');
figure, imshow(uint8(D));
title('convH3');
drawnow;

IfB=fftshift(log10(abs(fft2(B))));
figure,imagesc(fx,fy,IfB)
title('FFT H1');
drawnow;
IfC=fftshift(log10(abs(fft2(C))));
figure,imagesc(fx,fy,IfC)
title('FFT H2');
drawnow;
IfD=fftshift(log10(abs(fft2(D))));
figure,imagesc(fx,fy,IfD)
title('FFT H3');
drawnow;


%On a des filtres passe bas 
%TF gaussienne = gaussienne
%TF porte = sincard

