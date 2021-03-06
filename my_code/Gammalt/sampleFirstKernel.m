function kernelValues = sampleFirstKernel(Graphs, nSamples, ...
    ~) %costMatrices)
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
%   costMatrices - a 1xN array of cost matrices for the graphs; in the
%   format where "no connection" is denoted by Inf. Needed for one
%   implementation of Dijkstra's, but currently (2014-10-07) unused.
%   dijkstra - a string denoting which implementation of dijkstra's
%     algorithm to use. Alternatives are 'linear' and 'heap'
% Output:
%   kernelValues - nxn kernel matrix, often denoted K (or K*, in relation
%     to the exact K)


N=size(Graphs,2);

%% Argument inference

% Find the number of samples (if not supplied)
if nargin < 2 || nSamples == 0
    nSamples = getNSamples();
end

% Find dijkstra implementation
if nargin < 3
    dijkstra = 'linear';
end


%% Find the costMatrix

% if nargin < 3
%     
%     costMatrices = cell(1,N);
%     
%     for i=1:N
%         
%         adjacencyMatrix = Graphs(i).am;
%         n = size(adjacencyMatrix, 1);
%         
%         if (ismember('el', fieldnames(graph)))
%             %TODO: handle graphs with distance labels, i.e. not all distances
%             % are 1
%         end
%         
%         costMatrix = Inf(n,n); % If A(i,j)==0 and i~=j D(i,j)=Inf;
%         filter = adjacencyMatrix~=0; % if A(i,j)=1...
%         costMatrix(filter) = adjacencyMatrix(filter); % ... then D(i,j)=w(i,j);
%         for j=1:n
%             costMatrix(j,j)=0; % set the diagonal to zero
%         end
%         
%         
%         costMatrices{i}=costMatrix;
%         % if rem(i,100)==0 disp(i); end
%         disp(['Finished cost matrix calculation on graph ' num2str(i) ...
%             ' out of ', num2str(N)]);
%     end
% end



%% find sampled shortest path distributions

shortestPathDistributions = cell(1,N);


for i=1:N
  % Using cost matrices full of Inf:
  % shortestPathDistributions{i} = ...
  %    sampleFirstShortestPathDistribution(costMatrices{i}, nSamples);
  
  % Using sparse cost matrices:
  shortestPathDistributions{i} = ...
     sampleFirstShortestPathDistribution(Graphs(i).am, nSamples, ...
     dijkstra);
  
  disp(['Completed graph ' num2str(i) ' out of ' num2str(N)])
end

%% compute kernel values 

kernelValues = shortestPathDeltaKernels(shortestPathDistributions);

end

