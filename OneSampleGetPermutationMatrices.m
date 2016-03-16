function [ permutationMatrix ] = OneSampleGetPermutationMatrices(numPermutations, N)
%GetPermutationMatricesOneSample Summary of this function goes here
%   Detailed explanation goes here

    rng shuffle;
    permutationMatrix = zeros(numPermutations, N);
    for i = 1:numPermutations
       permutationMatrix(i,:) =  randsample([-1,1],N,true); 
    end
    
end

