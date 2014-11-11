function [vorAdj, grouping] = voronoi_preprocessing(
%graph = DD(1);
graph = ROADS(1);

graph_am_3col = sparse_to_3col(graph.am);

n = size(graph.am, 1);

 
for i = 1:100
    %disp(num2str(i));
    vorNodes = randperm(n, ceil(n*0.1));
    [grouping, vorAdj] = voronoi(graph_am_3col', n, vorNodes);
end
vorAdj(vorAdj == 1000000000) = 0;

vorAdjSparse = sparse(vorAdj);

 source=5;
 goal=7;
 [distance, shortestPath] = dijkstra_heap(graph_am_3col', n, source, goal);


% for source = 1:n
%     for goal = 1:n
%         d1 = dijkstra_heap(dd1_am_3col', n, source, goal);
%         %[~, d2] = dijkstra(DD(1).am, source, goal);
%         %if d1 ~= d2
%         %    disp('Failed')
%         %end
%     end
%     disp(['Finished with source = ' num2str(source) ...
%         ' out of ' num2str(n)])
% end
