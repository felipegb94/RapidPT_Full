maxNumCompThreads(1);

load('~/PermTest/data/ADRC/TwoSample/ADRC_100_50_50.mat');
numPermutations = [5000 10000 20000 40000 80000 160000 320000];
N = size(Data,1); % N: number of instances
V = size(Data,2); % V : dimension
nGroup1 = 50;
nGroup2 = N - nGroup1;
maxMemory = 1e8;


for i = 1:size(numPermutations,2) 
    nPerm = numPermutations(i);
    completeptPermTime = tic;
    
    dataSquared = Data .* Data;
    [indexMatrix, permutationMatrix1, permutationMatrix2] = TwoSampleGetPermutationMatrices(nPerm, N, nGroup1);
    MaxT = TwoSamplePermTest(Data, dataSquared, permutationMatrix1, permutationMatrix2, nGroup1, nGroup2, maxMemory);

    completeptPermTime = toc(completeptPermTime);
    
    timing_filename = strcat('~/PermTest/timings/TwoSample_ADRC_50_50_100/regularpt/timings_',num2str(N),'_',num2str(nPerm),'.mat');
    output_filename = strcat('~/PermTest/outputs/TwoSample_ADRC_50_50_100/regularpt/outputs_',num2str(N),'_',num2str(nPerm),'.mat');
    save(timing_filename,'completeptPermTime');
    save(output_filename,'MaxT');
end

