clear;
close all;
clc;

%% Importation d'images
addpath('images');
Img=double(imread('zidane.jpg'));
figure, imshow(uint8(Img))

%% Masques
H1=(1/2)*[1 0 -1];
H2=(1/4)*[1 2 1];
Sx=conv2(H1,H2');
Sy=conv2(H2,H1');

%% Detection horizantale
Hz=conv2(Img(:,:,1),Sx,'same');
figure, imshow(uint8(Hz))

%% Detection Verticale
Vt=conv2(Img(:,:,1),Sy,'same');
figure, imshow(uint8(Vt))

%% Norme et affichage des contours
N=sqrt(Hz.^2+Vt.^2);
figure, imshow(uint8(N))