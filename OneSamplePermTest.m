%% OneSamplePermTestMatrix 
%   OneSample Permutation Testing to test for differences between a group
%   and a mean of zero. This means that the measurements given in data need
%   to be normalized such that their mean is 0.
%
%   INPUTS:
%           * data - NxV matrix (N = number of subjects, V number of
%           voxels)
%           * dataSquared - data.*data - We need this parameter because if
%           this function is called many times in one run we don't want to
%           compute that same operation many times.
%           * permutationMatrix - Outputs matrix of the function
%           OneSampleGetPermutationMatrices
%           * maxMemory - Maximum amount of memory you want to be used at
%           once by this function. Recommended between ~ 5e8 (500 megabytes)

function [ MaxT, tStatMatrix ] = OneSamplePermTest(data, dataSquared, permutationMatrix, maxMemory )
    
    [numPermutations, N] = size(permutationMatrix);
    V = size(data,2);
    numPermutationsPerIteration = GetIntervalLength(V, maxMemory);
    % Assume global mean is 0
    
    lastIteration = mod(numPermutations,numPermutationsPerIteration);
    numIterations = floor(numPermutations/numPermutationsPerIteration);
    
    MaxT = zeros(numPermutations,1);
    
    varTerm1 = repmat(sum(dataSquared),numPermutationsPerIteration,1)/N;
    for i = 1:numIterations
        startIndex = ((i-1)*numPermutationsPerIteration) + 1;
        endIndex = i*numPermutationsPerIteration;
        fprintf('Iteration %d , startIndex %d, endIndex %d out of %d \n', i, startIndex, endIndex, numPermutations);
        currPermMatrix = permutationMatrix(startIndex:endIndex, :);
        % Mean calculation
        sampleMean = currPermMatrix * data ./ N;

        % Standard deviation calculation calculation
        %sampleVar = ((abs(currPermMatrix) * dataSquared)/(N)) - (sampleMean.*sampleMean);
        sampleVar = varTerm1 - sampleMean.*sampleMean;
        tStatMatrix = (sampleMean) ./ (sqrt(sampleVar./(N-1))); 
        MaxT(startIndex:endIndex,1) = max(tStatMatrix,[],2);
    end
    if(lastIteration ~= 0)
        if(size(i, 1) == 0)
            startIndex = 1;
        else
            startIndex = ((i)*numPermutationsPerIteration) + 1;
        end
        % endIndex = startIndex + lastIteration;
        currPermMatrix = permutationMatrix(startIndex:end, :);
        sampleMean = currPermMatrix * data ./ N;
        % Standard deviation calculation calculation
        sampleVar = varTerm1(1:lastIteration,:) - (sampleMean.*sampleMean);   

        tStatMatrix = (sampleMean) ./ (sqrt(sampleVar./(N-1)));  
        MaxT(startIndex:end,1) = max(tStatMatrix, [],2);
    end

    
end

