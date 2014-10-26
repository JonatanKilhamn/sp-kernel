function kernelValues = ...
    shortestPathDeltaKernels(shortestPathDistributions)
% takes a group of shortest path distributions
% returns a kernel value matrix

spDistrMat = shortestPathDistrMatrix(shortestPathDistributions);
% this handles distributions of varying lengths

kernelValues = spDistrMat*spDistrMat';

