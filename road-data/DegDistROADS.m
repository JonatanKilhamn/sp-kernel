load ROADS

n = length(ROADS);
n0 = length(lroads == 0);
n1 = length(lroads == 1);
maxDeg = MaxDeg(ROADS);

r0 = zeros(n0, maxDeg);
r1 = zeros(n1, maxDeg);

i0 = 1;
i1 = 1;
for i = 1:n
    iR = ROADS(i);
    am = iR.am;    
    ds = full(sum(am));
    dd = histc(ds, 0:maxDeg-1);
    dd = dd ./ sum(dd);
    
    if lroads(i)
        r1(i1,:) = dd;
        i1 = i1 + 1;
    else
        r0(i0,:) = dd;
        i0 = i0 + 1;
    end
    
end

r0m = mean(r0);
r1m = mean(r1);

plot(0:maxDeg-1, r0m, 0:maxDeg-1, r1m)