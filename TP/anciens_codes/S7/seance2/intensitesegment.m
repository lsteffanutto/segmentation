clear, close all, clc;

A=imread('/../images/lena.bmp');

figure, surf(A(1:4:end,1:4:end)), cameratoolbar; %4 pour prendre moins de points pour pas que suf bug en rotation
[x,y]=ginput(2); %prend un point avec un click de souris
x=fix(x);
y=fix(y);
% x=[min(x) max(x)];
% y=[min(y) max(y)];
if abs(x(2)-x(1))<abs(y(2)-y(1)) %soit droite verticale soit droite horizontale
    x(2)=x(1);
else
    y(2)=y(1);
end
line(x,y)
sig=A(y(1):y(2),x(1):x(2)); %releve l'intensité des pixels le long de la droite et on plot 
figure,plot(sig);
