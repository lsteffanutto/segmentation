%TP TS225
%Steffanutto Lucas
%Zelmans Luca

clear all
close all
clc

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% 1ere partie %%%%%%%%%%%%%%%%%%
%%% Detection de contours (10 points) %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

img = imread('cameraman.png');

figure,imagesc(img)
title('Image initiale cameraman.png');


%% Gradient matlab

figure, surf(img((1:4:end),(1:4:end),1)),shading interp;

[dX ,dY] = gradient(double(img));
%% Norme du gradient
norme = sqrt(dX.^2+dY.^2);
figure,imagesc(uint8(norme));
title('gradient de  cameraman.png');

%% Seuillage
m = max(max(max(norme)));
seuil = 20;
norme_seuil = (norme >= seuil)*255;
figure,imagesc(uint8(norme_seuil));
title('norme seuil');


%% Sobel

H1=(1/2)*[1 0 -1];
H2=(1/4)*[1 2 1];
Sx=conv2(H1,H2');
Sy=conv2(H2,H1');

Hz=conv2(img(:,:,2),Sx,'same');
Vt=conv2(img(:,:,2),Sy,'same');
N=sqrt(Hz.^2+Vt.^2);

figure,imagesc(uint8(N)),colormap(gray(256));
title('Filtre de Sobel');


%% Bonus : Derivee de Gaussienne

%Comme vu en seance 2:

A=double(imread('cameraman.png'));
[X,Y]=meshgrid(-5:5);
sigma=0.75;
Hx=-X.*exp(-(X.^2+Y.^2)/(2*sigma^2))/(2*pi*sigma^4); %dérivée horizontale et verticale de la gaussienne
Hy=-Y.*exp(-(X.^2+Y.^2)/(2*sigma^2))/(2*pi*sigma^4);
Gx=conv2(A(:,:,1),Hx,'same'); %2fltres dérivateurs
Gy=conv2(A(:,:,1),Hy,'same');
G=(Gx.*Gx+Gy.*Gy).^0.5;
figure, imagesc(G, [0 50]), colormap(flipud(gray(256)));
title('Filtre dérivée Gaussienne');

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% 2eme partie %%%%%%%%%%%%%%%%%%
%%% Effet Pencil Sketch (4 points) %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

img1 = imread('home.jpg');

figure,imagesc(img1)
title('Image initiale cameraman.jpg');

%% Contour detection
% On choisit d'appliquer la technique de Sobel plus précise

Hz1=conv2(img1(:,:,2),Sx,'same');
Vt1=conv2(img1(:,:,2),Sy,'same');
Contours=sqrt(Hz1.^2+Vt1.^2);

figure,imagesc(uint8(Contours)),colormap(gray(256));
title('Filtre Sobel de home');

Contours_norm = Contours/max(max(Contours));

%% Effet pencil sketch en ycbcr

R=img1(:,:,1);
G=img1(:,:,2);
B=img1(:,:,3);

Y=0.299*R+0.587*G+0.114*B;
Cb=0.564*(B-Y)+128;
Cr=0.713*(R-Y)+128;

H(:,:,1)=Y;
H(:,:,2)=Cb;
H(:,:,3)=Cr;
figure, imagesc(uint8(H));
title('Home LumiChromi');
drawnow;

alpha = 252;
beta=184;

Y= (255-alpha)*(1-Contours)+beta;

%% Affichage espace RGB

R1  = uint8(Y) + (Cr-128)/0.713; 
B1  = uint8(Y) + (Cb -128)/0.564; 
G1  = (uint8(Y) - 0.299*Cr -0.114*Cb)/0.587;

im_finale = cat(3, R1, G1, B1);
figure, imagesc(uint8(im_finale));
title('Home RGB avec Lumi modifie');
drawnow;












