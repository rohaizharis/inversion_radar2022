%% Notes

% This is the plotting code for model agreement which plots regions where 7 or more
% models agree on the sign of the deviation in mean basal shear stress, and
% plots the inter-model mean deviation as the colormap.

%% Code

clear;clc;
data_specularity = importdata('Processed Data/Interpolated/Thwaites_specularity_ontoref_v2.txt');
filename = ["serg", "awipism1", "doemali", "jpl1issm", "ncarcism", "pikpism1", "ucijpl", "utaselmer", "vubaismpaleo"];
data_reflectivity = importdata('Processed Data/Interpolated/Thwaites_Radar_v3.txt');
reflectivity = data_reflectivity(:,9);
specularity = data_specularity(:,3);

%Loads the struct file containing the High-High and Low-Low matrices of
%absolute deviation in mean basal shear stress
load ("pcolor_all.mat");

%Creates intervals for ref & spec thresholds
spec_interval = linspace(min(specularity), max(specularity), 50);
ref_interval = linspace(min(reflectivity), max(reflectivity), 50);
stepspec = spec_interval(2) - spec_interval(1);
stepref = ref_interval(2) - ref_interval(1);

%Creates template for data from thresholding
template = zeros(51,51);
template(1:50,1) = flip(ref_interval);
template(51, 2:51) = spec_interval;

agreement_hh = template;
agreement_ll = template;
agreement_hh_raw = agreement_hh(1:50,2:51);
agreement_ll_raw = agreement_ll(1:50,2:51);
hh_intermodalmean = template;
ll_intermodalmean = template;
hh_intermodalmean_raw = template(1:50,2:51);
ll_intermodalmean_raw = template(1:50,2:51);

for h = 1:9
    disp(h);
    temp = st.hh.(filename(h));
    proc = sign(temp(1:50,2:51));
    agreement_hh_raw = agreement_hh_raw + proc;
    hh_intermodalmean_raw = hh_intermodalmean_raw + temp(1:50,2:51);
end
clear temp proc;

for l = 1:9
    disp(l);
    temp = st.ll.(filename(l));
    proc = sign(temp(1:50,2:51));
    agreement_ll_raw = agreement_ll_raw + proc;
    ll_intermodalmean_raw = ll_intermodalmean_raw + temp(1:50,2:51);
end

hh_intermodalmean_raw = hh_intermodalmean_raw./9;
ll_intermodalmean_raw = ll_intermodalmean_raw./9;

%% Masking

mask_hh = agreement_hh_raw >= 7 | agreement_hh_raw <= -7;
mask_ll = agreement_ll_raw >= 7 | agreement_ll_raw <= -7;
mask_hh = double(mask_hh);
mask_ll = double(mask_ll);

%% Coordinate

coord_hh = [];
colormap_hh = [];
coord_ll = [];
colormap_ll = [];

for i = 1:50
    for j = 1:50
        if (mask_hh(i,j)) == 1
            coord_hh = [coord_hh; agreement_hh(51,j+1)+(stepspec/2), agreement_hh(i+1,1)+(stepref/2)];
            colormap_hh = [colormap_hh; hh_intermodalmean_raw(i,j)];
        end
        if (mask_ll(i,j)) == 1
            coord_ll = [coord_ll; agreement_ll(51,j+1)+(stepspec/2), agreement_ll(i+1,1)+(stepref/2)];
            colormap_ll = [colormap_ll; ll_intermodalmean_raw(i,j)];
        end
    end
end

coord_hh = coord_hh(1:1456,:);
colormap_hh = colormap_hh(1:1456,:);

%% pcolor NaN mask

nan_bss_hh = st.hh.jpl1issm;
nan_bss_ll = st.ll.jpl1issm;
nan_bss_hh(1:50, 2:51) = (isnan(nan_bss_hh(1:50, 2:51)));
nan_bss_ll(1:50, 2:51) = isnan(nan_bss_ll(1:50, 2:51));

%% Plotting


sp1=subplot(2,1,1);
p1 = get(sp1,'position');
sp2=subplot(2,1,2);
p2 = get(sp2,'position');


fig = figure;
ax1 = axes(fig);
h1 = pcolor(ax1, nan_bss_hh(51,2:51), nan_bss_hh(1:50,1), nan_bss_hh(1:50,2:51));
cmap = winter(10);
cmap(1,:) = [1 ,1 ,1];
cmap(10,:) = [0.5 ,0.5 ,0.5];
colormap(ax1, cmap);
set(h1, 'EdgeColor', 'none');
view(2)
hold on;
ax2 = axes(fig);
%set(ax2, 'color', 'none');
sc1 = scatter(ax2, coord_hh(:,1), coord_hh(:,2), 25, colormap_hh, 'filled');
% set(sc1, 'Color', 'none');
clim(ax2, [-50 50])
colormap(ax2, brewermap([],'PiYG'));
c1 = colorbar(ax2);
ylim(ax2, [-32.8384 37.6089])
xlim(ax2, [0 1])
%%Link them together
linkaxes([ax1,ax2])
%Hide the top axes
% ax1.Visible = 'off';
% ax1.XTick = [];
% ax1.YTick = [];
ax2.Visible = 'off';
set([ax1,ax2],'Position',p1);
title(ax1, "Model Agreement (High-High)");
c1.Label.String = "Deviation from Mean Shear Stress (kPa)";
c1.Label.FontSize = 14;



ax3 = axes(fig);
h2 = pcolor(ax3, nan_bss_ll(51,2:51), nan_bss_ll(1:50,1), nan_bss_ll(1:50,2:51));
cmap = winter(10);
cmap(1,:) = [1 ,1 ,1];
cmap(10,:) = [0.5 ,0.5 ,0.5];
colormap(ax3, cmap);
set(h2, 'EdgeColor', 'none');
view(2)
hold on;
ax4 = axes(fig);
%set(ax2, 'color', 'none');
sc2 = scatter(ax4, coord_ll(:,1), coord_ll(:,2), 25, colormap_ll, 'filled');
% set(sc1, 'Color', 'none');
clim(ax4, [-20 20])
colormap(ax4, brewermap([],'PiYG'));
c2 = colorbar(ax4);
ylim(ax4, [-32.8384 37.6089])
xlim(ax4, [0 1])
%%Link them together
linkaxes([ax3,ax4])
%Hide the top axes
% ax1.Visible = 'off';
% ax1.XTick = [];
% ax1.YTick = [];
ax4.Visible = 'off';
set([ax3,ax4],'Position',p2);
c2.Label.String = "Deviation from Mean Shear Stress (kPa)";
c2.Label.FontSize = 14;
title(ax3, "Model Agreement (Low-Low)");


han = axes(fig, 'visible', 'off');
han.XLabel.Visible = 'on';
han.YLabel.Visible = 'on';
yl = ylabel(han, 'Relative Reflectivity (dB)');
hyl = get(yl, 'Position');
yl.Position = [hyl(1)-0.01, hyl(2), hyl(3)];
yl.FontSize = 20;
xl = xlabel(han, 'Specularity');
hxl = get(xl, 'Position');
xl.Position = [hxl(1), hxl(2)-0.01, hxl(3)];
xl.FontSize = 20;

