clear all; close all;clc;

I = double(imread('materiau.bmp'))/255;
[x,y]=size(I);
% figure,imshow(I);
N = x*y; %nb pixels

%% Etude caracteristique, seuillage histogramme
% imhist(I)
% title('Histogramme des niveaux de gris');

nb_classes = 3;
thresholds = [ 0.25 0.67 ];

X = grayslice(I,thresholds);

figure,
imagesc(X); %Q'uand on a 0, 1 et 2
colorbar
title('Seuillage histogramme');

%% 3 Segmentation Markovienne

% Etot; %Energie totale à minimiser (en minimisant E_local)
% En1=0;  %Energie rappel aux donnes
% En2=0;  %Energie de regularisation

I_classe_init_bien = double(X);         %Init image bien avec classes seuillage histo precedent
I_classe_init_mal = randi([0,2],x,y);   %Init image avec classes aleatoire
% imagesc(I_classe_init_mal)
I_classe_bien_bruite=round(0.5*(I_classe_init_bien+I_classe_init_mal));

I_input = I_classe_init_bien;

figure,
imagesc(I_input)
title('Input ICM');


%Algo ICM
Mu = [10 130 190];
Sigma = [15 15 15];
Beta=1;
EtiqResult=icm(I, I_input+1, nb_classes, Mu, Sigma, 100);
figure,
imagesc(EtiqResult);
title('Segmentation ICM');
