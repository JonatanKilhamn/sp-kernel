function [D] = floydwarshall_mod(A, sym, w)
% % Copyright 2012 Nino Shervashidze
% Input: A - nxn adjacency matrix,
%           sym - boolean, 1 if A and w symmetric
%	    w - nxn weight matrix
% Output: D - nxn distance matrix

n = size(A,1); % number of nodes

if nargin <= 2 % if the graph is not weighted and we have no information about sym, then 
  sym=1;
end

if nargin <= 3 % if the graph is not weighted, then
  w=A;
end


D = Inf(n,n); % If A(i,j)==0 and i~=j D(i,j)=Inf;
filter = A~=0; % if A(i,j)=1...
D(filter) = w(filter); % ... then D(i,j)=w(i,j);
for i=1:n
    D(i,i)=0; % set the diagonal to zero
end

%t=cputime;
if sym % then it is a bit faster
    for k=1:n
        disp(['Step ', num2str(k), ' out of ', ...
            num2str(n), ' of F-W']);
        Daux=repmat(full(D(:,k)),1,n);
        Sumdist=Daux+Daux';
        D(Sumdist<D)=Sumdist(Sumdist<D);
    end
else
    for k=1:n
        disp(['Step ', num2str(k), ' out of ', ...
            num2str(n), ' of F-W']);
        Daux1=repmat(full(D(:,k)),1,n);
        Daux2=repmat(full(D(k,:)),n,1);
        Sumdist=Daux1+Daux2;
        D(Sumdist<D)=Sumdist(Sumdist<D);
    end
end
%cputime-t
end
