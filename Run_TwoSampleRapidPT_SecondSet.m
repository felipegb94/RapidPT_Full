maxNumCompThreads(1);
fprintf('Num of Computational Threads being used = %d',maxNumCompThreads);
nPermutations = [5000, 10000, 20000, 40000, 80000, 160000, 320000, 640000];

% Set path variables
% Load input data and input labels
dataPathVal = '~/PermTest/data/ADRC/TwoSample/ADRC_50_25_25.mat'; 
labelsPathVal = '~/PermTest/data/ADRC/TwoSample/labels_50_25_25.mat'; 
load(dataPathVal);
load(labelsPathVal);
% N subjects, V voxels (or statistics)
[N,V] = size(Data);


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
nGroup1Val = 25; % Size of group 1 
nGroup2Val = 25; % Size of group 2
subVal = {0.005};  % Sampling Rate
TVal = {5000}; % Number of Permutations.
maxRankVal = {N}; % Rank for estimating the low rank subspace
trainNumVal = {100}; % Number of permutations for training.
maxCyclesVal = {3}; % Number of cycles for training.
iterVal = {30}; % Number of iterations for matrix completion.
writingVal = {0}; % 0 if only output maxnull or 1 if outputs maxnull, U and W
saveDirVal = {'~/PermTest/outputs/TwoSample_ADRC_25_25_50/rapidpt/'}; % Path to save outputs
timingDirVal = {'~/PermTest/timings/TwoSample_ADRC_25_25_50/rapidpt/'}; % Path to save timing


iterations = size(nPermutations,2);


for i = 1:iterations
    TVal = {nPermutations(i)}

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
            
            
            
            
            
            
            
            
            
            