maxNumCompThreads(1);
fprintf('Num of Computational Threads being used = %d',maxNumCompThreads);

dataPaths = {'~/PermTest/data/ADRC/OneSample/OneSampleADRC_15_8_7.mat',...
             '~/PermTest/data/ADRC/OneSample/OneSampleADRC_50_25_25.mat',...
             '~/PermTest/data/ADRC/OneSample/OneSampleADRC_100_50_50.mat'};

saveDir = '~/PermTest/outputs/OneSample_ADRC/rapidpt/'; 
timingDir = '~/PermTest/timings/OneSample_ADRC/rapidpt/';       

nPermutations = [10000 80000 320000];
subVals = [0.004 0.007];

iterations = size(nPermutations,2);
numSubVals = size(subVals,2);
numTrainSamples = 2;

for i = 1:iterations
   dataPathVal = dataPaths{i};
   load(dataPathVal);
   [N,V] = size(Data);
   nPerm = nPermutations(i);
   for j = 1:numSubVals
       sub = subVals(j);
       for k = 1:numTrainSamples
          trainNum = ceil(N/k);
          OneSampleRapidPT(dataPathVal,...
                           nPerm,...
                           trainNum,...
                           sub,...
                           saveDir,...
                           timingDir);       
       end 
   end  
end
  
         

            
            
            
            
            
            
            
            
            
            
            