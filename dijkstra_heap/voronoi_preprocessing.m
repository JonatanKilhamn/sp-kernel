function [vorAdj, grouping] = voronoi_preprocessing(adjacencyMatrix, ...
    voronoiDensity)

graph_am_3col = sparse_to_3col(adjacencyMatrix);

n = size(adjacencyMatrix, 1);

 
for i = 1:100
    %vorNodes = randperm(n, ceil(n*voronoiDensity));
    allNodes = 1:n;
    vorNodes = allNodes(rand(n, 1) < voronoiDensity);
    [grouping, vorAdj] = voronoi(graph_am_3col', n, vorNodes);
end
threshold = sum(sum(adjacencyMatrix)) + 1;
%vorAdj(vorAdj == 1000000000) = 0;
vorAdj(vorAdj > threshold) = 0;
