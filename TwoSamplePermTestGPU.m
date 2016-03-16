function [ tStatMatrix, maxT ] = TwoSamplePermTestGPU(data, dataSquared, permutationMatrix1, permutationMatrix2, nGroup1, nGroup2 )
%PermTestMatrixGPU 
%   Perform Permutation Testing using a matrix multiplication approach
%   instead of an iterative approach. Furthermore thanks to MATLAB's built
%   in gpuArray structure all operations happen in the GPU.
    
    dataDevice = gpuArray(data);
    dataSquaredDevice = gpuArray(dataSquared);
    permutationMatrix1Device = gpuArray(permutationMatrix1);
    permutationMatrix2Device = gpuArray(permutationMatrix2);

    g1MeanDevice = (permutationMatrix1Device * dataDevice)/nGroup1;
    g2MeanDevice = (permutationMatrix2Device * dataDevice)/nGroup2;
    g1VarDevice = (permutationMatrix1Device * dataSquaredDevice)/(nGroup1-1) - (g1MeanDevice.*g1MeanDevice);
    g2VarDevice = (permutationMatrix2Device * dataSquaredDevice)/(nGroup2-1) - (g2MeanDevice.*g2MeanDevice);
    tStatMatrixDevice = (g1MeanDevice - g2MeanDevice) ./ (sqrt((g1VarDevice./nGroup1) + (g2VarDevice./nGroup2)));
    maxTDevice = max(tStatMatrixDevice,1);
    
    % Bring Data back from the gpu.
    tStatMatrix = gather(tStatMatrixDevice);
    maxT = gather(maxTDevice);
end

