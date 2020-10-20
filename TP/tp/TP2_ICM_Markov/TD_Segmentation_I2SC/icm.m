function EtiqResult=icm(Im, EtiqInit, NbClasses, Mu, Sigma, Beta)
% Exécute une segmentation par champ de markov de l'image Im,
% en NbClasses classes dont les moyennes et les écart-types de niveaux de gris
% sont donnés par les tableaux Mu et Sigma
% EtiqInit, passée en paramètre, est l'image des étiquettes d'initialisation
% L'image des étiquettes en cours de modifications est Etiq
% L'image des étiquettes à renvoyer est EtiqResult

% L'algorithme utilisé est l'algorithme ICM (Iterated Conditional Modes),
% avec hypothèse de normalité (chaque classe suit une distribution  normale)

% L'énergie locale associée au site s sera notée Es. Elle sera composée de :
%		Es_rap : énergie de rappel aux données
%		Es_reg : énergie de régularisation
% La première porte sur la connaissance a priori des distributions des classes supposées gaussiennes
% La seconde permet de régulariser les régions. Elle s'appuiera sur un potentiel autologistique (de valeur +/- Beta)


Im=double(Im);
[Nb_lignes,Nb_colonnes]=size(Im);
Etiq=EtiqInit;

% Début du processus itératif
l=0;
fin=0;
etiq_4_voisins=zeros(1,4);
E_par_etiquette_test = zeros(1,3);

while fin==0
    % Nombre de modifications sur un balayage complet
    nb_modifs=0;
    % Parcours de l'image (les bords ne seront pas pris en compte dans un premier temps)
    for i=2:Nb_lignes-1
        for j=2:Nb_colonnes-1
            
            pixel_level = Im(i,j);    %niveau de gris du pixel (i,j)
            pixel_etiq = Etiq(i,j); %etiquette du pixel (i,j)
            etiq_4_voisins = [Etiq(i-1,j) Etiq(i+1,j) Etiq(i,j+1) Etiq(i,j-1)];
            
            gauss_niv_gris = ( 1/ (Sigma(1,pixel_etiq))*sqrt(2*pi) ) * exp(- (pixel_level-Mu(1,pixel_etiq)^2)); %Formule cours p(as|lambda_s)
            Es_rap = -log(gauss_niv_gris);  %E rap donnee
            
            meme_etiq = (pixel_etiq==etiq_4_voisins)*2-1; %1 si meme etiq et -1 sinon
            meme_etiq = meme_etiq*-Beta;
            Es_reg = sum(meme_etiq); %on fait la somme des B
            
            Es = Es_rap + Es_reg;% Energie de base du pixel étudié
            
            for k =1:NbClasses %on calcul l'energie pour chaque classe test
                
                gauss_niv_gris = (1/ (Sigma(1,k))*sqrt(2*pi)) * exp(- (pixel_level-Mu(1,k)^2)/(2*Sigma(1,k).^2)); %Formule cours p(as|lambda_s)
                Es_rap = -log(gauss_niv_gris);  %E rap donnee pour etiquette k test
                
                meme_etiq = (k==etiq_4_voisins)*2-1; %1 si meme etiq et -1 sinon
                meme_etiq = meme_etiq*-Beta;
                Es_reg = sum(meme_etiq); %on fait la somme des B 
                
                E_par_etiquette_test(1,k)=Es_rap+Es_reg;
                
            end
            
            %on garde la meilleure etiquette
            [E_min classe_choice] = min(E_par_etiquette_test);
            
            %Et on affecte la classe au pixel en augmentant nb_de_modif 
            %si on doit changer sa classe
            
            if pixel_etiq ~= classe_choice
                nb_modifs = nb_modifs+1;
                Etiq(i,j)=classe_choice;
            end
            
            
            
            % Calcul de l'énergie locale Es pour toutes les étiquettes lambda possibles
                        % A compléter...

                        % Recherche de la meilleure étiquette
                        % A compléter...

                        % Affectation de la meilleure étiquette
                        % A compléter...
            
        end
    end
%     nb_modifs
    l=l+1;
    
    figure,
    imagesc(Etiq-1);
    title('Segmentation ICM 1ere iteration');

    if (nb_modifs==0)
        fin=1; % On met fin à la boucle s'il n'y a plus de changement.
    end
    fprintf('Iteration : %6d      -      Nb de modifications : %6d\n',l,nb_modifs);
    
    
    

    
end
EtiqResult=Etiq-1;




