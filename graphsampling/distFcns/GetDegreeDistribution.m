function dd = GetDegreeDistribution(al)
%GETDEGREEDISTRIBUTION Summary of this function goes here
%   Detailed explanation goes here

% Create lists of degree sequence
l = cellfun('length', al);

% Find maximum degree 
m = max(l); 

d = 0:m;
ds = histc(l, d);
dd = ds ./ sum(ds);
end

