function [kernelValues, distributions, ops] = voronoiKernel(Graphs, nSamples, groupings, ...
    voronoiAdjacencyMatrices)
% Compute normalised shortest path length kernel for a set of graphs (by
% sampling a number of node pairs, computing the shortest path lengths 
% for those pairs, and using the results as an approximate distribution)
%
% Input:
%   Graphs - a 1xN array of graphs represented just with adjacency
%     matrices. Graphs(i).am is the i'th adjacency matrix. Graphs(i) may
%     have other fields, but they will not be considered by this script
%   nSamples - optional; the number of samples to use; defaults to
%     the value of getNSamples(0.1, 0.1) if left empty or given as 0.
% Output:
%   kernelValues - nxn kernel matrix, often denoted K (or K*, in relation
%     to the exact K)


N=length(Graphs);

%% Argument inference

% Find the number of samples (if not supplied)
if nargin < 2 || nSamples == 0
    nSamples = getNSamples();
end



%% find sampled shortest path distributions

shortestPathDistributions = cell(1,N);

ops = 0;
for i=1:N
    % Using cost matrices full of Inf:
    % shortestPathDistributions{i} = ...
    %    sampleFirstShortestPathDistribution(costMatrices{i}, nSamples);
    
    % Using sparse cost matrices:
    [shortestPathDistributions{i}, opsTemp] = ...
        sampleFirstShortestPathDistribution(Graphs(i).am, nSamples, ...
        1, groupings{i}, voronoiAdjacencyMatrices{i});
    ops = ops + opsTemp;
    
    %disp(['Completed graph ' num2str(i) ' out of ' num2str(N)])
end

%% compute kernel values

kernelValues = shortestPathDeltaKernels(shortestPathDistributions);
distributions = shortestPathDistributions;
end

