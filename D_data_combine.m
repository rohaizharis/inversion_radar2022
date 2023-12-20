%% Notes

% Combines coordinates, radar reflectivity, specularity content, NCAR CISM
% & JPL1 ISSM Shear Stress into 1 file. To be used with D_regime_getcoord
% to partition data into 3 different regimes

%% Code

clear;clc;


data_specularity = importdata('Thwaites_specularity_v2.txt');
data_reflectivity = importdata('Thwaites_radar_reflectivity_v3.txt');

data_ncar_taub = importdata("ncar_cism_linterp2.txt");
data_jpl_taub = importdata("jpl1_issm_linterp2.txt");
%filename = ["serg", "awipism1", "doemali", "jpl1issm", "ncarcism", "pikpism1", "ucijpl", "utaselmer", "vubaismpaleo"];
%load ("pcolor_all.mat");

coords = data_ncar_taub(:,1:2);
reflectivity = data_reflectivity(:,9);
specularity = data_specularity(:,3);
ncar_taub = data_ncar_taub(:,3);
jpl_taub = data_jpl_taub(:,3);

combined_arr = [coords, specularity, reflectivity, ncar_taub, jpl_taub];

writematrix(combined_arr, "data_combined_linterp2.txt")
