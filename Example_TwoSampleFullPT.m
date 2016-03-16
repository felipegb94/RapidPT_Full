
load('~/PermTest/data/ADRC/TwoSample/ADRC_100_50_50.mat');
numPermutations = 20000;
N = size(Data,1); % N: number of instances
V = size(Data,2); % V : dimension
nGroup1 = 50;
nGroup2 = N - nGroup1;
maxMemory = 5e8;

timing = tic;

dataSquared = Data .* Data;
[indexMatrix, permutationMatrix1, permutationMatrix2] = TwoSampleGetPermutationMatrices(numPermutations, N, nGroup1);
MaxT = TwoSamplePermTest(Data, dataSquared, permutationMatrix1, permutationMatrix2, nGroup1, nGroup2, maxMemory);

timing = toc(timing);

timing_filename = strcat('~/PermTest/timings/TwoSample_ADRC_50_50_100/test_timing_',num2str(numPermutations),'.mat');
output_filename = strcat('~/PermTest/outputs/TwoSample_ADRC_50_50_100/test_output_',num2str(numPermutations),'.mat');
save(timing_filename,'timing');
save(output_filename,'MaxT');

