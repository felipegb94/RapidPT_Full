addpath('functions');

clf;
close all;
clear;

snpmPostfix = '.mat';

prefix = '~/PermTest/outputs/';
datasets = {'TwoSample_ADRC_25_25_50', 'TwoSample_ADRC_50_50_100', ...
            'TwoSample_ADRC_100_100_200', 'TwoSample_ADRC_200_200_400'};
       

N = [50 100 200 400];
sumSampling = 0.005;
permutations = [5000 10000 20000 40000 80000]; %320000] 640000];
trainSamples = [100 100 200 200];

numDataSets = size(datasets,2);
numPermRuns = size(permutations,2);

for i = 1:numDataSets
     fprintf('Dataset = %s\n', datasets{i});
     snpmPrefix = strcat(prefix,datasets{i},'/snpm/outputs_',num2str(N(i)),'_');
     rapidptPrefix = strcat(prefix,datasets{i},'/rapidpt/outputs_');
     rapidptPostfix = strcat('_0.005_',num2str(trainSamples(i)),'.mat');
     
     
     for j = 1:numPermRuns
        rapidptString = strcat(rapidptPrefix,num2str(permutations(j)),rapidptPostfix);
        snpmString = strcat(snpmPrefix,num2str(permutations(j)),snpmPostfix);

        load(snpmString);
        snpmMaxT = MaxT(:,2);
        load(rapidptString);
        rapidptMaxT = outputs.maxT;
        
        kldivergence = CompareHistograms(snpmMaxT,rapidptMaxT);
        fprintf('kldivergence = %d, for %d permutations\n',kldivergence,permutations(j));

        if(kldivergence > 0.1)
           fprintf('kldivergence (%d) > 0.05 for rapidpt with parameters:%s\n',kldivergence,rapidptString);
        end
     end

end


% figure;
% hold on;
% % subplot(2,1,1);
% % CompareHistogramsVisually(regularptMaxT, snpmMaxT, 'regularpt','snpm');
% % subplot(2,1,2);
% CompareHistogramsVisually(rapidptMaxT, snpmMaxT, 'rapidpt','snpm');
% hold off;



