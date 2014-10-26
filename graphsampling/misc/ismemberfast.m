function tf = ismemberfast(L, v)
%ISMEMBERFAST Check if vector v existis in list L
%  L is n x k
%  v is 1 x k
n = size(L,1);
tf = false(n,1);
for i = 1:n
    vt = L(i,:);
    tf(i) = isequal(vt,v);
end

end

