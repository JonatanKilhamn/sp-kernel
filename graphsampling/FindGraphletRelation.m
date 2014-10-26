clc
addpath(genpath([pwd, '/..']));

load BA1

tMix = 500;
p = 500;
gk = 5;

dSet = 137;
am = BA1(dSet).am;
al = BA1(dSet).al;
n = length(al);
k = round(linspace(25,n-0.1*n,15));
nbrReps = 10;

nbrGraphlets = zeros(nbrReps, length(k)); 

for i = 1:length(k)
    iK = k(i);
    for j = 1:nbrReps
        [~, cnt] = LargeGraphSampler(am, al, iK, gk, tMix, p);
        nbrGraphlets(j,i) = cnt;
    end  
    disp(i/length(k))
end

nbrGraphletsAll = sum(countconnected5graphlets(am,al));
nbrGraphletsMean = [mean(nbrGraphlets), nbrGraphletsAll];
k = [k, length(al)];

plot(k, nbrGraphletsMean);