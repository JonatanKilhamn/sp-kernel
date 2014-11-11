function kernelValues = sampleLastKernel(Graphs, nSamples, ...
    shortestPathMatrices)
% Compute normalised shortest path length kernel for a set of graphs (by
% computing all shortest path lengths and generating an approximate
% distribution by sampling from them)
%
% Input:
%   Graphs - a 1xN array of graphs represented by with adjacency
%     matrices. Graphs(i).am is the i'th adjacency matrix. Graphs(i) may
%     have other fields, but they will not be considered by this script
%   shortestPathMatrices - optional; a 1xN array of shortest path matrices
%     for the graphs, presumably achieved by floyd-warshal.
%   nSamples - optional; the number of samples to use; defaults to
%     the value of getNSamples(0.1, 0.1) if left empty or given as 0.
% Output:
%   kernelValues - nxn kernel matrix, often denoted K (or K*, in relation
%     to the exact K)


N=size(Graphs,2);

%% compute shortestPathMatrix for each graph (if not supplied)

if nargin < 3
    
    shortestPathMatrices = cell(1,N);
    
    for i=1:N
        shortestPathMatrices{i}=floydwarshall(Graphs(i).am);
        % if rem(i,100)==0 disp(i); end
        disp(['Finished F-W on graph ', num2str(i), ' out of ', num2str(N)]);
    end
end

% if they are supplied, they are probably from preprocessing using
% floyd-warshal results, stored in e.g. spDD

%% Find the number of samples (if not supplied)

if nargin < 2 || nSamples == 0
    nSamples = getNSamples();
end

%% turn shortest path matrices into distributions

shortestPathDistributions = cell(1,N);


for i=1:N
  shortestPathDistributions{i} = ...
      sampleLastShortestPathDistribution(shortestPathMatrices{i}, ...
      nSamples);
end

%% compute kernel values 

kernelValues = shortestPathDeltaKernels(shortestPathDistributions);

end

