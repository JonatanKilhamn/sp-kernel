clc
clear variables
addpath(genpath([pwd, '/..']))

dataset = 'DD';
tMix = 1000;
sampleSize = 200;
nbrDataSets = 1;
nbrReps = 20;
pVec = [50 100 500 1000 2000];

load(dataset)
data = eval(dataset);

D = zeros(nbrReps, length(tMix));

nbrDistances = 1;
for i = 2
    al = data(i).al;
    am = data(i).am;
    if length(al) < sampleSize
        disp('too small graph!')
        continue
    end
    % Compute degree distribution of current graph
    dd = GetDegreeDistribution(al);
    cdf0 = cumsum(dd);
    
    freq = countconnected5graphlets(am, al);
    freq = freq ./ sum(freq);
    cdfg = cumsum(freq);
    for j = 1
        for k = 1:length(pVec)
            p = pVec(k);           
            for m = 1:nbrReps
                tic
                vSet = MetropolisHastingsSampling(am, al, sampleSize, tMix, p);
                t = toc;
                fprintf('Time: %0.3f\n', t);
                ams = am(vSet, vSet);
                als = createAdjList(ams);
%                 freq1 = countconnected5graphlets(ams, als);
%                 freq1 = freq1 ./ sum(freq1);
%                 cdf1 = cumsum(freq1);
                
                lls = cellfun('length', als);
                dd = histc(lls, 0:(length(cdf0)-1));
                dd = dd ./ sum(dd);
                cdf1 = cumsum(dd);
                D(m,k) = max(abs(cdf0 - cdf1));
            end
        end    
    end
end


meanD = mean(D)
plot(pVec, meanD)