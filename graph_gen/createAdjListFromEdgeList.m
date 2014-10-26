function al = createAdjListFromEdgeList(n, el, maxDeg)
%CREATEADJLISTEDGE Create adjacency list from edge list

al = cell(n,1);
iter = 1;
nbrEl = size(el,1);
for i = 1:n
    % Find all occurences of node i
    lookAhead = min([iter+maxDeg, nbrEl]); 
    
    edges = el(iter:lookAhead,1);         
    nbrEdges = sum(edges == i);
    al{i} = el(iter:iter+nbrEdges-1,2)';
    iter = iter + nbrEdges;    
end
end

