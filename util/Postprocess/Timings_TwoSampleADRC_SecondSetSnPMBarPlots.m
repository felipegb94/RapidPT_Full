addpath('functions');

clf;
close all;
clear;

addpath('include/');

snpmPostfix = '.mat';

prefix = '~/PermTest/timings/';
datasets = {'TwoSample_ADRC_25_25_50', 'TwoSample_ADRC_50_50_100', ...
            'TwoSample_ADRC_100_100_200' ,'TwoSample_ADRC_200_200_400'};
datasetLabels = {'25-25-50','50-50-100','100-100-200','200-200-400'}  ;        

N = [50 100 200 400];
sumSampling = 0.005;
permutations = [5000 10000 20000 40000 80000 160000 320000 640000];% 160000]; %320000] 640000];
trainSamples = [100 100 200 200];


numDataSets = size(datasets,2);
numPermRuns = size(permutations,2);


[ timingsSnPM, timingsRapidPT, timingsRapidPTTraining, timingsRapidPTRecovery ] = GetTimings_SecondSet(datasets, N, permutations, trainSamples);


permutations = permutations';
format long;


path = '~/PermTest/Paper/figures/Runs_SecondSet/';
newTimingsSnPM = timingsSnPM;
for i = 1:numDataSets
    snpmData = timingsSnPM(i,:)'./(3600);
    [snpmSlope, snpmPrediction, failIndex1 ] = FitLine( permutations, snpmData );
    newTimingsSnPM(i,:) = snpmPrediction';
end


for i = 1:numPermRuns
   snpmData = newTimingsSnPM(:,i);
   currPerm = num2str(permutations(i));
   
   rapidptData = timingsRapidPT(:,i)./(3600);
   rapidptTrainData = timingsRapidPTTraining(:,i)./(3600);
   rapidptRecData = timingsRapidPTRecovery(:,i)./(3600);
   
   stackData = zeros(numDataSets, 2, 2);
   for j = 1:numDataSets
      stackData(j,1,1) = rapidptTrainData(j);
      stackData(j,1,2) = rapidptRecData(j);
      stackData(j,2,1) = snpmData(j);
   end
   f = plotBarStackGroups(stackData, datasetLabels);
   grid on

   title(strcat('Timing Comparisson-',' ',currPerm,' permutations'))
   xlabel('Datasets (nGroups1-nGroup2-totalN)');
   ylabel('Timings (Hours)');
   legend('RapidPT Train Time','RapidPT Recovery Time','SnPM Time', 'Location','northwest')
   set(gca,'FontSize',14)
   
   filename = strcat(path,'SecondSet_TimingDatasets_',currPerm);
   print(f,filename,'-dpng')
   
end








