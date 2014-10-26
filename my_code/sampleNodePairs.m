function pairs = sampleNodePairs(nNodes, nPairs)

% takes a graph (no. of nodes) and a number of samples M, returning
% M pairs of nodes

%pairs = randi(nNodes, [nPairs, 2]);
pairs = zeros(nPairs, 2);

for i = 1:nPairs
    pairs(i, 1) = randi(nNodes);
    pairs(i, 2) = randi(nNodes);
    while pairs(i, 1) == pairs (i, 2)
        pairs(i, 2) = randi(nNodes);
    end
end
% note: this will sample node pairs so that the probabilities of choosing
% the pair (m,n) and (n,m) are both equal to that of (m,m), meaning the
% zero-distance pairs will be sampled half as often on average. Compare
% this to the current implementation of the standard kernel, which
% uses the upper triangle of the complete distance matrix.
% TODO: fix this, or else remember to remark upon it in the report. It
% would affect error levels, since even nSamples -> Inf would not approach
% the 'correct' kernel value.

