function d = dijkstra_voronoi(am, source, goal, grouping, ...
    voronoiAdjacencyMatrix)
% Computes the approximate distance between two nodes, given the original
% cost matrix and the voronoi preprocessing

nVor = size(voronoiAdjacencyMatrix, 1);
vorSource = grouping(source);
vorGoal = grouping(goal);

vorAm_3col = sparse_to_3col(voronoiAdjacencyMatrix);
%[d, pi, dist, heap_index] = dijkstra_heap(vorAm_3col', nVor, vorSource, ...
%    vorGoal);
[~, vorPath] = dijkstra_heap(vorAm_3col', nVor, vorSource, ...
    vorGoal);

n = size(am, 1);
allNodes = 1:n;
vorSleeve = allNodes(ismember(grouping, vorPath));
amFull = full(am);
amSleeve = sparse(amFull(vorSleeve, vorSleeve));
amSleeve_3col = sparse_to_3col(amSleeve);

newSize = size(amSleeve, 1);
newSource = find(vorSleeve == source);
newGoal = find(vorSleeve == goal);

%TODO: find new size

[d, ~] = dijkstra_heap(amSleeve_3col', newSize, newSource, newGoal);

% the reason for the transpose in the call is that C indexes matrices
% by column, so for easier-to-understand C code I wanted to have
% each edge triple (start, end, weight) as a column rather than a row