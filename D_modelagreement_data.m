%% Notes
%
%Generates a struct file that saves the High-High and Low-Low matrices of 
% absolute deviation in mean basal shear stress for all 9 inversions and 
% saves the struct file as a .mat file. This .mat file can be passed into 
% the plotting code for model agreement which plots regions where 7 or more
% models agree on the sign of the deviation in mean basal shear stress, and
% plots the inter-model mean deviation as the colormap.

%% Code

clear;clc;

% Input filepath for inversion dataset files that have been interpolated
% onto radar flight tracks
st.hh.serg = pcolorgenhh("sergienko_linterp2.txt");
st.hh.awipism1 = pcolorgenhh("awi_pism1_linterp2.txt");
st.hh.doemali = pcolorgenhh("doe_mali_linterp2.txt");
st.hh.jpl1issm = pcolorgenhh("jpl1_issm_linterp2.txt");
st.hh.ncarcism = pcolorgenhh("ncar_cism_linterp2.txt");
st.hh.pikpism1 = pcolorgenhh("pik_pism1_linterp2.txt");
st.hh.ucijpl = pcolorgenhh("ucijpl_issm_linterp2.txt");
st.hh.utaselmer = pcolorgenhh("utas_elmer_linterp2.txt");
st.hh.vubaismpaleo = pcolorgenhh("vub_aismpaleo_linterp2.txt");

st.ll.serg = pcolorgenll("sergienko_linterp2.txt");
st.ll.awipism1 = pcolorgenll("awi_pism1_linterp2.txt");
st.ll.doemali = pcolorgenll("doe_mali_linterp2.txt");
st.ll.jpl1issm = pcolorgenll("jpl1_issm_linterp2.txt");
st.ll.ncarcism = pcolorgenll("ncar_cism_linterp2.txt");
st.ll.pikpism1 = pcolorgenll("pik_pism1_linterp2.txt");
st.ll.ucijpl = pcolorgenll("ucijpl_issm_linterp2.txt");
st.ll.utaselmer = pcolorgenll("utas_elmerice_linterp2.txt");
st.ll.vubaismpaleo = pcolorgenll("vub_aismpaleo_linterp2.txt");

save('pcolor_all.mat', 'st')

%% Function
function pcolor_arr = pcolorgenhh(filepath)
    %% Load Data 

    data_specularity = importdata('Thwaites_specularity_v3.txt');
    data_reflectivity = importdata('Thwaites_radar_reflectivity_v3.txt');

    data_taub = importdata(filepath);

    reflectivity = data_reflectivity(:,9);
    specularity = data_specularity(:,3);
    taub = data_taub(:,3);


    %% Data Preparation
    %Creates intervals for ref & spec thresholds
    spec_interval = linspace(min(specularity), max(specularity), 50);
    ref_interval = linspace(min(reflectivity), max(reflectivity), 50);

    %Creates template for data from thresholding
    template = zeros(51,51);
    template([1:50],1) = flip(ref_interval);
    template(51, [2:51]) = spec_interval;

    mean_m = template;


    %% Iteration

    for i = 1:50
        disp(i)
        for j = 1:50
            %sets mask for specularity & reflectivity
            mask = specularity > template(51,i+1) & reflectivity > template(j,1);

            %masks taub with above mask
            mod_masked = taub(mask);
            %numtot(j,i+1) = numel(mod_masked)/103223;
            


            %must have minimum 100 elements & be less than 70% of all data
            %(i.e. thresholding)
            if sum(~isnan(mod_masked)) >= 100 && sum(~isnan(mod_masked)) <= 103223*0.7
                mod_masked = mod_masked(~isnan(mod_masked));
                mean_m(j,i+1) = (mean(mod_masked, 'omitnan') - mean(taub, 'omitnan'));
            else 
                mean_m(j,i+1) = NaN;
            end
        end  
    end

    pcolor_arr = mean_m;
end

function pcolor_arr = pcolorgenll(filepath)
    %% Load Data 

    data_specularity = importdata('Thwaites_specularity_v3.txt');
    data_reflectivity = importdata('Thwaites_radar_reflectivity_v3.txt');

    data_taub = importdata(filepath);

    reflectivity = data_reflectivity(:,9);
    specularity = data_specularity(:,3);
    taub = data_taub(:,3);


    %% Data Preparation
    %Creates intervals for ref & spec thresholds
    spec_interval = linspace(min(specularity), max(specularity), 50);
    ref_interval = linspace(min(reflectivity), max(reflectivity), 50);

    %Creates template for data from thresholding
    template = zeros(51,51);
    template([1:50],1) = flip(ref_interval);
    template(51, [2:51]) = spec_interval;

    mean_m = template;


    %% Iteration

    for i = 1:50
        disp(i)
        for j = 1:50
            %sets mask for specularity & reflectivity
            mask = specularity < template(51,i+1) & reflectivity < template(j,1);

            %masks taub with above mask
            mod_masked = taub(mask);
            %numtot(j,i+1) = numel(mod_masked)/103223;
            


            %must have minimum 100 elements & be less than 70% of all data
            %(i.e. thresholding)
            if sum(~isnan(mod_masked)) >= 100 && sum(~isnan(mod_masked)) <= 103223*0.7
                mod_masked = mod_masked(~isnan(mod_masked));
                mean_m(j,i+1) = (mean(mod_masked, 'omitnan') - mean(taub, 'omitnan'));
            else 
                mean_m(j,i+1) = NaN;
            end
        end  
    end

    pcolor_arr = mean_m;
end
