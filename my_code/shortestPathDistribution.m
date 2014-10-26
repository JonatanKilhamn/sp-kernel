function distribution = shortestPathDistribution(shortestPathMatrix)

% takes a shortest path matrix, i.e. from floyd-warshall
% returns a distribution P of shortest path lengths


I=triu(~(isinf(shortestPathMatrix)));
Ind=shortestPathMatrix(I)+1; % some shortest paths will equal 0,
% so we have to add 1 to use them as indices of features
counts=accumarray(Ind,ones(nnz(I),1));
distribution = counts ./ sum(counts);

% length of P will be 1+[maximum shortest path length]
% (would be even longer if negative weights were allowed)