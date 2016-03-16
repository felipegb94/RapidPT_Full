% Set path variables

% Load input data and input labels
dataPathVal = '~/PermTest/data/adrc_raw.mat'; 
labelsPathVal = '~/PermTest/data/adrc_raw_labels.mat'; 
load(dataPathVal);
load(labelsPathVal);
% N subjects, V voxels (or statistics)
[N,V] = size(Data);

% Set keys for input struct
rapidPTLibraryPathKey = 'rapidPTLibraryPath';
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
nGroup1Val = 25; % Size of group 1 
nGroup2Val = 25; % Size of group 2
subVal = {0.005};  % Sampling Rate
TVal = {1000}; % Number of Permutations.
maxRankVal = {N}; % Rank for estimating the low rank subspace
trainNumVal = {10};%{100}; % Number of permutations for training.
maxCyclesVal = {1};%{3} % Number of cycles for training.
iterVal = {30}; % Number of iterations for matrix completion.
writingVal = {1}; % 0 if only output maxnull or 1 if outputs maxnull, U and W
saveDirVal = {'~/PermTest/outputs/'}; % Path to save outputs
timingDirVal = {'~/PermTest/timings/'}; % Path to save timing

inputs = struct(rapidPTLibraryPathKey, rapidPTLibraryPathVal,...
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
            
outputs = RapidPermutationTesting(inputs);
            
            
            
            
            
            
            
            
            
            
            