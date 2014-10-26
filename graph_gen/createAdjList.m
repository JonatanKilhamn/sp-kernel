function al = createAdjList(am)
%CREATEADJLIST creates adjacency list from adjecency matrix
%   am is sparse n x n adjacency matrix, al is n x 1 cell array
%   author: Otto

n = size(am,1);
al = cell(n,1);

for i = 1:n
    al{i} = full(find(am(i,:)));
end
end

