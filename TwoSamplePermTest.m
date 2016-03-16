%% TwoSamplePermTestMatrix 
%   TwoSample Permutation Testing to test for differences between two
%   groups, each group composed of nGroup1 and nGroup2 number of subjects
%   and we have V measurements from each subject.
%   INPUTS:
%           * data - NxV matrix (N = total number of subjects, V number of
%           voxels).
%           * dataSquared - data.*data - We need this parameter because if
%           this function is called many times in one run we don't want to
%           compute that same operation many times.
%           * permutationMatrix1, permutationMatrix2 - Outputs matrix of the function
%           TwoSampleGetPermutationMatrices
%           * nGroup1, nGroup2 - Number of subject in group 1 and group 2.
%           nGroup1 + nGroup2 = N ALWAYS
%           * maxMemory - Maximum amount of memory you want to be used at
%           once by this function. Recommended between ~ 5e8 (500 megabytes)

function [ MaxT, tStatMatrix ] = TwoSamplePermTest(data, dataSquared, permutationMatrix1, permutationMatrix2, nGroup1, nGroup2, maxMemory)

    numPermutations = size(permutationMatrix1, 1);
    V = size(data,2);
    numPermutationsPerIteration = GetIntervalLength(V, maxMemory);
    
    lastIteration = mod(numPermutations,numPermutationsPerIteration);
    numIterations = floor(numPermutations/numPermutationsPerIteration);
    
    MaxT = zeros(numPermutations,1);
    for i = 1:numIterations
        startIndex = ((i-1)*numPermutationsPerIteration) + 1;
        endIndex = i*numPermutationsPerIteration;
        fprintf('Iteration %d , startIndex %d, endIndex %d of %d \n', i, startIndex, endIndex, numPermutations);
        currPermMatrix1 = permutationMatrix1(startIndex:endIndex,:);
        currPermMatrix2 = permutationMatrix2(startIndex:endIndex,:);
        g1Mean = (currPermMatrix1 * data)/nGroup1;
        g2Mean = (currPermMatrix2 * data)/nGroup2;
        g1Var = (currPermMatrix1 * dataSquared)/(nGroup1) - (g1Mean.*g1Mean);
        g2Var = (currPermMatrix2 * dataSquared)/(nGroup2) - (g2Mean.*g2Mean);
        tStatMatrix = (g1Mean - g2Mean) ./ (sqrt((g1Var./(nGroup1-1)) + (g2Var./(nGroup2-1))));
        MaxT(startIndex:endIndex,1) = max(tStatMatrix,[],2);
    end
    if(lastIteration ~= 0)
        if(size(i, 1) == 0)
            startIndex = 1;
        else
            startIndex = ((i)*numPermutationsPerIteration) + 1;
        end
        %fprintf('Last Iteration %d , startIndex %d, endIndex %d of %d \n', i, startIndex, numPermutations, numPermutations);
        currPermMatrix1 = permutationMatrix1(startIndex:end,:);
        currPermMatrix2 = permutationMatrix2(startIndex:end,:);
        g1Mean = (currPermMatrix1 * data)/nGroup1;
        g2Mean = (currPermMatrix2 * data)/nGroup2;
        g1Var = (currPermMatrix1 * dataSquared)/(nGroup1) - (g1Mean.*g1Mean);
        g2Var = (currPermMatrix2 * dataSquared)/(nGroup2) - (g2Mean.*g2Mean);
        tStatMatrix = (g1Mean - g2Mean) ./ (sqrt((g1Var./(nGroup1-1)) + (g2Var./(nGroup2-1))));
        MaxT(startIndex:end,1) = max(tStatMatrix,[],2);        
    end

end

