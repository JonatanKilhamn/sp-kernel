function [freq, t] = SampleGraphlets(al, am, k, n, method, varargin)
% SAMPLEGRAPHLETS Samples connected graphlets.
%   [FREQ, T] = SAMPLEGRAPHLETS(DATA, K, N, METHOD, VARARGIN) samples N
%   connected graphlets from the graph specified in AL and AM. K is the 
%   size of the graphlet to sample, allowed values of K are 3,4,5. N is the
%   number of samples. The METHOD argument specifies which smapling method 
%   to choose from. Options are:
%       ars: Acceptance-Rejection sampling. Brute force. Gives the best reults but takes
%       longest time, especially for sparse graphs.
%       mhs: Metropolis-Hastings sampling. Uses MCMC sampling. Almost as
%       good results as ARS but faster. The mixing time tMix and adjacency 
%       matrix am must be specified as additional option.
%       rve: Random Vertex sampling. The absolutly worst due to the
%       heavy bias towards graphlets with high local clustering. Runs
%       fastest though,
%       nrs: Neighbor Resevoir sampling. A mix of rve ans mhs. Still has
%       bias problems, but better than rvs. Takes medium time.
%   The output FREQ is the frequecy vector of the sampled graphlets. T is
%   the runtime of the sampling. 

switch lower(method)   
    case 'ars'
        sfunc = @AcceptReject;
    case 'mhs'
        if length(varargin) ~= 1
            error('Error! Mixing time tMix is not properly specified')
        else
            tMix = varargin{1};           
        end
        sfunc = @(al, am, k) MetropolisHastingsSampling(al, am, k, tMix);        
    case 'rve'
        sfunc = @RandomVertexExpansion;        
    case 'nrs'       
        sfunc = @NeighborResevoirSampling;

end

% Only support for k = 3,4,5
switch k
    case 3 
        freq = zeros(1,2);
    case 4
        freq = zeros(1,6);
    case 5
        freq = zeros(1,21);
end

t0 = cputime;
for i = 1:n            
    vSet = sfunc(al, am, k);
    type = GetGraphletType(vSet, am(vSet, vSet), k);    
    freq(type) = freq(type) + 1;
end
t = cputime - t0;
