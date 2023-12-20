%% Notes

% Gets the coordinates for the 3 regimes of significant deviation and
% exports them to a file for use with D_histogram.m and ArcGIS

% Ranges are as follows: 
% (1) All ref, 0.9 - 1 (2) 20 - 30 dB, 0 - 0.15, (3) -30 to -20 dB, 0.2 - 1

%% Regime 1 All ref, 0.9-1 

clear;clc;

data = importdata('data_combined_linterp2.txt');

reflectivity = data(:,4);
specularity = data(:,3);
ncar_taub = data(:,5);
coord_template = data(:,[1,2]);


%Creates intervals for ref & spec thresholds
spec_interval = linspace(0.9, 1, 50);
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
         
        mod_masked = ncar_taub(mask);
        
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

data_regime1 = data(mask_store,:);
coord = data_regime1(:,1:2);
mask1 = isnan(data_regime1(:,5));
coordnan = coord(mask1,:);

data_regime1 = data_regime1(~mask1,:);


coord_act = coord(~mask1, :);


scatter(coord_template(:,1), coord_template(:,2),1);
hold on
scatter(coord_act(:,1), coord_act(:,2))
hold on
%scatter(coordnan(:,1), coordnan(:,2))

writematrix(data_regime1, "data_r1_linterp2.txt")



%% Regime 2 20-30 dB, 0-0.15

clear;clc;

data = importdata('data_combined_linterp2.txt');

reflectivity = data(:,4);
specularity = data(:,3);
ncar_taub = data(:,5);
coord_template = data(:,[1,2]);


%Creates intervals for ref & spec thresholds
spec_interval = linspace(0, 0.15, 50);
ref_interval = linspace(20, 30, 50);

%Creates template for data from thresholding
template = zeros(51,51);
template([1:50],1) = flip(ref_interval);
template(51, [2:51]) = spec_interval;
numtot = 0;


for i = 1:50
    disp(i)
    for j = 1:50
        mask = specularity > template(51,i+1) & reflectivity > template(j,1);
         
        mod_masked = ncar_taub(mask);
        
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

data_regime2 = data(mask_store,:);
coord = data_regime2(:,1:2);
mask1 = isnan(data_regime2(:,5));
data_regime2 = data_regime2(~mask1,:);
coordnan = coord(mask1,:);


coord_act = coord(~mask1, :);



scatter(coord_template(:,1), coord_template(:,2),1);
hold on
scatter(coord_act(:,1), coord_act(:,2))
hold on
%scatter(coordnan(:,1), coordnan(:,2))

writematrix(data_regime2, "data_r2_linterp2.txt")




%% Regime 3 -30 to -20 dB, 0 - 1

clear;clc;

data = importdata('data_combined_linterp2.txt');

reflectivity = data(:,4);
specularity = data(:,3);
ncar_taub = data(:,5);
coord_template = data(:,[1,2]);


%Creates intervals for ref & spec thresholds
spec_interval = linspace(0, 1, 50);
ref_interval = linspace(-30, -20, 50);

%Creates template for data from thresholding
template = zeros(51,51);
template([1:50],1) = flip(ref_interval);
template(51, [2:51]) = spec_interval;
numtot = 0;


for i = 1:50
    disp(i)
    for j = 1:50
        mask = specularity < template(51,i+1) & reflectivity < template(j,1);
         
        mod_masked = ncar_taub(mask);
        
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

data_r3 = data(mask_store,:);
coord = data_r3(:,1:2);
mask1 = isnan(data_r3(:,5));
coordnan = coord(mask1,:);

data_r3 = data_r3(~mask1,:);
coord_act = coord(~mask1, :);


scatter(coord_template(:,1), coord_template(:,2),1);
hold on
scatter(coord_act(:,1), coord_act(:,2))
hold on
scatter(coordnan(:,1), coordnan(:,2))

writematrix(data_r3, "data_r3_linterp2.txt")
