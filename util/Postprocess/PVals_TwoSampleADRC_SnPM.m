addpath('functions');
clf;
close all;
clear;

prefix = '~/PermTest/outputs/';
datasets = {'TwoSample_ADRC_25_25_50', 'TwoSample_ADRC_50_50_100', ...
            'TwoSample_ADRC_100_100_200' ,'TwoSample_ADRC_200_200_400'};
        
datasetTitles = {'TwoSampleADRC-25-25-50', 'TwoSampleADRC-50-50-100', ...
                'TwoSampleADRC-100-100-200' ,'TwoSampleADRC-200-200-400'};

           
N = [50 100 200 400];
permutations = [5000 10000 20000 40000 80000];
alphas = [5 1 0.1];
firstRow = {'Permutations/\alpha','5','1','0.1'};
firstCol = {'5000','10000','20000','40000','80000'};

numDataSets = size(datasets,2);
numPermRuns = size(permutations,2);
numAlphas = size(alphas,2);

pVals = zeros(numPermRuns,numAlphas);
for i = 1:numDataSets
    currN = num2str(N(i));
    filePrefix = strcat('outputs_',currN,'_');
    currDataset = datasets{i};
    currPath = strcat(prefix,currDataset,'/');
    currSnPMPath = strcat(currPath,'snpm/');
    fprintf('%s\n',currPath);
    for j = 1:numPermRuns
        currPerm = num2str(permutations(j));
        filename = strcat(filePrefix,currPerm,'.mat');
        fullPath = strcat(currSnPMPath,filename);
        load(fullPath);
        pVals(j,1) = getPVal(MaxT(:,1),alphas(1));
        pVals(j,2) = getPVal(MaxT(:,1),alphas(2));
        pVals(j,3) = getPVal(MaxT(:,1),alphas(3));
    end
    printLatexTable(pVals,firstCol,firstRow);
end

    