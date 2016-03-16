addpath('functions');

numPermutations = [5000 10000 20000 40000 80000 160000];
snpmPrefix = '~/PermTest/outputs/TwoSample_ADRC_50_50_100/snpm/outputs_100_';
completeptPrefix = '~/PermTest/outputs/TwoSample_ADRC_50_50_100/regularpt/outputs_100_';

numIterations = size(numPermutations,2);

for i = 1:numIterations
    currNumPerms = numPermutations(i);
    description = num2str(currNumPerms);
    snpmString = strcat(snpmPrefix,description,'.mat'); 
    load(snpmString);
    snpmMaxT = MaxT(:,2);

    completeptString = strcat(completeptPrefix,description,'.mat');
    load(completeptString)
    completeptMaxT = MaxT;
    kldivergence = CompareHistograms(snpmMaxT,completeptMaxT);
    fprintf('kldiv for %s = %f\n',description,kldivergence)
end
