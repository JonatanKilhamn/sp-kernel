function q = MaxDegreedistance(am1, al1, am2, al2)
%MAXDEGREEDISTANCE Maximum degree distance
%   TBA

l1 = cellfun('length', al1);
l2 = cellfun('length', al2);

m1 = max(l1);
m2 = max(l2);

q = m1/m2;

end

