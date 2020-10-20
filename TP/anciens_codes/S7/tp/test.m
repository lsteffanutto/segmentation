clear all;
close all;
clc;

%% PART 1
A = double(imread('cameraman.png'));
figure, imshow(uint8(A));
title('image de base');
drawnow;

figure, surf(A(1:4:end,1:4:end,1)), colorbar, shading interp
title('Gradient 3D');
drawnow;

B = gradient(A); %Sur une image = Variabilité de l'intensité ou de la couleur au voisinage d'un point
figure, imshow(uint8(B)); % ça détecte les variations de l'image en X et en Y
title('Gradient de image');
drawnow;

%Ma méthode de gitan %que en X miskine
C = abs(B).^2;
figure, imshow(uint8(C)); % ça détecte les variations de l'image en X et en Y
title('Norme du gradient gitan');
drawnow;

%méthode propre
[dX ,dY] = gradient(A);
D = (dX.^2+dY.^2).^0.5;
figure, imshow(uint8(D));
title('Norme du gradient propre');
drawnow;

%méthode gaussienne 2D (LE TURFU)

E=double(imread('cameraman.png'));
[X,Y]=meshgrid(-5:5);
sigma=0.75;
Hx=-X.*exp(-(X.^2+Y.^2)/(2*sigma^2))/(2*pi*sigma^4); %dérivée horizontale et verticale de la gaussienne
Hy=-Y.*exp(-(X.^2+Y.^2)/(2*sigma^2))/(2*pi*sigma^4);
Gx=conv2(E(:,:,1),Hx,'same'); %2fltres dérivateurs
Gy=conv2(E(:,:,1),Hy,'same');
G=(Gx.*Gx+Gy.*Gy).^0.5;
figure, imshow(G, [0 50]);% colormap(flipud(gray(256)));
title('Methode dGaussienne 2D');
drawnow;

%Sobel
H1=(1/2)*[1 0 -1];
H2=(1/4)*[1 2 1];
Sx=conv2(H1,H2');
Sy=conv2(H2,H1');

%Detection horizetale
Hz=conv2(E(:,:,1),Sx,'same');


%Detection Verticale
Vt=conv2(E(:,:,1),Sy,'same');


%Norme et affichage des contours
N=sqrt(Hz.^2+Vt.^2);
figure, imshow(uint8(N));
title('Methode Sobel');
drawnow;

%% PART 2

% H=double(imread('home.jpg'));
% figure, imshow(uint8(H));
% title('home base');
% drawnow;
% 
% %détection avec la méthode du gradient
% [dHx dHy] = gradient(H);
% I = (dHx.^2+dHy.^2).^0.5;
% figure, imshow(uint8(I));
% title('Norme du gradient home');
% drawnow;
% 
% %luminance chrominance
% R=H(:,:,1);
% G=H(:,:,2);
% B=H(:,:,3);
% 
% Y=0.299*R+0.587*G+0.114*B;
% Cb=0.564*(B-Y)+128;
% Cr=0.713*(R-Y)+128;
% 
% H(:,:,1)=Y;
% H(:,:,2)=Cb;
% H(:,:,3)=Cr;
% figure, imshow(uint8(H));
% title('Home LumiChromi');
% drawnow;
% 
% % On chope les contour puis on applique la formule
% alpha =128;
% beta=2;
% Contours=I>8;
% figure ,imshow(uint8(Contours(:,:,1)));
% title('On garde les contours');
% drawnow;
% Y=255-alpha*I(:,:,1)+beta;
% J(:,:,1)=Y;
% J(:,:,2)=Cb;
% J(:,:,3)=Cr;
% % Y ← (255 − α) ∗ C + β
% figure, imshow(uint8(J));
% title('Chromi Lumi new Y');
% drawnow;
% 
% % On repasse en RGB avec le nouveau Y
% R1  = Y + (Cr-128)/0.713; 
% B1  = Y + (Cb -128)/0.564; 
% G1  = (Y - 0.299*R -0.114*B)/0.587;
% 
% K(:,:,1)=R1;
% K(:,:,2)=B1;
% K(:,:,3)=G1;
% 
% figure, imshow(uint8(K) );
% title('RGB from new Y');
% drawnow;