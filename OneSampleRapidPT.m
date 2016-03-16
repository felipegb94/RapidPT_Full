function [ outputs ] = OneSampleRapidPT( dataPathVal, numPermutations, trainNum, sub, saveDir, timingDir   )
%OneSampleRapidPT Summary of this function goes here
%   Detailed explanation goes here

% Set keys for input struct
rapidPTLibraryPathKey = 'rapidPTLibraryPath';
testingTypeKey = 'testingType';
dataPathKey = 'dataPath';
dataKey = 'data';
labelsKey = 'labels';
subKey = 'sub';
TKey = 'T';
maxRankKey = 'maxRank';
trainNumKey = 'trainNum';
maxCyclesKey = 'maxCycles';
iterKey = 'iter';
writingKey = 'writing';
saveDirKey = 'saveDir';
timingDirKey = 'timingDir';


% Load input data and input labels
load(dataPathVal);
% N subjects, V voxels (or statistics)
[N,V] = size(Data);

% Set the corresponding values to the keys.
rapidPTLibraryPathVal = {'~/PermTest/RapidPermTest'};
testingTypeVal = {'OneSample'};
subVal = {sub};  % Sampling Rate
TVal = {numPermutations}; % Number of Permutations.
maxRankVal = {N}; % Rank for estimating the low rank subspace
trainNumVal = {trainNum}; % Number of permutations for training.
maxCyclesVal = {3}; % Number of cycles for training.
iterVal = {30}; % Number of iterations for matrix completion.
writingVal = {1}; % 0 if only output maxnull or 1 if outputs maxnull, U and W
saveDirVal = {saveDir}; % Path to save outputs
timingDirVal = {timingDir}; % Path to save timing


inputs = struct(rapidPTLibraryPathKey, rapidPTLibraryPathVal,...
                            testingTypeKey, testingTypeVal,...
                            dataKey, Data,...
                            subKey, subVal,...
                            TKey, TVal,...
                            maxRankKey, maxRankVal,...
                            trainNumKey, trainNumVal,...
                            maxCyclesKey, maxCyclesVal,...
                            iterKey, iterVal,...
                            writingKey, writingVal,...
                            saveDirKey, saveDirVal,...
                            timingDirKey, timingDirVal);
            
outputs = OneSampleRapidPermutationTesting(inputs);

end

