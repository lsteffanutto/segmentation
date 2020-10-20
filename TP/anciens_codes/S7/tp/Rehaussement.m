clear;
close all;
clc;

%% Parametre a
a=4;

%% Importation d'images
addpath('images');
Img=double(imread('visage.bmp'));
figure, imshow(uint8(Img))

%% Masque
L=ones(3,3);
L(2,2)=-8;

%% Masque applique
alpha=0.5;
I=conv2(Img,L,'same');
figure, imshow(uint8(I))
Img=Img-alpha*I;
figure, imshow(uint8(Img))

%% Importation d'images
addpath('images');
Img2=double(imread('lena.bmp'));
figure, imshow(uint8(Img2))

%% Filtre passe-bas
F=(1/9)*ones(3,3);

%% Floutage
G=conv2(Img2(:,:,1),F,'same');
figure, imshow(uint8(G))

%% Defloutage
I=conv2(G,L,'same');
figure, imshow(uint8(I))
G=G-alpha*I;
figure, imshow(uint8(G))