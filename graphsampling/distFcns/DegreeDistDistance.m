function [q, s1, s2] = DegreeDistDistance(am1, am2, cdf0, p)
%DEGREEDISTDISTANCE Degree distribution distance metric
%   TBA

s1 = SingleDegreeDist(am1, cdf0);
s2 = SingleDegreeDist(am2, cdf0);

% % Create lists of degree sequence
% l1 = cellfun('length', al1);
% l2 = cellfun('length', al2);
% 
% m = length(cdf0); 
% 
% d = 0:m-1;
% ds1 = histc(l1, d);
% ds2 = histc(l2, d);
% 
% dd1 = ds1 ./ sum(ds1);
% dd2 = ds2 ./ sum(ds2);
% 
% cdf1 = cumsum(dd1);
% cdf2 = cumsum(dd2);
% 
% % D - Statistic
% [m1, d1] = max(abs(cdf0 - cdf1));
% [m2, d2] = max(abs(cdf0 - cdf2));

q = (s1/s2)^p;

end

