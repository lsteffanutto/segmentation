clear, close all, clc

% 1) LUMINANCE CHROMINANCE
% La repreesentation en couleurs YCbCr permet de mieux mettre en evidence 
% la présence de bleu ou de rouge dans une image.
% Pour l'image en Cr par exemple, les parties de
% l'image retournée qui se rapproche le plus du blanc sont celles qui contiennent le plus de rouge
% Dans l'image de base
% 
% La luminance correspond contraste de l'image (qui reste le m$ême en noir
% et blanc)

% A=double(imread('pool.tif'));
% R=A(:,:,1);
% G=A(:,:,2);
% B=A(:,:,3);
% 
% Y=0.299*R+0.587*G+0.114*B;
% Cb=0.564*(B-Y)+128;
% Cr=0.713*(R-Y)+128;
% 
% 
% figure, imshow(uint8(A));
% title('image billard de base');
% drawnow;
% 
% figure, imshow(uint8(R));
% title('composante rouge');
% drawnow;
% 
% figure ,imshow(uint8(G));
% title('composante verte');
% drawnow;
% 
% figure ,imshow(uint8(B));
% title('composante bleu');
% drawnow;
% 
% figure ,imshow(uint8(Y));
% title('luminance');
% drawnow;
% 
% figure ,imshow(uint8(Cb));
% title('chrominance bleue');
% drawnow;
% 
% figure ,imshow(uint8(Cr));
% title('chrominance rouge');
% drawnow;

%% 2) FUSION

%  B=double(imread('background.jpg'));
% figure, imshow(uint8(B)); %image normal
% title('image background');
% drawnow;
% 
%  C=double(imread('foreground.jpg'));
% figure, imshow(uint8(C)); %image normal
% title('image foreground');
% drawnow;
% 
% R1=C(:,:,1);
% G1=C(:,:,2);
% B1=C(:,:,3);
% %RGB b1<140; %Défini un seuil à 145, si c'est bleu le seuil sera dépassé et on prend le background, sinon on prend le foreground
% 
% D=B;
% 
% for i = 1:512
%     
%     for j = 1:768
%         
%         if M(i,j) == 0
%             D(i,j,:)=B(i,j,:);
%             
%         else
%             D(i,j,:)=C(i,j,:); 
%         end
%         
%     end
%     
% end
% 
% figure ,imshow(uint8(D));
% title('fusion 2 images');
% drawnow;TO LUMINANCE CHROMINANCE
% Y1=0.299*R1+0.587*G1+0.114*B1;
% Cb1=0.564*(B1-Y1)+128; %on remarque un seuil à 0,57 qui représente le bleu du ciel à enlever
% Cr1=0.713*(R1-Y1)+128;
% 
% figure ,imshow(uint8(Cb1));
% title('chrominance bleue foreground');
% drawnow;
% 
% M = Cb1<140; %Défini un seuil à 145, si c'est bleu le seuil sera dépassé et on prend le background, sinon on prend le foreground
% 
% D=B;
% 
% for i = 1:512
%     
%     for j = 1:768
%         
%         if M(i,j) == 0
%             D(i,j,:)=B(i,j,:);
%             
%         else
%             D(i,j,:)=C(i,j,:); 
%         end
%         
%     end
%     
% end
% 
% figure ,imshow(uint8(D));
% title('fusion 2 images');
% drawnow;

%% 3) FILTRAGE

Monument=double(imread('monument.bmp'));
figure, imshow(uint8(Monument))
title('image monument de base');

[h, w]=size(Monument);
fx=linspace(-0.5, 0.5-1/w, w);
fy=linspace(-0.5, 0.5-1/h, h);
IfA=fftshift(log10(abs(fft2(Monument))));
figure, imagesc(fx, fy, IfA);
title('fft shift image monument de base');
sigma=7;
[X, Y] = meshgrid(floor(-3*sigma):floor(3*sigma), floor(-3*sigma):floor(3*sigma)); 
fech = 1/(2*pi*sigma*sigma);
f=-0.5:1/h:0.5-1/h;

% haute frequence = contour
% basse frequence = information spatiale homogene/ qui se répète

H=exp(-(X.^2+Y.^2)/(2*sigma^2))/(2*pi*sigma*sigma); %filtre passe bas 
H = H /sum(sum(H)); %qu'on normalise
figure, freqz2(H) 
title('Filtre Gaussienne');

%On veut choisir la fréquence à supprimer, qu'on repère grâce IfA et à fft2
X0 = -0.1;
Y0 = 0.4;
%qu'on incorpore dans le filtre avant d'inverser les gaussiennes
H1 = 2*cos(2*pi*(Y0*Y+X0*X)).*H;
%*cos(2*pi*fx*X+2*pi*fy*Y)
%H1 = H.*(sin(2*pi*(Y0*Y))*sin(2*pi*(X0*X)));
%H1 = H.*sin(2*pi*(Y0*Y+X0*X));

figure, freqz2(H1)
title('Passe Bande');
drawnow;

dirac = zeros(size(H));
milieu=floor(size(H1)/2)+1
dirac(milieu,milieu)=1;
figure, surf(dirac), shading interp;

H2 =dirac - H1;
figure, freqz2(H2);
title('Filtre à appliquer');
drawnow;

%On filtre ensuite l'image
Imagefiltre = conv2(Monument,H2,'same');

%Affichage
figure, imshow(uint8(Imagefiltre));
title('monument filtré');
drawnow;

IfA=fftshift(log10(abs(fft2(Monument))));
figure, imagesc(fx, fy, IfA);
title('fft shift image monument filtré');
drawnow;

%% Formes dérivatives
% 1) Rehaussement de contours
% filtrage => domaine spatiale convolution

% A=double(imread('batiment.bmp'));
% figure, imshow(uint8(A));
% title('batiment de base');
% drawnow;
% L = ones(3);
% L(2,2)=-8;
% 
% alpha=1;
% 
% B =conv2(A,L,'same'); %same garde les mêmes dim pour une convolution
% figure, imshow(uint8(B));2) FUSION
% title('batiment convolué au masque');
% drawnow;
% 
% C = A - alpha * B;
% figure, imshow(uint8(C));
% title('batiment de base - batiment convolué au masque');
% drawnow;
% 
% L1 = [0 1 0 ; 1 -4 1 ; 0 1 0];
% L2 = [1 0 1 ; 0 -4 0 ; 1 0 1];
% 
% Lbis = L1 + L2; %mise en évidence de la linéarité ?
% 
% 
% D = double(imread('bdx.jpg'))/255;
% figure, imshow(D);
% title('BDX');
% 
% [h,w,d]=size(D);
% 
% H=ones(40)/1600;
% D_floue(:,:,1) = conv2(D(:,:,1),H,'same'); %convolution de chacune des composantes RGB ('A_floue' convolué);
% D_floue(:,:,2) = conv2(D(:,:,2),H,'same');
% D_floue(:,:,3) = conv2(D(:,:,3),H,'same');
% 
% [X, Y] = meshgrid(1:w, 1:h);
% mask = zeros(h,w);
% BDXfloue = mask.*D + (1-mask).*D_floue;
% 
% figure, imshow(BDXfloue);
% title('BDX floue');
% 
% E =conv2(BDXfloue,L,'same');
% figure, imshow(uint8(E));
% title('BDX convolué au masque');
% drawnow;
% 
% F = BDXfloue - alpha * E;
% figure, imshow(uint8(F));
% title('BDX de base - BDX convolué au masque');
% drawnow;








