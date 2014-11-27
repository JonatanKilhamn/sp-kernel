function [vorAdj, grouping] = voronoi_preprocessing(adjacencyMatrix, ...
    voronoiDensity)

graph_am_3col = sparse_to_3col(adjacencyMatrix);

n = size(adjacencyMatrix, 1);

 

allNodes = 1:n;
vorNodes = zeros(0);
while isempty(vorNodes)
    vorNodes = allNodes(rand(n, 1) < voronoiDensity);
end
[grouping, vorAdj] = voronoi(graph_am_3col', n, vorNodes);

threshold = sum(sum(adjacencyMatrix)) + 1;
%vorAdj(vorAdj == 1000000000) = 0;
vorAdj(vorAdj > threshold) = 0;
