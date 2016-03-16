addpath('functions');


clf;
close all;
clear;

completeptPrefix = '~/PermTest/timings/TwoSample_ADRC_50_50_100/regularpt/timingsNaive_100_';
completeptPostfix = '.mat';
rapidptPrefix1 = '~/PermTest/timings/TwoSample_ADRC_50_50_100/rapidpt/';
rapidptPostfix = '.mat';

N = 100;
permutations = [5000 10000 20000 40000 80000 160000]; 
subSamplings = [0.001 0.0035 0.005 0.007 0.015 0.05];
trainSamples = [floor(N/2), floor(3*N/4), N, 2*N];

numSamplingRuns = size(subSamplings,2);
numPermRuns = size(permutations,2);
numTrainSamples = size(trainSamples,2);

speedups = zeros(numSamplingRuns,numTrainSamples);
path = '~/PermTest/Paper/figures/Runs_FirstSet/';

for i = 1:numPermRuns
    numPermutations = num2str(permutations(1,i));
    fprintf('NumPermutations = %d\n', permutations(1,i));
    rapidptPrefix = strcat(rapidptPrefix1, numPermutations,'/timings_');

    % Load completept 
    load(strcat(completeptPrefix,numPermutations,completeptPostfix));
    % completeptPermTime = timing;
    for j = 1:numSamplingRuns
        subSample = num2str(subSamplings(1,j));
        
        for k = 1:numTrainSamples
            trainSample = num2str(trainSamples(1,k));
            rapidptString = strcat(numPermutations,'_',subSample,'_',trainSample);

            load(strcat(rapidptPrefix,rapidptString,rapidptPostfix)); 
            speedups(j,k) = completeptPermTime/timings.tTotal; 

        end
    end
    f = PlotSpeedup(subSamplings, trainSamples, numPermutations, speedups',[10,90]);
    filename = strcat(path,'FirstSetNaivePT_Speedups_',numPermutations);
    print(f,filename,'-dpng');
end




