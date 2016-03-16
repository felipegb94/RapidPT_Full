addpath('functions');

clf;
close all;
clear;

addpath('include/');

postfix = '.mat';

prefix = '~/PermTest/timings/';
datasets = {'TwoSample_ADRC_25_25_50', 'TwoSample_ADRC_50_50_100', ...
            'TwoSample_ADRC_100_100_200' ,'TwoSample_ADRC_200_200_400'};
datasetLabels = {'25-25-50','50-50-100','100-100-200','200-200-400'}  ;        

N = [50 100 200 400];
subSampling = 0.005;
permutations = [10000];
trainSamples = [100 100 200 200];
nPerm = '10000';


numDataSets = size(datasets,2);
numPermRuns = size(permutations,2);


permutations = permutations';
format long;


path = '~/PermTest/Paper/figures/Runs_SecondSet/';
completeptTimings = zeros(1,4);
rapidptRecoveryTimings = zeros(1,4);
rapidptTrainingTimings = zeros(1,4);
rapidptTimings = zeros(1,4);

for i = 1:numDataSets
    
    naiveptPath = strcat(prefix,datasets{i},'/regularpt/','timingsNaive_',num2str(N(i)),'_',nPerm,postfix);
    rapidptPath = strcat(prefix,datasets{i},'/rapidpt/','timings_',nPerm,'_',num2str(subSampling),'_',num2str(trainSamples(i)),postfix);
    load(naiveptPath);
    completeptTimings(1,i) = completeptPermTime;
    load(rapidptPath);
    rapidptRecoveryTimings(1,i) = timings.tRecovery;
    rapidptTrainingTimings(1,i) = timings.tTraining;
    rapidptTimings(1,i) = timings.tTotal;

end


for i = 1:numPermRuns
   currPerm = num2str(permutations(i));
   
   
   stackData = zeros(numDataSets, 2, 2);
   for j = 1:numDataSets
      stackData(j,1,1) = rapidptTrainingTimings(j)/3600;
      stackData(j,1,2) = rapidptRecoveryTimings(j)/3600;
      stackData(j,2,1) = completeptTimings(j)/3600;
   end
   f = plotBarStackGroups(stackData, datasetLabels);
   grid on

   title(strcat('Timing Comparisson-',' ',currPerm,' permutations'))
   xlabel('Datasets (nGroups1-nGroup2-totalN)');
   ylabel('Timings (Hours)');
   legend('RapidPT Train Time','RapidPT Recovery Time','NaivePT Time', 'Location','northwest')
   set(gca,'FontSize',14)
   
   filename = strcat(path,'SecondSetNaivePT_TimingDatasets_',currPerm);
   print(f,filename,'-dpng')
   
end








