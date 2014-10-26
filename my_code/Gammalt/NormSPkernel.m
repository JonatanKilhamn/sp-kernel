function [K, runtime, Ds] = NormSPkernel(Graphs)
% Compute normalised shortest path length kernel for a set of graphs (by
% exact matching of shortest path lengths)
% Copyright 2012 Nino Shervashidze
% Input:
%   Graphs - a 1xN array of graphs represented just with adjacency
%     matrices. Graphs(i).am is the i'th adjacency matrix. Graphs(i) may
%     have other fields, but they will not be considered by this script
% Output:
%   K - nxn kernel matrix K
%   runtime - scalar
%   Ds - cell array of shortest path distance matrices for all graphs


N=size(Graphs,2);
Ds = cell(1,N); % shortest path distance matrices for each graph

t=cputime; % for measuring runtime

% compute Ds and the length of the maximal shortest path over the dataset
% also store n^2 for each graph
sizes = zeros(1,N);
maxpath=0;
for i=1:N
  Ds{i}=floydwarshall(Graphs(i).am);
  aux=max(Ds{i}(~isinf(Ds{i})));
  if aux > maxpath
    maxpath=aux;
  end
  sizes(i) = length(Graphs(i).am);
 % if rem(i,100)==0 disp(i); end
 disp(['Finished F-W on graph ', num2str(i), ' out of ', num2str(N)]);
end
disp(['the preprocessing step took ', num2str(cputime-t), ' sec']);

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

% normalise

%aux = repmat(sizes,N,1);
%normfacs = 1./(aux'*aux);
%K = K.*normfacs;
runtime=cputime-t;
disp(['kernel computation took ', num2str(cputime-t), ' sec']);
end

