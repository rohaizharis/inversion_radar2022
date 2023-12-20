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
st.hh.serg = pcolorgenhh("Processed Data/Interpolated/Thwaites_sh_ontoref_v3.txt");
st.hh.awipism1 = pcolorgenhh("Processed Data/ISMIP6/Interp_v3/AWI_PISM1_ontoref.txt");
st.hh.doemali = pcolorgenhh("Processed Data/ISMIP6/Interp_v3/DOE_MALI_ontoref.txt");
st.hh.jpl1issm = pcolorgenhh("Processed Data/ISMIP6/Interp_v3/JPL1_ISSM_ontoref.txt");
st.hh.ncarcism = pcolorgenhh("Processed Data/ISMIP6/Interp_v3/NCAR_CISM_ontoref.txt");
st.hh.pikpism1 = pcolorgenhh("Processed Data/ISMIP6/Interp_v3/PIK_PISM1_ontoref.txt");
st.hh.ucijpl = pcolorgenhh("Processed Data/ISMIP6/Interp_v3/UCIJPL_ISSM_ontoref.txt");
st.hh.utaselmer = pcolorgenhh("Processed Data/ISMIP6/Interp_v3/UTAS_ElmerIce_ontoref.txt");
st.hh.vubaismpaleo = pcolorgenhh("Processed Data/ISMIP6/Interp_v3/VUB_AISMPALEO_ontoref.txt");

st.ll.serg = pcolorgenll("Processed Data/Interpolated/Thwaites_sh_ontoref_v3.txt");
st.ll.awipism1 = pcolorgenll("Processed Data/ISMIP6/Interp_v3/AWI_PISM1_ontoref.txt");
st.ll.doemali = pcolorgenll("Processed Data/ISMIP6/Interp_v3/DOE_MALI_ontoref.txt");
st.ll.jpl1issm = pcolorgenll("Processed Data/ISMIP6/Interp_v3/JPL1_ISSM_ontoref.txt");
st.ll.ncarcism = pcolorgenll("Processed Data/ISMIP6/Interp_v3/NCAR_CISM_ontoref.txt");
st.ll.pikpism1 = pcolorgenll("Processed Data/ISMIP6/Interp_v3/PIK_PISM1_ontoref.txt");
st.ll.ucijpl = pcolorgenll("Processed Data/ISMIP6/Interp_v3/UCIJPL_ISSM_ontoref.txt");
st.ll.utaselmer = pcolorgenll("Processed Data/ISMIP6/Interp_v3/UTAS_ElmerIce_ontoref.txt");
st.ll.vubaismpaleo = pcolorgenll("Processed Data/ISMIP6/Interp_v3/VUB_AISMPALEO_ontoref.txt");

save('pcolor_all.mat', 'st')

%% Function
function pcolor_arr = pcolorgenhh(filepath)
    %% Load Data 

    data_specularity = importdata('Processed Data/Interpolated/Thwaites_specularity_ontoref_v2.txt');
    data_reflectivity = importdata('Processed Data/Interpolated/Thwaites_Radar_v3.txt');

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

    data_specularity = importdata('Processed Data/Interpolated/Thwaites_specularity_ontoref_v2.txt');
    data_reflectivity = importdata('Processed Data/Interpolated/Thwaites_Radar_v3.txt');

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
