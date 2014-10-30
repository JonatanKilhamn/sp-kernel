function d = dijkstra_heap(am, source, goal)

am_3col = sparse_to_3col(m);
n = size(am, 1);
d = dijkstra_matlab(am_3col', n, source, goal); % the transpose is important