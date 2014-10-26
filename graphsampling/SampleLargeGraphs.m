clc
clear variables
addpath(genpath([pwd, '/..']))

dataset = 'DD';
tMix = 50;
k = 150;
nbrDataSets = 3;

load(dataset)
data = eval(dataset);

nbrDistances = 2;

for i = 4:4+nbrDataSets
    al = data(i).al;
    am = data(i).am;
    if length(al) < k
        disp('too small graph!')
        continue
    end
    % Compute degree distribution of current graph
    dd = GetDegreeDistribution(al);
    cdf0 = cumsum(dd);
    for j = 1:nbrDistances
        switch j
            case 1
                distfunc = @(a1, l1, a2, l2) DegreeDistDistance(a1, l1, a2, l2, cdf0);
                method = 'ddd';
            case 2
                distfunc = @MaxDegreeDistance;
                method = 'mdd';
            case 3
                distfunc = @NewDegreeDistance; % NOT WORKING
                method = 'ndd';
        end
    tic
    vSet = MetropolisHastingsSampling(al, am, k, tMix, distfunc);
    ams = am(vSet, vSet);
    als = createAdjList(ams);    
    [freq] = countconnected5graphlets(ams,als);
    t = toc;
    freqn = freq./sum(freq);
    PrintDist(freqn, t, method);
    
    end
    tic;
    freq5 = countconnected5graphlets(am, al);
    t5 = toc;
    freq5n = freq5./sum(freq5);
    PrintDist(freq5n, t5, 'all');
    disp(' ')
    disp(' ')
    
end