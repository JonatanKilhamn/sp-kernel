clc
addpath(genpath([pwd '/..']));

load DD
dSet = 3;
nbrReps = 100;
graphletCnts = zeros(nbrReps,1);

am = DD(dSet).am;
al = DD(dSet).al;

n = length(al);
k = 100;
gk = 4;
tMix = 1000;
p = 500;

for i = 1:nbrReps    
    %[~, cnt] = LargeGraphSampler(am, al, k, gk, tMix, p);
    [~, cnt] = AcceptReject(am, al, gk);
    graphletCnts(i) = cnt;
    disp(i/nbrReps)
end

cntAll = sum(countconnected4graphlets(am,al));

nbrGraphlets = nchoosek(n,gk);
nbrGraphletsSampled = nchoosek(k,gk);

%approxCnt = nbrGraphlets .* graphletCnts ./ (nbrGraphletsSampled * n);
meanCnt = mean(graphletCnts);
qhat = 1/meanCnt;
q = cntAll / nbrGraphlets;

str = 'Fraction of connected graphlets: %d Estimated fraction: %d\n';
fprintf(str, q, qhat);

figure(1);
plot(1./(graphletCnts) - q);
figure(2); 
hist(graphletCnts-1/q, 20);