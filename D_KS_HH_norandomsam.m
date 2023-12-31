%% Notes

% Generates the HH version for KS testing. Does the test with the overall 
% dataset, includes samples greater than 70% of dataset and samples with 
% minimum 5 samples to demonstrate value of bootstrapping. Runs the test 
% 20 times and tests at 5% confidence interval


%% Code


clear;clc;
fig = figure;

subplot(3,3,1)

kshh.serg = pcolorgen("sergienko_linterp2.txt");
title("S & H")
sgl = sgtitle("Deviation in Mean Basal Shear Stress, High-High");
sgl.FontSize = 16;


subplot(3,3,2)
kshh.awipism1 = pcolorgen("awi_pism1_linterp2.txt");
title("AWI PISM1")

subplot(3,3,3)
kshh.doemali = pcolorgen("doe_mali_linterp2.txt");
title("DOE MALI")

subplot(3,3,4)
kshh.jpl1issm = pcolorgen("jpl1_issm_linterp2.txt");
title("JPL1 ISSM")

subplot(3,3,5)
kshh.ncarcism = pcolorgen("ncar_cism_linterp2.txt");
title("NCAR CISM")

subplot(3,3,6)
kshh.pikpism = pcolorgen("pik_pism1_linterp2.txt");
title("PIK PISM1")

subplot(3,3,7)
kshh.ucijpl = pcolorgen("ucijpl_issm_linterp2.txt");
title("UCIJPL ISSM")

subplot(3,3,8)
kshh.utaselmer = pcolorgen("utas_elmerice_linterp2.txt");
title("UTAS ElmerIce")

subplot(3,3,9)
kshh.aismpaleo = pcolorgen("vub_aismpaleo_linterp2.txt");
title("VUB AISMPALEO")
hp1 = get(subplot(3,3,9), 'Position');

han = axes(fig, 'visible', 'off');
han.XLabel.Visible = 'on';
han.YLabel.Visible = 'on';
yl = ylabel(han, 'Relative Reflectivity (dB)');
hyl = get(yl, 'Position');
yl.Position = [hyl(1)-0.01, hyl(2), hyl(3)];
yl.FontSize = 14;
xl = xlabel(han, 'Specularity');
hxl = get(xl, 'Position');
xl.Position = [hxl(1), hxl(2)-0.01, hxl(3)];
xl.FontSize = 14;
caxis([0 1])
c1 = colorbar;
c1.Label.String = 'Deviation in Mean Shear Stress (kPa)';
c1.Label.FontSize = 14;
c1.Position = [hp1(1)+hp1(3)+0.02  hp1(2)  0.015  hp1(4)*3.71];

%Saves the KS Test data as a structure for all 9 models
save('kshh_norandomsam_data.mat', 'kshh')


function matrix = pcolorgen(filepath)
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
            


        %must have minimum 5 non-NaN elements 
        %(i.e. thresholding)
        if sum(~isnan(mod_masked)) >= 5 
            mod_masked = mod_masked(~isnan(mod_masked));
            temphval = zeros(1,20);
            for k = 1:20
                [temphval(1,k),~] = kstest2(mod_masked, taub, 'Alpha', 0.05);
            end
            if sum(temphval) > 1
                mean_m(j,i+1) = 1;
            else
                mean_m(j,i+1) = 0;
            end
        
        else 
            mean_m(j,i+1) = NaN;
        end
        end  
    end
    
    %% Plotting

    matrix = mean_m;

    h1 = pcolor(mean_m(51,[2:51]), mean_m([1:50],1), mean_m([1:50],[2:51]));
    caxis([0, 1])
    %colormap(brewermap([],'PiYG'));
    set(gca,'color',[0.5 0.5 0.5]);
    set(h1, 'EdgeColor', 'none');
end
