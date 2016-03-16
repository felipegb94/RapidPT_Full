close all;
clear;

addpath('functions');
addpath('include')

subjects = [15 50 100];
numPermutations = [10000 80000 320000];
subSamplings = [0.004 0.007];
trainSamples = zeros(1,2);

snpmPrefix = '~/PermTest/outputs/OneSample_ADRC/snpm/outputs_';
rapidptPrefix = '~/PermTest/outputs/OneSample_ADRC/rapidpt/outputs_';

numIterations = size(subjects,2);
numSamplings = size(subSamplings,2);
numTrainSamples = size(trainSamples,2);

kldivs = zeros(numSamplings,numTrainSamples);
path = '~/PermTest/Paper/figures/Runs_OneSample/';

for i = 1:numIterations
    nPerm = num2str(numPermutations(i));
    snpmDescription = strcat(num2str(subjects(i)),'_',nPerm);
    snpmString = strcat(snpmPrefix,snpmDescription,'.mat');
    load(snpmString);
    snpmMaxT = MaxT(:,2);
    trainSamples(1) = ceil(subjects(i)/2);
    trainSamples(2) = ceil(subjects(i));
    for j = 1:numSamplings
       sub = num2str(subSamplings(j));
       for k = 1:numTrainSamples
           train = num2str(trainSamples(k));
           rapidptDescription = strcat(nPerm,'_',sub,'_',train);
           rapidptString = strcat(rapidptPrefix,rapidptDescription,'.mat');
           load(rapidptString);
           rapidptMaxT = outputs.maxT';
           %CompareHistogramsVisually(snpmMaxT,rapidptMaxT,'SnPM','RapidPT')
           kldivergence = CompareHistograms(rapidptMaxT,snpmMaxT);
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
    f = PlotKLDiv(subSamplings, trainSamples, nPerm, kldivs', [0 1],[0.003 0.008], [trainSamples(1), trainSamples(2)]);
    filename = strcat(path,'OneSample_KLDiv_',nPerm);
    print(f,filename,'-dpng')
    
end


