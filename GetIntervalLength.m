function [ length ] = GetIntervalLength(nVoxels, maxMemory)
%GetIntervalLength Summary of this function goes here
%   Get you the number of permutations you want to do at a time when matrix
%   multiplying, given the maximum amount of memory you can use.

    sizeOfDouble = 8; % Number of bytes in a double;
    totalMemoryPerCol = nVoxels * sizeOfDouble; % Total memory taken by a permutation column
    numPermutationsPerInterval = maxMemory/totalMemoryPerCol;
    
    length = floor(numPermutationsPerInterval);

end

