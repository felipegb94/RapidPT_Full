addpath('functions');

clf;
close all;
clear;

snpmPostfix = '.mat';

prefix = '~/PermTest/timings/';
datasets = {'TwoSample_ADRC_25_25_50', 'TwoSample_ADRC_50_50_100', ...
            'TwoSample_ADRC_100_100_200' ,'TwoSample_ADRC_200_200_400'};
        
datasetTitles = {'TwoSampleADRC-25-25-50', 'TwoSampleADRC-50-50-100', ...
                'TwoSampleADRC-100-100-200' ,'TwoSampleADRC-200-200-400'};    

N = [50 100 200 400];
sumSampling = 0.005;
permutations = [5000 10000 20000 40000 80000 160000 320000 640000];% 160000]; %320000] 640000];
trainSamples = [100 100 200 200];


numDataSets = size(datasets,2);
numPermRuns = size(permutations,2);


[timingsSnPM, timingsRapidPT,timingsRapidPTTraining,timingsRapidPTRecovery] = GetTimings_SecondSet(datasets, N, permutations, trainSamples)

permutations = permutations';
format long;


path = '~/PermTest/Paper/figures/Runs_SecondSet/';
for i = 1:numDataSets
    %CompareTimings2(permutations, timingsRapidPT(i,:)./60, timingsSnPM(i,:)./60, 'RapidPT', 'SnPM', 0.005 )
    snpmData = timingsSnPM(i,:)'./(3600);
    rapidptData = timingsRapidPT(i,:)'./(3600);
  
    [snpmSlope, snpmPrediction, failIndex1 ] = FitLine( permutations, snpmData );
    [rapidptSlope, rapidptPrediction, failIndex2 ] = FitLine( permutations, rapidptData );
   
    f = figure;
    hold on;
    grid on
    set(gca,'xtick',0:50000:650000);
    set(gca,'ytick',0:20:350);

    title(strcat('SnPM vs RapidPT Performance-',datasetTitles(i)))
    scatter(permutations(1:failIndex1)',snpmData(1:failIndex1),'*','red');
    scatter(permutations',rapidptData,'*','blue');
    plot(permutations,snpmPrediction,'red');
    plot(permutations,rapidptPrediction,'blue');

    xlabel('Number of Permutations');
    ylabel('Time (hours)');
    legend('SnPM','RapidPT','SnPM-LinearFit','RapidPT-LinearFit','Location','northwest');
    set(gca,'FontSize',14)

    hold off;
    filename = strcat(path,'SecondSet_Timing_',datasets{i});
    print(f,filename,'-dpng')    
end








