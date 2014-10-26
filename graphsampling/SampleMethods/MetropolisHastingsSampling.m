function graphs = MetropolisHastingsSampling(am, al, k, nbrGraphs, tMix, p)
%MONTECARLOHASTINGS MCMC sampling of induced subgraphs
%   

graphs = struct;

% Init
vSets = zeros(nbrGraphs,k);
dd0 = GetDegreeDistribution(al);
cdf0 = cumsum(dd0);

for i = 1:nbrGraphs
    
    [vSet, flag] = RandomWalk(al, k);
    j = 0;
    while flag % If fail
        [vSet, flag] = RandomWalk(al, k);
        j = j + 1;
        if j > 1e4
            vSet = randperm(length(al),k);
            break;
        end
    end
        
    vBest = vSet;
    t = tMix;
    
    amb = am(vBest, vBest);
    %alb = createAdjListWrapper(amb);
    sBest = SingleDegreeDist(amb, cdf0);
    
    while t > 0
        neighbors = GetNeighbors(al, vSet);
        
        % Node to swap
        idx = randi(k);
        v = vSet(idx);
        
        % New node
        nN = length(neighbors);
        idx2 = randi(nN);
        vNew = neighbors(idx2);
        
        vSetNew = vSet;
        vSetNew(idx) = vNew;
        
        % Get new and old graphs
        amOld = sparse(am(vSet, vSet));
        amNew = sparse(am(vSetNew, vSetNew));
%         alOld = createAdjListWrapper(amOld);
%         alNew = createAdjListWrapper(amNew);
%         
        if isconnected(amNew)
            [q, sOld, sNew] = DegreeDistDistance(amOld, amNew, cdf0, p);
            
            alpha = rand;
            if alpha < q
                vSet(idx) = vNew;
                if sBest > sNew
                    sBest = sNew;
                    vBest = vSet;
                end
            end
            t = t-1;
        else
            t = t-1;
            continue
        end %if
        
    end %while
    vSets(i,:) = vBest;
    disp(i/nbrGraphs);
    newAm = am(vBest,vBest);    
    newAl = createAdjListWrapper(newAm);
    graphs(i).al = newAl;
    graphs(i).am = newAm;    
    
    %disp(['Created ', num2str(i), ' out of ', ...
    %    num2str(nbrGraphs), ' graphs']);
end
end

function neighbors = GetNeighbors(al, vSet)

neighbors = unique([al{vSet}]);
neighbors(ismembc(neighbors, sort(vSet))) = [];
      
end