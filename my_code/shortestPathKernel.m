function kernelValues = shortestPathKernel(Graphs, shortestPathMatrices)
% Compute normalised shortest path length kernel for a set of graphs (by
% exact matching of shortest path lengths)
%
% Input:
%   Graphs - a 1xN array of graphs represented just with adjacency
%     matrices. Graphs(i).am is the i'th adjacency matrix. Graphs(i) may
%     have other fields, but they will not be considered by this script
%   shortestPathMatrices - optional; a 1xN array of shortest path matrices
%     for the graphs, presumably achieved by floyd-warshal.
% Output:
%   kernelValues - nxn kernel matrix (often denoted K)


N=size(Graphs,2);

t=cputime; % for measuring runtime

%% compute shortestPathMatrix for each graph (if not supplied)

if nargin < 2
    
    shortestPathMatrices = cell(1,N);
    
    for i=1:N
        shortestPathMatrices{i}=findShortestPaths(Graphs(i));
        % if rem(i,100)==0 disp(i); end
        disp(['Finished F-W on graph ', num2str(i), ' out of ', num2str(N)]);
    end
end

% if they are supplied, they are probably from preprocessing using
% floyd-warshal results, stored in e.g. spDD


%% turn shortest path matrices into distributions

shortestPathDistributions = cell(1,N);

for i=1:N
  shortestPathDistributions{i} = ...
      shortestPathDistribution(shortestPathMatrices{i});
  disp(['Finished graph ' num2str(i) ' out of ' num2str(N)])
end

%% compute kernel values 

kernelValues = shortestPathDeltaKernels(shortestPathDistributions);

end

