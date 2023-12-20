%% Notes

% Loads KS-LL data from mat and plots them

%% Code
clear;clc;
load('ksll_data.mat');


fig = figure;

subplot(3,3,1)
plotfig(ksll.serg)
title('S & H')
%sgtitle('2-Sample KS Test (Low-Low)')

subplot(3,3,2)
plotfig(ksll.awipism1)
title('AWI PISM1')

subplot(3,3,3)
plotfig(ksll.doemali)
title('DOE MALI')

subplot(3,3,4)
plotfig(ksll.jpl1issm)
title('JPL1 ISSM')

subplot(3,3,5)
plotfig(ksll.ncarcism)
title('NCAR CISM')

subplot(3,3,6)
plotfig(ksll.pikpism)
title('PIK PISM')

subplot(3,3,7)
plotfig(ksll.ucijpl)
title('UCIJPL ISSM')

subplot(3,3,8)
plotfig(ksll.utaselmer)
title('UTAS ElmerIce')

subplot(3,3,9)
plotfig(ksll.aismpaleo)
title('VUB AISMPALEO')

han = axes(fig, 'visible', 'off');
han.XLabel.Visible = 'on';
han.YLabel.Visible = 'on';
yl = ylabel(han, 'Relative Reflectivity (dB)');
hyl = get(yl, 'Position');
yl.Position = [hyl(1)-0.01, hyl(2), hyl(3)];
yl.FontSize = 18;
xl = xlabel(han, 'Specularity');
hxl = get(xl, 'Position');
xl.Position = [hxl(1), hxl(2)-0.01, hxl(3)];
xl.FontSize = 18;
% caxis([-50 50])
% c1 = colorbar;
% c1.Label.String = 'Deviation in Mean Shear Stress (kPa)';
% c1.Label.FontSize = 14;
% c1.Position = [hp1(1)+hp1(3)+0.02  hp1(2)  0.015  hp1(4)*3.71];


function plotfig(matrix)
h1 = pcolor(matrix(51,2:51), matrix(1:50,1), matrix(1:50,2:51));
clim([0 1])
colors = [177 0 38; 34 110 156];
colors = uint8(colors);
colormap(colors);
set(gca,'color',[0.5 0.5 0.5]);
set(h1, 'EdgeColor', 'none');
end