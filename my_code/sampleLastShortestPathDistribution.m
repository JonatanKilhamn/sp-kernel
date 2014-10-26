function sampledDistribution = ...
    sampleLastShortestPathDistribution(shortestPathMatrix, nSamples)

% takes a shortest path matrix, i.e. from floyd-warshall
% and a wanted number of samples
% returns a distribution P of sampled shortest path lengths

I=triu(~(isinf(shortestPathMatrix)));
Ind=shortestPathMatrix(I)+1; % some shortest paths will equal 0,
% so we have to add 1 to use them as indices of features

nPaths = length(Ind);
nSamples = min(nPaths, nSamples);

% randomly choose m values:             (m=nSamples)
samples = randperm(nPaths,nSamples);

% only use the sampled values:
counts = accumarray(Ind(samples),ones(nSamples,1));

sampledDistribution = counts ./ sum(counts);

% length of P will be 1+[maximum shortest path length found]
% (would be even longer if negative weights were allowed)