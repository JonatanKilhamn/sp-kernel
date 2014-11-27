function sampledDistribution = ...
    sampleLastShortestPathDistribution(shortestPathMatrix, nSamples)

N = size(shortestPathMatrix, 1);

% takes a shortest path matrix, i.e. from floyd-warshall
% and a wanted number of samples
% returns a distribution P of sampled shortest path lengths

I=triu(~(isinf(shortestPathMatrix)), 1); % The "1" means that we do not
                                         % allow any samples from the
                                         % diagonal elements; i.e. paths
                                         % from an element to itself.
Ind=shortestPathMatrix(I)+1; % some shortest paths will equal 0,
% so we have to add 1 to use them as indices of features

nPaths = length(Ind);
nSamples = min(nPaths, nSamples);

% randomly choose m values:             (m=nSamples)
samples = randperm(nPaths,nSamples);

% only use the sampled values:
counts = accumarray(Ind(samples),ones(nSamples,1));

% add the expected number of samples from the diagonal:
counts(1) = counts(1) + nSamples/(N-1);

sampledDistribution = counts ./ sum(counts);

% length of P will be 1+[maximum shortest path length found]
% (would be even longer if negative weights were allowed)