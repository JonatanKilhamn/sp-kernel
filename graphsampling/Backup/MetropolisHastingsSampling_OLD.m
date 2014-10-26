function vSet = MetropolisHastingsSampling(al, k, tMix)
%MONTECARLOHASTINGS Summary of this function goes here
%   Detailed explanation goes here

% [vSet, flag] = RandomWalk(al, k);
% 
% while flag % If fail
%     [vSet, flag] = RandomWalk(al, k);
% end

vSet = RandomVertexExpansion(al, k);

t = tMix;
while t > 0
    neighbors = GetNeighbors(al, vSet);
    
    % Node to swap
    idx = randi(k);
    v = vSet(idx);
    neighbors(idx) = [];
    
    rmList = cellfun(@isempty, neighbors);
    nToRm = sum(rmList);
    neighbors(rmList) = [];
    
    % Select list of adjacent nodes
    if k-1-nToRm <= 0
        t = t -1;
        continue
    end
    
    idx2 = randi(k-1-nToRm);
    a = neighbors{idx2};
    nA = length(a);
    
    % Select node
    idx3 = randi(nA);
    vNew = a(idx3);
        
    % Compare degrees
    degV = length(al{v});
    degVNew = length(al{vNew});
    
    alpha = rand;
    if alpha < degV/degVNew
        vSet(idx) = vNew;
    end
    t = t-1;
    % Debug
%     if ~isconnected(vSet, al)
%         disp('error')
%     end
    if any(~vSet)
        disp('error')
    end
    
end

end


function [vSet, flag] = RandomWalk(al, k)
n = length(al);
idx = randi(n);
vSet = zeros(k,1);
vSet(1) = idx;
flag = false;

for i = 2:k
    a = al{vSet(i-1)};
    a(ismember(a, vSet)) = [];
    if ~isempty(a)
        iN = length(a);
        iIdx = randi(iN);
        vSet(i) = a(iIdx);
    else
        flag = true;
    end
    
end
end

function neighbors = GetNeighbors(al, vSet)

n = length(vSet);
neighbors = cell(n,1);
for i = 1:n
    a = al{vSet(i)};
    a(ismember(a,vSet)) = [];
    neighbors{i} = a;    
end

k = length(vSet);

for i = 1:k    
    for iN = 1:n
        a = neighbors{iN};
        nA = length(a);
        toRm = [];
        for iV = 1:nA
            vSetTmp = vSet; 
            vSetTmp(i) = a(iV);
            if ~isconnected(vSetTmp, al)
                toRm(end+1) = iV;                
            end            
        end
        a(toRm) = [];
        neighbors{iN} = a;
    end
end
      
end