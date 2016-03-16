function [ tStatMatrix ] = OneSamplePermTest(data, dataSquared, permutationMatrix)
%PermTestOneSample2 Summary of this function goes here
%   Detailed explanation goes here

    [numPermutations, N] = size(permutationMatrix);
    % Assume global mean is 0

    % Mean calculation
    sampleMean = permutationMatrix * data ./ N;
    
    % Standard deviation calculation calculation
    sampleVar = ((abs(permutationMatrix) * dataSquared)/(N)) - (sampleMean.*sampleMean);
    
    tStatMatrix = (sampleMean) ./ (sqrt(sampleVar./(N-1)));
    % MaxT = max(tStatMatrix,[],2);
end

