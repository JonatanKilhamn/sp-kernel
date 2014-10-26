function tf = TstAl(al, am)
%TSTAL Summary of this function goes here
%   Detailed explanation goes here

n = length(al);
nz = sum(cellfun('length', al));
% Create al from am
ii = zeros(nz,2);
iter = 1;
for i = 1:n
    a = al{i};
    na = length(a);
    ii(iter:iter+na-1, 2) = a';
    ii(iter:iter+na-1, 1) = i;
    iter = iter + na;
end
nam = sparse(ii(:,1), ii(:,2), ones(size(ii(:,1))));
% tf = full(all(all(nam==am)));
end

