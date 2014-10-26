function shortestPathDistrMatrix = ...
    shortestPathDistrMatrix(shortestPathDistributions)

maxpath = 0;
N = length(shortestPathDistributions);
for i = 1:N
    aux = length(shortestPathDistributions{i});
    if aux > maxpath
        maxpath = aux;
    end
end

shortestPathDistrMatrix = zeros(N, maxpath);
for i = 1:N
    len = length(shortestPathDistributions{i});
    shortestPathDistrMatrix(i, 1:len) = shortestPathDistributions{i};
end

% shortestPathDistributions should be something like cell(1, N)


% takes a cell struct of shortest path distance matrices, one for each of
% N graphs
% returns one shortest path distribution matrix, of size N-by-m, where m
% is the maximum shortest-path length among them

