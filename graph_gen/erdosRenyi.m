function G = erdosRenyi (n, p, varargin)
% ERDOSRENYI Generate the erdos-renyi random graph G(n, p)
%
% Usage: G = erdosRenyi (n, p)
%
% Returns
% -------
% G: the adjacency matrix for the generated graph
%
% Expects
% -------
% n: number of vertices in the graph
% p: the edge probability
%
%   Additions: Carl Retzner & Otto Frost (2014)
%

G = rand(n, n) < p;
G = triu(G, 1);
G = G + G';
% G = sparse(G);
if (~isempty(varargin))
    for i = 1:2:length(varargin)
        opt = lower(varargin{i});
        switch opt
            case 'edges'
                nbrEdges = varargin{i+1};
        end
    end
    currentNbrEdges = sum(sum(G))/2;
    while (currentNbrEdges ~= nbrEdges)
        [ii,jj] = find(G);
        edgelist = [ii, jj];
        if (currentNbrEdges > nbrEdges)
            % remove edge
            toBeDeleted = edgelist(randi(size(edgelist,1)),:);
            G(toBeDeleted(1),toBeDeleted(2)) = 0;
            G(toBeDeleted(2),toBeDeleted(1)) = 0;
        elseif (currentNbrEdges < nbrEdges)
            % add edge
            % TODO, kanske
            fprintf('ojoj, för många kanter \n');
        end
       
        currentNbrEdges = sum(sum(G))/2;
    end
end