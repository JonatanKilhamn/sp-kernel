clc

addpath(genpath([pwd '/..']));
clear variables
load DD
dataVec = DD;
k = 2;
n = length(dataVec);
idx = randperm(n, k);

for iD = 1:k
    data = dataVec(iD);
    freq = [0 0 0 0 0 0];
    for i = 1:300
        vSet = MetropolisHastingsSampling(data.al, 4, 200);
        type = GetGraphletType(vSet, data.al(vSet), 4);
        freq(type) = freq(type) + 1;
    end
    freqNorm = (freq)./(sum(freq));
    freq = (freq);
    freq2 = countconnected4graphlets(data.am, data.al);    
    freq2Norm = freq2./(sum(freq2));
    PrintDist(freqNorm, freq2Norm);    
end