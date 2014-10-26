function [K, runtime, Ds, maxpath] = NormSPkernelSampled(Graphs, varargin);%epsilon, delta)
% Compute normalised shortest path length kernel for a set of graphs (by
% matching of sampled shortest path length distributions)
% Copyright 2012 Nino Shervashidze
% Input:
%    Graphs - a 1xN array of graphs represented just with adjacency
%      matrices. Graphs(i).am is the i'th adjacency matrix. Graphs(i) may
%      have other fields, but they will not be used by this script
%    m - the number of samples; if provided, epsilon and delta are not
%      needed
%    epsilon - the sought error in the kernel value
%    delta - the probability with which the error will be larger than
%      epsilon
%    Note: if called with less than three arguments, the function will
%    use the default values for both epsilon and delta.
% Output: K - n x n kernel matrix K
%         runtime - scalar

%if (nargin < 3)
%    epsilon = 0.1;
%    delta = 0.05;
%end
%m = ceil((15*log(2) + log(1/(1-sqrt(1-delta))))/(2*epsilon));
m = 0;
epsilon = 0;
delta = 0;
for (i = 1:((length(varargin)-1)/2))
    if (varargin{2*i} == 'm')
        m = varargin{2*i+1};
    end
    if (varargin{2*i} == 'e')
            epsilon = varargin{2*i+1};
    end
    if (varargin{2*i} == 'd')
        delta = varargin{2*i+1};
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

N=size(Graphs,2);
Ds = cell(1,N); % shortest path distance matrices for each graph
if nargin<3 features=0; end

t=cputime; % for measuring runtime

% compute Ds and the length of the maximal shortest path over the dataset
maxpath=0;
for i=1:N
    Ds{i}=floydwarshall(Graphs(i).am);
    aux=max(Ds{i}(~isinf(Ds{i})));
    if aux > maxpath
        maxpath=aux;
    end
    % if rem(i,100)==0 disp(i); end
    disp(['Finished F-W on graph ', num2str(i), ' out of ', num2str(N)]);
end
disp(['the preprocessing step took ', num2str(cputime-t), ' sec']);

sp=sparse((maxpath+1),N);
for i=1:N
    aux = zeros(maxpath+1, 1);
    
    I=triu(~(isinf(Ds{i})));
    Ind=Ds{i}(I)+1; % some shortest paths will equal 0, so we have to
    % add 1 to use them as indices of features
    sz = nnz(I);
    nbrOfSamples = min(sz,m);
	
    % randomly choose m values:
    samples = randperm(sz,nbrOfSamples);

    % only use the sampled values:
    accumulatedSamples = accumarray(Ind(samples),ones(nbrOfSamples,1));
    aux = aux + [accumulatedSamples; 
        zeros(maxpath+1-length(accumulatedSamples),1)];
    aux = aux ./ sum(aux);
    sp(:, i)=aux;
end
K=full(sp'*sp);

runtime=cputime-t;
disp(['kernel computation took ', num2str(cputime-t), ' sec']);
end

