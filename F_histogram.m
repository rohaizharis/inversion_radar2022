%% Notes

% Creates histograms for specularity content and relative reflectivity for
% the 3 regimes

%% Code

clear;clc;

data_specularity = importdata('Thwaites_specularity_v3.txt');
data_reflectivity = importdata('Thwaites_radar_reflectivity_v3.txt');

reflectivity = data_reflectivity(:,9);
specularity = data_specularity(:,3);

data_r1 = importdata('data_r1_linterp2.txt');
data_r2 = importdata('data_r2_linterp2.txt');
data_r3 = importdata('data_r3_linterp2.txt');

ref_edges = -40:4:40;
spec_edges = 0:0.05:1;

subplot(1,2,1)
histogram(specularity, spec_edges, 'DisplayStyle','stairs', "Normalization","probability", 'LineWidth', 3, 'EdgeColor',[0 0 0])
hold on
histogram(data_r1(:,3), spec_edges, 'EdgeColor','none', "Normalization","probability")
histogram(data_r2(:,3), spec_edges, 'EdgeColor','none', "Normalization","probability")
histogram(data_r3(:,3), spec_edges, 'EdgeColor','none', "Normalization","probability")
xlabel("Specularity Content")
ylabel("Probability")
ylim([0 1])
title("Specularity Content")
legend('All', 'R1','R2','R3','location','northwest')
legend boxoff


subplot(1,2,2)
histogram(reflectivity, ref_edges, 'DisplayStyle','stairs', "Normalization","probability", 'LineWidth', 3, 'EdgeColor',[0 0 0])
hold 
histogram(data_r1(:,4), ref_edges, 'EdgeColor','none', "Normalization","probability")
hold on
histogram(data_r2(:,4), ref_edges, 'EdgeColor','none', "Normalization","probability")
histogram(data_r3(:,4), ref_edges, 'EdgeColor','none', "Normalization","probability")
xlabel("Relative Reflectivity (dB)")
ylabel("Probability")
ylim([0 1])
title("Relative Reflectivity")
legend('All', 'R1','R2','R3','location','northwest')
legend boxoff
