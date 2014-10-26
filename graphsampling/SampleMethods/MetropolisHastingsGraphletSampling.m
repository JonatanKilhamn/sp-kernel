function vSet = MetropolisHastingsGraphletSampling(am, al, k, tMix, p)
%METROPOLISHASTINGSGRAPHLETSAMPLING Combination of alg. 3 and 4

[vSet, flag] = RandomWalk(al, k);

while flag 
    [vSet, flag] = RandomWalk(al, k);
end



end

function neighbors = GetNeighbors(al, vSet)

neighbors = unique([al{vSet}]);
neighbors(ismembc(neighbors, sort(vSet))) = [];
      
end