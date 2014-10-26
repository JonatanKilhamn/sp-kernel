function [ vSet ] = ForestFire( al, pf, desired_size )
%FORESTFIRE Forest fire sampling of graphs
%   Detailed explanation goes here

% start at random vertex
visited = [];
n = length(al);
vStart = randi(n);

while n -length(visited) > desired_size
    %n = length(al);
    while any( visited == vStart )
        vStart = randi(n);
    end
    visited = ForestFireRecurse( vStart, al, pf,  visited, [] );
    al(visited) = {[]};
end
fprintf('Deleted %d vertices\n',length(visited));
visited(visited==0) = [];
vSet = 1:n;
vSet(ismembc(vSet,sort(visited))) = [];


