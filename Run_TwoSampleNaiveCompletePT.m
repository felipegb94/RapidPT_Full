%maxNumCompThreads(1);

load('~/PermTest/data/ADRC/TwoSample/ADRC_100_50_50.mat');
numPermutations = 2500; %10000 20000 40000 80000 160000 320000];
N = size(Data,1); % N: number of instances
V = size(Data,2); % V : dimension
nGroup1 = 50;
nGroup2 = N - nGroup1;

timing_filename = strcat('~/PermTest/timings/TwoSample_ADRC_50_50_100/regularpt/timingsNaive_',num2str(N),'_',num2str(numPermutations),'.mat');
output_filename = strcat('~/PermTest/outputs/TwoSample_ADRC_50_50_100/regularpt/outputsNaive_',num2str(N),'_',num2str(numPermutations),'.mat');

completeptPermTime = tic;
[indexMatrix, permutationMatrix1, permutationMatrix2] = TwoSampleGetPermutationMatrices(numPermutations, N, nGroup1);
MaxT = TwoSamplePermTest_Naive(Data, indexMatrix, nGroup1);
completeptPermTime = toc(completeptPermTime);

save(timing_filename,'completeptPermTime');
save(output_filename,'MaxT');

