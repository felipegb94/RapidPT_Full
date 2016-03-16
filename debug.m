
%addpath('~/PermTest/RapidPermTest/mex/');
load('~/PermTest/data/adrc_raw.mat');
load('~/PermTest/data/adrc_raw_labels.mat');

unlabels = unique(labels); % Unique labels
% Allocate space for matrix containing all combinations of labels used for permutations
N_gp1 = length(find(labels==unlabels(1))); % Number of patients in group 1

load('~/PermTest/RapidPermTest/debug_data/labels_current_nomex.mat');


T = perm_tests(Data,labels_current,N_gp1);

g1 = [7.8264e-06, 7.5561e-01, 5.3277e-01; ...
      1.3154e-01, 4.5865e-01, 2.1896e-01];
  
g2 = [0.0470, 0.6793, 0.3835; ...
      0.6789, 0.9347,  0.5194];
  
g2(1,1) = 0;
  
[junk1 junk2 junk3 stats] = ttest2(g1, g2, 0.05, 'both', 'unequal');

