function sampledDistribution = ...
    sampleFirstShortestPathDistribution(costMatrix, nSamples)
% takes a graph, i.e. an adjacency matrix
% and a wanted number of samples
% returns a distribution P of sampled shortest path lengths
% calculated using Dijkstra's algorithm

if (nargin < 2)
    nSamples = getNSamples();
end

n = size(costMatrix, 1);
%n = size(graph.nl.values, 1);

nDiagonalSamples = ceil(nSamples/n);
nPairs = nSamples - nDiagonalSamples;

% this version sampled M pairs, but we need to keep sampling until we've
% found M non-Inf distances
%pairs = sampleNodePairs(n, nPairs);


% adjacencyMatrix = graph.am;
% if (ismember('el', fieldnames(graph)))
%     %TODO: handle graphs with distance labels, i.e. not all distances
%     % are 1
% end
% 
% costMatrix = Inf(n,n); % If A(i,j)==0 and i~=j D(i,j)=Inf;
% filter = adjacencyMatrix~=0; % if A(i,j)=1...
% costMatrix(filter) = adjacencyMatrix(filter); % ... then D(i,j)=w(i,j);
% for i=1:n
%     costMatrix(i,i)=0; % set the diagonal to zero
% end


if (~issparse(costMatrix))
    costMatrix = sparse(costMatrix);
end
shortestDistances = zeros(1, nSamples);
%for i = 1:nSamples
i = 1;
while i < nPairs+1 % the remaining "samples" are treated as being drawn from
    % the diagonal elements, i.e. the distances are zero
    
    sampledPair = sampleNodePairs(n, 1);
    
    
    % % C implementation, (c) Sebastien Paris (faster than the previous
    % % matlab one):
    % [~, shortestDistances(i)] = dijkstra(costMatrix, ...
    %     sampledPair(1), sampledPair(2));
    
    
    % C implementation using a heap (even faster?):
    shortestDistances(i) = dijkstra_heap_m(costMatrix, ...
        sampledPair(1), sampledPair(2));
    
    if ~isinf(shortestDistances(i))
        i = i+1;
    end
end

% remove all unreachable pairs (Inf distances)
shortestDistances = shortestDistances(~isinf(shortestDistances));

% add zero-length paths (no need to sample those since we know exactly how
% common they are)
shortestDistances = [zeros(1, nDiagonalSamples) shortestDistances];

% ensure that we base the distribution on the right number of samples
nSamples = length(shortestDistances);

counts=accumarray(shortestDistances'+1,ones(1, nSamples));
sampledDistribution = counts ./ sum(counts);

