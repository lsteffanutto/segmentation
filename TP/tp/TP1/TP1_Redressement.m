clear all;close all; clc;

%% VAR

% Idist = double(imread('implant.bmp'))/255;
I = double(imread('implant.bmp'))/255;
[x,y]=size(I);
figure,imshow(I);

% C = [ 945.5 -507.7 ; -507.7 313.6];
vect_num_x=1:x;
vect_num_y=1:x;

