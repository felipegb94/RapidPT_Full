close all;
clear;

addpath('functions');
addpath('include')

subjects = [15 50 100];
numPermutations = [10000 80000 320000];
subSamplings = [0.004 0.007];
trainSamples = zeros(1,2);

snpmPrefix = '~/PermTest/timings/OneSample_ADRC/snpm/timings_';
rapidptPrefix = '~/PermTest/timings/OneSample_ADRC/rapidpt/timings_';

numIterations = size(subjects,2);
numSamplings = size(subSamplings,2);
numTrainSamples = size(trainSamples,2);

speedups = zeros(numSamplings,numTrainSamples);
path = '~/PermTest/Paper/figures/Runs_OneSample/';

for i = 1:numIterations
    nPerm = num2str(numPermutations(i));
    snpmDescription = strcat(num2str(subjects(i)),'_',nPerm);
    snpmString = strcat(snpmPrefix,snpmDescription,'.mat');
    load(snpmString);
    
    trainSamples(1) = ceil(subjects(i)/2);
    trainSamples(2) = ceil(subjects(i));
    for j = 1:numSamplings
       sub = num2str(subSamplings(j));
       for k = 1:numTrainSamples
           train = num2str(trainSamples(k));
           rapidptDescription = strcat(nPerm,'_',sub,'_',train);
           rapidptString = strcat(rapidptPrefix,rapidptDescription,'.mat');
           load(rapidptString);
           speedups(j,k) = snpmPermTime/timings.tTotal 

       end
    end
    f = PlotSpeedup(subSamplings, trainSamples, nPerm, speedups',[1,2]);
    filename = strcat(path,'OneSample_Speedup_',nPerm);
    print(f,filename,'-dpng')
end


