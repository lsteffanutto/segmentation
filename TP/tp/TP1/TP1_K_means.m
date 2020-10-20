clear all;close all; clc;

%% VAR

% Idist = double(imread('implant.bmp'))/255;
I = double(imread('implant.bmp'))/255;
[x,y]=size(I);
figure,imshow(I);
N = x*y; %nb pixels
nb_classes = 3;

%% Seuillage

classe=zeros(1,nb_classes);

for i = 1:nb_classes
    classe(1,i) = I(randi([0 N],1,1)); %chaque classe = rand(intensite pixel image)
end

old_barycentres = zeros(1,3);

for iteration = 1:30
    
I_classe(:,:) = zeros(x,y);
nb_pixel_classe = zeros(1,3);

sum_1=0;
sum_2=0;
sum_3=0;

for i = 1:y  
    for j = 1:x
        
        distances = zeros(1,3); %la comparer a intensite pixel
        for k = 1:3
            
            dist_label = sqrt( (I(i,j)-classe(k)).^2 ); %distance entre le pixel actuel et chaque classe
           
            distances(k) = dist_label;
            
        end
                
        [~,index] = min(distances); %index de la class avec dist_min pixel
        
        I_classe(i,j) = index; % qu'on associe au pixel
%         I_classe(i,j) = classe(index); % qu'on associe au pixel
        
        nb_pixel_classe(1,index) = nb_pixel_classe(1,index)+1;       
     end
end

%On montre l'image après une itération
% if iteration ==1
%     figure,imshow((I_classe));
%     title('Image 1 itération');
% end

for i = 1:y  
    for j = 1:x
        
        if I_classe(i,j)==1
            sum_1 = sum_1 + I(i,j);
        elseif I_classe(i,j)==2
            sum_2 = sum_2 + I(i,j);
        else I_classe(i,j)==3
            sum_3 = sum_3 + I(i,j);
        end
    end
end

new_barycentres = [ sum_1/nb_pixel_classe(1) sum_2/nb_pixel_classe(2) sum_3/nb_pixel_classe(3) ];

if new_barycentres == old_barycentres
    a=100
    break;
end
a=1;

old_barycentres = zeros(1,3);
old_barycentres = new_barycentres;

classe(1,:) = new_barycentres(1,:); % On a les nouvelles valeurs des labels
end

I_res(:,:) = zeros(x,y);

for i = 1:y  
    for j = 1:x
        
        if I_classe(i,j)==1
            I_res(i,j) = classe(1);
        elseif I_classe(i,j)==2
            I_res(i,j) = classe(2);
        else I_classe(i,j)==3
            I_res(i,j) = classe(3);
        end
    end
end

figure,imagesc(I_res);
title('Image finale');

%% Redressement
%JAUNE = IMPLANT = max(classe)


[implant ,classe_implant]=max(classe);

[x_implant,y_implant]=find(I_classe==classe_implant); %indice d'un pixel de l'image avec l'implant

x_bar=mean(x_implant)
y_bar=mean(y_implant)

% Cxx = sum(

% sum_x = 0;
% sum_y = 0;
% for i = 1:y  
%     for j = 1:x
%         if I_classe(i,j)==classe_implant 
%             sum_x = sum_x + j;
%         end
%     end
% end
% x_bar = sum_x/N;
% 
% for i = 1:y  
%     for j = 1:x
%         if I_classe(i,j)==classe_implant 
%             sum_y = sum_y + i;
%         end
%     end
% end
% y_bar = sum_y/N;
% 
% 
% C_xx = 0;
% for i = 1:y  
%     for j = 1:x
%         if I_classe(i,j)==classe_implant 
%             C_xx = (j - x_bar).^2;
%         end
%     end
% end
% C_xx = C_xx/N;
% 
% 
% C_yy = 0;
% for i = 1:y  
%     for j = 1:x
%         if I_classe(i,j)==classe_implant 
%             C_yy = (i - y_bar).^2;
%         end
%     end
% end
% C_yy = C_yy/N;
% 
% C_xy = 0;
% for i = 1:y  
%     for j = 1:x
%         if I_classe(i,j)==classe_implant 
%             C_yy = (i - y_bar)*(j - x_bar);
%         end
%     end
% end
% C_xy = C_xy/N;
% 
% C_yx = C_xy;
% 
% C  = [ C_xx C_yx ; C_xy C_yy ]



% [V,D] = eig(C);