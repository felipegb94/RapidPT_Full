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
trainSamples = [100 100 200 200];

firstRow = {'Permutations/\alpha','5','1','0.1'};
firstCol = {'5000','10000','20000','40000','80000'};

numDataSets = size(datasets,2);
numPermRuns = size(permutations,2);
numAlphas = size(alphas,2);

pValsSnPM = zeros(numPermRuns,numAlphas);
pValsRapidPT = zeros(numPermRuns,numAlphas);

for i = 1:numDataSets
    currN = num2str(N(i));
    currTrainSample = num2str(trainSamples(i));
    filePrefixSnPM = strcat('outputs_',currN,'_');
    filePrefixRapidPT = 'outputs_';
    filePostfixRapidPT = strcat('_0.005_',currTrainSample);
    currDataset = datasets{i};
    currPath = strcat(prefix,currDataset,'/');
    currSnPMPath = strcat(currPath,'snpm/');
    currRapidPTPath = strcat(currPath,'rapidpt/');
    fprintf('%s\n',currPath);
    for j = 1:numPermRuns
        currPerm = num2str(permutations(j));
        filenameSnPM = strcat(filePrefixSnPM,currPerm,'.mat');
        filenameRapidPT = strcat(filePrefixRapidPT,currPerm,filePostfixRapidPT,'.mat');
        fullPathSnPM = strcat(currSnPMPath,filenameSnPM);
        fullPathRapidPT = strcat(currRapidPTPath,filenameRapidPT);
        load(fullPathSnPM);
        load(fullPathRapidPT)
        MaxTSnPM = MaxT(:,1);
        MaxTRapidPT = outputs.maxT;
        pValsSnPM(j,1) = getPVal(MaxTSnPM,alphas(1));
        pValsSnPM(j,2) = getPVal(MaxTSnPM,alphas(2));
        pValsSnPM(j,3) = getPVal(MaxTSnPM,alphas(3));
        pValsRapidPT(j,1) = getPVal(MaxTRapidPT,alphas(1));
        pValsRapidPT(j,2) = getPVal(MaxTRapidPT,alphas(2));
        pValsRapidPT(j,3) = getPVal(MaxTRapidPT,alphas(3));
    end
    avgPVal = (pValsSnPM + pValsRapidPT)/2;
    printLatexTable((pValsSnPM - pValsRapidPT)./avgPVal, firstCol, firstRow);
    %f = PlotKLDiv(subSamplings, permutations, numPermutations, kldivs', [-1 1], [0 0.055],[25 225]);

end

    