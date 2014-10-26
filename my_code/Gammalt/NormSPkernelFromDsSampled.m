function [K, runtime,aux,m] = NormSPkernelFromDsSampled(Ds, varargin);%epsilon, delta)
% Compute normalised shortest path length kernel for a set of graphs (by exact matching
% of shortest path lengths)
% Copyright 2012 Nino Shervashidze
% Input: Graphs - a 1xN array of graphs represented just with adjacency matrices
% 	 Graphs(i).am is the i'th adjacency matrix
%        Graphs(i) may have other fields, but they will not be considered by this script
%        epsilon - the sought error in the kernel value
%        delta - the probability with which the error will be larger than
%        epsilon
%        Note: if called with less than three arguments, the function will
%    use the default values for both epsilon and delta.
% Output: K - nxn kernel matrix K
%         runtime - scalar

%if (nargin < 3)
%    epsilon = 0.1;
%    delta = 0.05;
%end
%m = ceil((15*log(2) + log(1/(1-sqrt(1-delta))))/(2*epsilon));
m = 0;
epsilon = 0;
delta = 0;

for i = 1:(length(varargin)/2)
    if (varargin{2*i-1} == 'm')
        m = varargin{2*i};
    end
    if (varargin{2*i-1} == 'e')
            epsilon = varargin{2*i};
    end
    if (varargin{2*i-1} == 'd')
        delta = varargin{2*i};
    end
end

if (m == 0)
    if (epsilon == 0)
        epsilon = 0.1;
    end
    if (delta == 0)
        delta = 0.05;
    end
    m = ceil((15*log(2) + log(1/(1-sqrt(1-delta))))/(2*epsilon));
end

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
    sz = nnz(I);
    nbrOfSamples = min(sz,m);
	
    % randomly choose m values:
    samples = randperm(sz,nbrOfSamples);

    % only use the sampled values:
    aux=accumarray(Ind(samples),ones(nbrOfSamples,1));
    aux = aux ./ sum(aux);
    aux = [aux; zeros(maxpath+1-length(aux),1)];
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

