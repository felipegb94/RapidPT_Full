
load('~/PermTest/data/ADRC/OneSample/OneSampleADRC_15_8_7.mat');
numPermutations = 10000;
[N,V] = size(Data);
[permutationMatrix] = OneSampleGetPermutationMatrices(numPermutations, N);
timing = tic;
dataSquared = Data.*Data;
maxMemory = 1e8; % Maximum memory to use (in bytes)
[MaxT, tStatMatrix] = OneSamplePermTest(abs(Data), dataSquared, permutationMatrix, maxMemory);
timing = toc(timing);

timing_filename = strcat('~/PermTest/timings/OneSample_ADRC/regularpt/timing_',num2str(N),'_',num2str(numPermutations),'.mat');
output_filename = strcat('~/PermTest/outputs/OneSample_ADRC/regularpt/output_',num2str(N),'_',num2str(numPermutations),'.mat');
save(timing_filename,'timing');
save(output_filename,'MaxT');
