%% Notes


% This generates Low-Low plots for absolute deviation in mean basal shear
% stress for all inversions considered in this study

%% Code
clear;clc;
fig = figure;

subplot(3,3,1)

pcolorgen("Processed Data/Interpolated/Thwaites_sh_ontoref_v3.txt");
title("S & H 2013")

subplot(3,3,2)
pcolorgen("Processed Data/ISMIP6/Interp_v3/AWI_PISM1_ontoref.txt")
title("AWI PISM1")

subplot(3,3,3)
pcolorgen("Processed Data/ISMIP6/Interp_v3/DOE_MALI_ontoref.txt")
title("DOE MALI")

subplot(3,3,4)
pcolorgen("Processed Data/ISMIP6/Interp_v3/JPL1_ISSM_ontoref.txt")
title("JPL1 ISSM")

subplot(3,3,5)
pcolorgen("Processed Data/ISMIP6/Interp_v3/NCAR_CISM_ontoref.txt")
title("NCAR CISM")

subplot(3,3,6)
pcolorgen("Processed Data/ISMIP6/Interp_v3/PIK_PISM1_ontoref.txt")
title("PIK PISM1")

subplot(3,3,7)
pcolorgen("Processed Data/ISMIP6/Interp_v3/UCIJPL_ISSM_ontoref.txt")
title("UCIJPL ISSM")

subplot(3,3,8)
pcolorgen("Processed Data/ISMIP6/Interp_v3/UTAS_ElmerIce_ontoref.txt")
title("UTAS ElmerIce")

subplot(3,3,9)
pcolorgen("Processed Data/ISMIP6/Interp_v3/VUB_AISMPALEO_ontoref.txt")
title("VUB AISMPALEO")
hp1 = get(subplot(3,3,9), 'Position');

han = axes(fig, 'visible', 'off');
han.XLabel.Visible = 'on';
han.YLabel.Visible = 'on';
yl = ylabel(han, 'Relative Reflectivity (dB)');
hyl = get(yl, 'Position');
yl.Position = [hyl(1)-0.01, hyl(2), hyl(3)];
yl.FontSize = 16;
xl = xlabel(han, 'Specularity');
hxl = get(xl, 'Position');
xl.Position = [hxl(1), hxl(2)-0.01, hxl(3)];
xl.FontSize = 16;
caxis([-30 30])
c1 = colorbar;
c1.Label.String = 'Deviation in Mean Shear Stress (kPa)';
c1.Label.FontSize = 14;
c1.Position = [hp1(1)+hp1(3)+0.02  hp1(2)  0.015  hp1(4)*3.71];





function pcolorgen(filepath)
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


    %% Iteration to find absolute deviation in mean basal shear stress

    for i = 1:50
        disp(i)
        for j = 1:50
            %sets mask for specularity & reflectivity
            mask = specularity < template(51,i+1) & reflectivity < template(j,1);

            %masks complete dataset with above mask
            mod_masked = taub(mask);
            %numtot(j,i+1) = numel(mod_masked)/103223;


            %sample must have minimum 100 elements & be less than 70% of all data
            %(i.e. thresholding)
            if sum(~isnan(mod_masked)) >= 100 && sum(~isnan(mod_masked)) <= 103223*0.7
                mean_m(j,i+1) = (mean(mod_masked, 'omitnan') - mean(taub, 'omitnan'));
            else 
                mean_m(j,i+1) = NaN;
            end
        end  
    end
    
    %% Plotting

    h1 = pcolor(mean_m(51,[2:51]), mean_m([1:50],1), mean_m([1:50],[2:51]));
    caxis([-30, 30])
    colormap(brewermap([],'PiYG'));
    set(gca,'color',[0.5 0.5 0.5]);
    set(gca,'FontSize',16);
    set(h1, 'EdgeColor', 'none');
end
