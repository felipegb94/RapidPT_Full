addpath('functions');

subjects = [15 50 100];
numPermutations = [10000 80000 320000];

snpmPrefix = '~/PermTest/outputs/OneSample_ADRC/snpm/outputs_';
completeptPrefix = '~/PermTest/outputs/OneSample_ADRC/regularpt/outputs_';

numIterations = size(subjects,2);

for i = 1:numIterations
    currNumSubjects = subjects(i);
    currNumPerms = numPermutations(i);
    description = strcat(num2str(currNumSubjects),'_',num2str(currNumPerms));
    snpmString = strcat(snpmPrefix,description,'.mat'); 
    load(snpmString);
    snpmMaxT = MaxT(:,2);

    completeptString = strcat(completeptPrefix,description,'.mat');
    load(completeptString)
    completeptMaxT = MaxT;
    kldivergence = CompareHistograms(snpmMaxT,completeptMaxT);
    fprintf('kldiv for %s = %f\n',description,kldivergence)
end
