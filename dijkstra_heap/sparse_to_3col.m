function m = sparse_to_3col(spm)
% To go from sparse matrix to three-column representation of the same

[a,b] = find(spm);
m = [b a full(spm(find(spm)))];

end