function [d, ops] = dijkstra_heap_m(am, source, goal)

am_3col = sparse_to_3col(am);
n = size(am, 1);
[d, ~, ops] = dijkstra_heap_count(am_3col', n, source, goal);
if d > n*100
    d = Inf;
end
% the reason for the transpose in the call is that C indexes matrices
% by column, so for easier-to-understand C code I wanted to have
% each edge triple (start, end, weight) as a column rather than a row