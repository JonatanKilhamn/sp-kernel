function vSet = MetropolisHastingsSampling(al, am, k, tMix)
%MONTECARLOHASTINGS Summary of this function goes here
%   Detailed explanation goes here

[vSet, flag] = RandomWalk(al, k);

while flag % If fail
    [vSet, flag] = RandomWalk(al, k);
end

t = tMix;
while t > 0
    neighbors = GetNeighbors(al, vSet);
    
    % Node to swap
    idx = randi(k);
    v = vSet(idx);
    
    % New node
    nN = length(neighbors);
    idx2 = randi(nN);
    vNew = neighbors(idx2);
    
    vSetNew = vSet;
    vSetNew(idx) = vNew;
    
    amNew = am(vSetNew, vSetNew);
    if isconnected(amNew)        
        % Compare degrees
        maxDegV = max([cellfun('length', al(vSet))]);
        maxDegVNew = max([cellfun('length', al(vSetNew))]);
        
        degV = length(al{v});
        degVNew = length(al{vNew});
        
        alpha = rand;
        if alpha < (maxDegV/maxDegVNew)
            vSet(idx) = vNew;
        end
        t = t-1;        
    else
        % t = t-1;
        % t = t - round(1.00*rand);
        continue
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
        return
    end
    
end
end

function neighbors = GetNeighbors(al, vSet)

neighbors = unique([al{vSet}]);
neighbors(ismembc(neighbors, sort(vSet))) = [];
      
end