%% Notes

% Gets the coordinates for the 3 regimes of significant deviation and
% exports them to a file (for ArcGIS)

% Ranges are as follows: 
% (1) All ref, 0.85 - 1 (2) 20 - 35 dB, 0 - 0.1, (3) -25 to -20 dB, 0.2 - 1

%% Regime 1 All ref, 0.85-1 

clear;clc;

clear;clc;

data_specularity = importdata('Processed Data/Interpolated/Thwaites_specularity_ontoref_v2.txt');
data_reflectivity = importdata('Processed Data/Interpolated/Thwaites_Radar_v3.txt');

data_serg_taub = importdata("Processed Data/Interpolated/Thwaites_sh_ontoref_v3.txt");

reflectivity = data_reflectivity(:,9);
specularity = data_specularity(:,3);
serg_taub = data_serg_taub(:,3);
coord_template = data_serg_taub(:,[1,2]);


%Creates intervals for ref & spec thresholds
spec_interval = linspace(0.85, 1, 50);
ref_interval = linspace(-30, 35, 50);

%Creates template for data from thresholding
template = zeros(51,51);
template([1:50],1) = flip(ref_interval);
template(51, [2:51]) = spec_interval;
numtot = 0;


for i = 1:50
    disp(i)
    for j = 1:50
        mask = specularity > template(51,i+1) & reflectivity > template(j,1);
         
        mod_masked = serg_taub(mask);
        
        if sum(~isnan(mod_masked)) >= 100 && sum(~isnan(mod_masked)) <= 103223*0.7
            %mod_masked = mod_masked(~isnan(mod_masked));
            numtot_tmp = sum(~isnan(mod_masked));
            if numtot_tmp > numtot
                disp([template(51,i+1),template(j,1)])
                numtot = numtot_tmp;
                mask_store = mask;
            end
        end
    end
end

coord = data_serg_taub(mask_store,:);
mask1 = isnan(coord(:,3));
coord = coord(~mask1,:);
coordnan = coord(mask1,:);

scatter(coord_template(:,1), coord_template(:,2),7, specularity);
hold on
scatter(coord(:,1), coord(:,2))

% scatter(coordnan(:,1), coordnan(:,2))

%% Regime 2 20-35 dB, 0-0.1

clear;clc;
clear;clc;

data_specularity = importdata('Processed Data/Interpolated/Thwaites_specularity_ontoref_v2.txt');
data_reflectivity = importdata('Processed Data/Interpolated/Thwaites_Radar_v3.txt');

data_serg_taub = importdata("Processed Data/Interpolated/Thwaites_sergienko_ontoref_v3.txt");

reflectivity = data_reflectivity(:,9);
specularity = data_specularity(:,3);
serg_taub = data_serg_taub(:,3);
coord_template = data_serg_taub(:,[1,2]);


%Creates intervals for ref & spec thresholds
spec_interval = linspace(0, 0.1, 50);
ref_interval = linspace(20, 35, 50);

%Creates template for data from thresholding
template = zeros(51,51);
template([1:50],1) = flip(ref_interval);
template(51, [2:51]) = spec_interval;
numtot = 0;


for i = 1:50
    disp(i)
    for j = 1:50
        mask = specularity > template(51,i+1) & reflectivity > template(j,1);
         
        mod_masked = serg_taub(mask);
        
        if sum(~isnan(mod_masked)) >= 100 && sum(~isnan(mod_masked)) <= 103223*0.7
%             mod_masked = mod_masked(~isnan(mod_masked));
            numtot_tmp = sum(~isnan(mod_masked));
            if numtot_tmp > numtot
                disp([template(51,i+1),template(j,1)])
                numtot = numtot_tmp;
                mask_store = mask;
            end
        end
    end
end

coord = data_serg_taub(mask_store,:);
mask1 = isnan(coord(:,3));
% coordnan = coord(mask1,:);
coord = coord(~mask1,:);


scatter(coord_template(:,1), coord_template(:,2),1);
hold on
scatter(coord(:,1), coord(:,2))
hold on
% scatter(coordnan(:,1), coordnan(:,2))

%% Regime 3 -25 to -20 dB, 0.2 - 1

clear;clc;
clear;clc;

data_specularity = importdata('Processed Data/Interpolated/Thwaites_specularity_ontoref_v2.txt');
data_reflectivity = importdata('Processed Data/Interpolated/Thwaites_Radar_v3.txt');

data_serg_taub = importdata("Processed Data/Interpolated/Thwaites_sergienko_ontoref_v3.txt");

reflectivity = data_reflectivity(:,9);
specularity = data_specularity(:,3);
serg_taub = data_serg_taub(:,3);
coord_template = data_serg_taub(:,[1,2]);


%Creates intervals for ref & spec thresholds
spec_interval = linspace(0.2, 1, 50);
ref_interval = linspace(-25, -20, 50);

%Creates template for data from thresholding
template = zeros(51,51);
template([1:50],1) = flip(ref_interval);
template(51, [2:51]) = spec_interval;
numtot = 0;


for i = 1:50
    disp(i)
    for j = 1:50
        mask = specularity < template(51,i+1) & reflectivity < template(j,1);
         
        mod_masked = serg_taub(mask);
        
        if sum(~isnan(mod_masked)) >= 100 && sum(~isnan(mod_masked)) <= 103223*0.7
            %mod_masked = mod_masked(~isnan(mod_masked));
            numtot_tmp = sum(~isnan(mod_masked));
            if numtot_tmp > numtot
                disp([template(51,i+1),template(j,1)])
                numtot = numtot_tmp;
                dat_test = mod_masked;
                mask_store = mask;
            end
        end
    end
end

coord = data_serg_taub(mask_store,:);
mask1 = isnan(coord(:,3));
coord = coord(~mask1,:);
%coordnan = coord(mask1,:);

scatter(coord_template(:,1), coord_template(:,2),1);
hold on
scatter(coord(:,1), coord(:,2))
% hold on
% scatter(coordnan(:,1), coordnan(:,2))





