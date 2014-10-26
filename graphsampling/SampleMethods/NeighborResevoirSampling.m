function V = NeighborResevoirSampling(al, am, k)
%NEIGHBORRESEVOIRSAMPLING Samples subgraphs according to the NRS algorithm
%   Detailed explanation goes here

% Get initial vSet by RVS
V = RandomVertexExpansion(al, am, k);

% Find all possible connected edges to the vertices in V
procV = V;
EL = GetNewEdges(V, al, procV);
i = k;
while ~isempty(EL)
    i = i + 1;
    nEL = size(EL,1);
    uIdx = randi(nEL);
    e = EL(uIdx,:);
    v = e(~ismember(e,V));
    procV(end+1) = v;
    alpha = rand;
    if alpha < i/k
        uIdx = randi(k);        
        Vp = V;
        Vp(uIdx) = v;
        if isconnected(am(Vp, Vp))
            V = Vp;
        end
    end
    EL = GetNewEdges(V, al, procV);
end

end

function EL = GetNewEdges(V, al, procV)

nNeighborEdges = sum(cellfun(@length, al(V)));
EL = zeros(nNeighborEdges,2);
idx = 1;
k = length(V);
for i = 1:k
    v = V(i);
    a = al{v};
    a(ismember(a,procV)) = []; % Remove vertices already processed
    tmpList(:,2) = a';
    tmpList(:,1) = v;
    nNewEdges = size(tmpList,1);
    newIdx = idx + nNewEdges-1;
    EL(idx:newIdx,:) = tmpList;
    
    idx = newIdx + 1; 
    tmpList(:) = [];
end

rmIdx = find(~EL, 1, 'first');
EL(rmIdx:end,:) = [];

end