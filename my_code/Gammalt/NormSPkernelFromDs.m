function [K, runtime] = NormSPkernelFromDs(Ds)
% Compute shortest path length kernel for a set of graphs (by exact matching
% of shortest path lengths)
% Copyright 2012 Nino Shervashidze
% Input: Graphs - a 1xN array of graphs represented just with adjacency matrices
% 	 Graphs(i).am is the i'th adjacency matrix
%        Graphs(i) may have other fields, but they will not be considered by this script
% Output: K - nxn kernel matrix K
%         runtime - scalar


N=length(Ds);

t=cputime; % for measuring runtime

% compute the length of the maximal shortest path over the dataset
maxpath=0;
for i=1:N
  aux=max(Ds{i}(~isinf(Ds{i})));
  if aux > maxpath
    maxpath=aux;
  end
end

sp=sparse((maxpath+1),N);
for i=1:N
  I=triu(~(isinf(Ds{i})));
  Ind=Ds{i}(I)+1; % some shortest paths will equal 0, so we have to
                  % add 1 to use them as indices of features
  aux=accumarray(Ind,ones(nnz(I),1));
  aux = aux ./ sum(aux);
  sp(Ind,i)=aux(Ind);
end
K=full(sp'*sp);
runtime=cputime-t;
disp(['kernel computation took ', num2str(cputime-t), ' sec']);
end

