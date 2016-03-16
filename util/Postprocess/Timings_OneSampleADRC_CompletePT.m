addpath('functions');

subjects = [15 50 100];
numPermutations = [10000 80000 320000];

snpmPrefix = '~/PermTest/timings/OneSample_ADRC/snpm/timings_';
completeptPrefix = '~/PermTest/timings/OneSample_ADRC/regularpt/timings_';

numIterations = size(subjects,2);

for i = 1:numIterations
    currNumSubjects = subjects(i);
    currNumPerms = numPermutations(i);
    description = strcat(num2str(currNumSubjects),'_',num2str(currNumPerms));
    snpmString = strcat(snpmPrefix,description,'.mat'); 
    load(snpmString);

    completeptString = strcat(completeptPrefix,description,'.mat');
    load(completeptString)
    completeptPermTime = timing;
    fprintf('Speedup for %s = %f\n',description,snpmPermTime/completeptPermTime)
end
