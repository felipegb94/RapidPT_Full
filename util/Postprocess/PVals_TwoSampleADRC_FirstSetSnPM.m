addpath('functions');
addpath('include')

clf;
close all;
clear;

snpmPrefix = '~/PermTest/outputs/TwoSample_ADRC_50_50_100/snpm/outputs_100_';
snpmPostfix = '.mat';
rapidptPrefix1 = '~/PermTest/outputs/TwoSample_ADRC_50_50_100/rapidpt/';
rapidptPostfix = '.mat';

N = 100;
permutations = [2500 5000 10000 20000 40000 80000 160000]; %320000];
subSamplings = [0.001 0.0035 0.005 0.007 0.015 0.05];
trainSamples = [floor(N/2), floor(3*N/4), N, 2*N];
alphas = [5 1 0.1]

numSamplingRuns = size(subSamplings,2);
numPermRuns = size(permutations,2);
numTrainSamples = size(trainSamples,2);
numAlphas = size(alphas,2);


pValsDiff = zeros(numSamplingRuns,numTrainSamples);
kldivs = zeros(numSamplingRuns,numTrainSamples);

path = '~/PermTest/Paper/figures/Runs_FirstSet/';
for i = 1:numPermRuns
    numPermutations = num2str(permutations(1,i));
    fprintf('NumPermutations = %d\n', permutations(1,i));
    rapidptPrefix = strcat(rapidptPrefix1, numPermutations,'/outputs_');

    % Load snpm 
    load(strcat(snpmPrefix,numPermutations,snpmPostfix));
    snpmMaxT = MaxT(:,1);
    for j = 1:numSamplingRuns
        subSample = num2str(subSamplings(1,j));
        
        for k = 1:numTrainSamples
            trainSample = num2str(trainSamples(1,k));
            rapidptString = strcat(numPermutations,'_',subSample,'_',trainSample);

            load(strcat(rapidptPrefix,rapidptString,rapidptPostfix));
            rapidptMaxT = outputs.maxT;
            pValSnPM = getPVal(snpmMaxT,1);
            pValRapidPT = getPVal(rapidptMaxT,1);
            
            kldivergence = (pValSnPM - pValRapidPT);
            
            kldivs(j,k) = kldivergence; 
            if(kldivergence > 0.15)
                string = strcat('kldivergence > 0.15 for rapidpt with parameters:',rapidptString,'\n kldiv = ', num2str(kldivergence),'\n');
                cprintf('red', string);
            elseif(kldivergence > 0.075)
                string = strcat('kldivergence > 0.075 for rapidpt with parameters:',rapidptString,'\n kldiv = ', num2str(kldivergence),'\n');
                cprintf([1,0.5,0], string);
            else
                string = strcat('kldivergence < 0. 075 for rapidpt with parameters:',rapidptString,'\n kldiv = ', num2str(kldivergence),'\n');
                cprintf('green', string);    
            end
        end
    end
    f = PlotPValDiff(subSamplings, trainSamples, numPermutations, kldivs', [-0.2 0.2], [0 0.055],[25 225]);
    filename = strcat(path,'FirstSet_PValDiff_',numPermutations);
    print(f,filename,'-dpng')
end




