function al = createAdjListWrapper(am)

[ii, jj] = find(am);
[~, idx] = sort(ii);
ii = ii(idx);
jj = jj(idx);
el = [ii, jj];
maxDeg = max(full(sum(am)));
n = size(am,1);
al = createAdjListFromEdgeList(n, el, maxDeg);
end

