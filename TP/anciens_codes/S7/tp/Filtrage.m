%Filtrage.m
%
%FILTRAGE
%
%centrale.tif et monument.bmp
%
%Travail sur la repr�sentation en fr�quence d'une image.
%Analyse d�une trame visible sur cette image puis de g�n�ration d'un filtre 
%lin�aire RIF coupe-bande adapt� et qui permette d'att�nuer cette trame une fois appliqu�.




%% Images

clear all
close all
clc

%Chargement des images
monument = imread('monument.bmp');   

%Il est n�cessaire de charger les images et d'�tudier leurs repr�sentations
%en fr�quence afin de pouvoir adapter le filtre correctement pour chaque
%image.

%Representations originales
figure, 
imshow(monument)
title('monument.bmp')


%Representations en fr�quence

%monument.bmp
[hm, lm] = size(monument);
fftmonument = fftshift(log10(abs(fft2(monument))));   
fxmonument = linspace(-0.5, 0.5 -1/lm, lm);
fymonument = linspace(-0.5, 0.5 -1/hm, hm);
figure, 
imagesc(fxmonument, fymonument, fftmonument)
title('Repr�sentation en fr�quence de monument.bmp')
xlabel('Fx');
ylabel('Fy');


%% Cr�ation du filtre
 % 1)- Filtre passe-bas :

%Fixation de la variance
sigma = 7;             

%Matrice du filtre r�duite aux valeurs probables de la gaussienne
[X, Y] = meshgrid(floor(-3*sigma):floor(3*sigma), floor(-3*sigma):floor(3*sigma)); 

%Fonction gaussienne 2D
g1 = (1/(2*pi*sigma^2)*exp((-X.^2-Y.^2)/(2*sigma^2))); 
g1 = g1/(sum(sum(g1)));


%% Repr�sentation du filtre passe-bas :

figure, 
surf(X, Y, g1)
title('Filtre passe-bas')
xlabel('X');
ylabel('Y');
zlabel('g1(X,Y)');

figure, 
freqz2(g1, hm, lm);
xlabel('fX');
ylabel('fY');
zlabel('G1(fX,fY)');
title('Repr�sentation en fr�quence du filtre passe-bas')



%% 2)- Filtre passe-bande :

fx = -0.1;    %Donn�es visibles sur la repr�sentation en fr�quence de monument.bmp et de centrale.tif
fy = 0.4;     %Correspondent � l'emplacement du bruit
g2 = 2*g1.*cos(2*pi*fx*X+2*pi*fy*Y); %Transposition avec un cosinus

figure, 
surf(X, Y, g2)
title('Filtre passe-bande')
xlabel('X');
ylabel('Y');
zlabel('g2(X,Y)');

figure, 
freqz2(g2, hm, lm);
xlabel('fX');
ylabel('fY');
zlabel('G2(fX,fY)');
title('Repr�sentation en fr�quence du filtre passe-bande')




%% 3)- Filtre coupe-bande :

Dirac = zeros(size(g2));
Dirac(floor(size(g2)/2)+1, floor(size(g2)/2)+1) = 1;  %dirac(X,Y)

max_g2 = max(abs(fft2(g2(:))));

g3 =  Dirac - g2;  %Filtre coupe-bande correspondant

figure, 
surf(X, Y, g3)
title('Filtre coupe-bande')
xlabel('X');
ylabel('Y');
zlabel('g2(X,Y)');

figure, 
freqz2(g3, hm, lm);
xlabel('fX');
ylabel('fY');
zlabel('G3(fX,fY)');
title('Repr�sentation en fr�quence du filtre coupe-bande')





%% Application du filtre

%Sur monument.bmp
monument_2 = conv2(double(monument),g3, 'same');

figure, 
imagesc(fx, fy, fftshift(log10(abs(fft2(monument_2)))))
title('Monument.bmp en fr�quence apr�s filtrage')
figure, 
imshow(uint8(monument_2))
title('Monument.bmp apr�s filtrage')

