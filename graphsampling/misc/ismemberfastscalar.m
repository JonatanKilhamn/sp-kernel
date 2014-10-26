function tf = ismemberfastscalar(L, A)
%ISMEMBERFASTSCALAR Check if any elements i L occurs in A

n = length(L);
tf = false(n,1);
for i = 1:n
    l = L(i);
    tf(i) = sum(l == A)>0;
end
end

