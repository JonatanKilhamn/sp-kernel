function s = SingleDegreeDist(am, cdf0)
l = full(sum(am,2));
m = length(cdf0) - 1;
d = 0:m;

dd = histc(l, d);
dd = dd ./ sum(dd);
cdf1 = cumsum(dd);

s = max(abs(cdf0 - cdf1));

end

