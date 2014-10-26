function [gDist, nbrGraphlets]  = LargeGraphSampler(am, al, k, gk, t, p)
%LARGEGRAPHSAMPLER Samples large subgraph from larger graph
%Input:     am      adjacency matrix        n x n sparse
%           al      adjacency list          n x 1 cell
%           k       number of nodes         1 x 1 interger
%           gk      graphlet type           1 x 1 interger in {3, 4, 5}
%           t       mixing time             1 x 1 interger
%           p       mcmc exponenent         1 x 1 double 
%Output:    gDist   graphlet distribution   1 x k double
%           nbrGraphlet number of graphlets 1 x 1 int

% switch lower(method)
%     case 'ff' 
%         pf = varargin{1};
%         sampler = @(al) ForestFire(al, pf, k);
%     case 'mhs'
%         tMix = varargin{1};
%         func = varargin{2};
%         switch func
%             case 'mdd'
%                 distFunc = @MaxDegreeDistance;
%             case 'ddd'
%                 cdf0 = cumsum(GetDegreeDistribution(al));
%                 distFunc = @(a1, l1, a2, l2) DegreeDistDistance(a1, l1, a2, l2, cdf0);
%         end
%         sampler = @(am, al) MetropolisHastingsSampling(am, al, k, tMix, distFunc);
% end

% argchk
if k >= length(al)
    %disp('Sample size larger than supergraph size, returning original graph')
    ams = am;
    als = al;
else    
    vSet = MetropolisHastingsSampling(am, al, k, t, p);
    ams = am(vSet, vSet);
    als = createAdjList(ams);
end

switch gk
    case 3
        counts = countconnected3graphlets(ams, als);
    case 4
        counts = countconnected4graphlets(ams, als);
    case 5
        counts = countconnected5graphlets(ams, als);
end

nbrGraphlets = sum(counts);
gDist = counts;


end