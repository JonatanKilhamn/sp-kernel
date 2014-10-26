function neighbors = GetNeighbors(al, vSet)

neighbors = unique([al{vSet}]);
neighbors(ismembc(neighbors, sort(vSet))) = [];
      
end