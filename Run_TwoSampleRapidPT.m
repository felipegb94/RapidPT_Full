maxNumCompThreads(1);
fprintf('Num of Computational Threads being used = %d',maxNumCompThreads);
nPermutations = [2500, 5000, 10000, 20000, 40000, 80000, 160000, 320000];
subVals = [0.001, 0.0035, 0.005, 0.007, 0.015, 0.05];

% Set path variables
% Load input data and input labels
dataPathVal = '~/PermTest/data/ADRC/ADRC_100_50_50.mat'; 
labelsPathVal = '~/PermTest/data/ADRC/labels_100_50_50.mat'; 
load(dataPathVal);
load(labelsPathVal);
% N subjects, V voxels (or statistics)
[N,V] = size(Data);

trainSamples = [floor(N/2), floor(3*N/4), 2*N, 4*N];

% Set keys for input struct
rapidPTLibraryPathKey = 'rapidPTLibraryPath';
testingTypeKey = 'testingType';
dataPathKey = 'dataPath';
dataKey = 'data';
labelsKey = 'labels';
nGroup1Key = 'nGroup1';
nGroup2Key = 'nGroup2';
subKey = 'sub';
TKey = 'T';
maxRankKey = 'maxRank';
trainNumKey = 'trainNum';
maxCyclesKey = 'maxCycles';
iterKey = 'iter';
writingKey = 'writing';
saveDirKey = 'saveDir';
timingDirKey = 'timingDir';

% Set the corresponding values to the keys.
rapidPTLibraryPathVal = {'~/PermTest/RapidPermTest'};
testingTypeVal = {'TwoSample'};
nGroup1Val = 50; % Size of group 1 
nGroup2Val = 50; % Size of group 2
subVal = {0.001};  % Sampling Rate
TVal = {5000}; % Number of Permutations.
maxRankVal = {N}; % Rank for estimating the low rank subspace
trainNumVal = {100}; % Number of permutations for training.
maxCyclesVal = {3}; % Number of cycles for training.
iterVal = {30}; % Number of iterations for matrix completion.
writingVal = {0}; % 0 if only output maxnull or 1 if outputs maxnull, U and W
saveDirVal = {'~/PermTest/outputs/TwoSample_ADRC_50_50_100/rapidpt/'}; % Path to save outputs
timingDirVal = {'~/PermTest/timings/TwoSample_ADRC_50_50_100/rapidpt/'}; % Path to save timing


iterations = size(nPermutations,2);
numSubVals = size(subVals,2);
numTrainSamples = size(trainSamples,2);

for i = 1:iterations
    TVal = {nPermutations(i)}
    for j = 1:numSubVals
        subVal = {subVals(j)}
        for k = 1:numTrainSamples
            trainNumVal = {trainSamples(k)};
            inputs = struct(rapidPTLibraryPathKey, rapidPTLibraryPathVal,...
                    testingTypeKey, testingTypeVal,...
                    dataKey, Data,...
                    labelsKey, labels,...
                    nGroup1Key, nGroup1Val,...
                    nGroup2Key, nGroup2Val,...
                    subKey, subVal,...
                    TKey, TVal,...
                    maxRankKey, maxRankVal,...
                    trainNumKey, trainNumVal,...
                    maxCyclesKey, maxCyclesVal,...
                    iterKey, iterVal,...
                    writingKey, writingVal,...
                    saveDirKey, saveDirVal,...
                    timingDirKey, timingDirVal);

            outputs = TwoSampleRapidPermutationTesting(inputs);
        end
    end
end  
            
            
            
            
            
            
            
            
            
            