function gVec = EdgeSampler(am, al, k, gk)
%EDGESAMPLER Summary of this function goes here
%   Detailed explanation goes here

[ii, jj] = find(am);
edgeList = [ii, jj];
nbrEdges = size(edgeList,1);

switch gk    
    case 3
        nk = 2;
    case 4
        nk = 6;
    case 5
        nk = 21;
end

gVec = zeros(1,nk);

for i = 1:k
    % Sample edge
    iE = edgeList(randi(nbrEdges,1),:);
        
    switch gk
        case 3            
            c = ExploreNeighborhood3(am, al, iE(1), iE(2));            
        case 4
            c = ExploreNeighborhood4(am, al, iE(1), iE(2));            
        case 5
            c = ExploreNeighborhood5(am, al, iE(1), iE(2));            
    end
        
    
    gVec = gVec + c;
end

gVec = gVec;% * nbrEdges / k;
end

