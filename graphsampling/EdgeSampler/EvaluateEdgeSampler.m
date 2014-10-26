load ENZYMES
data = ENZYMES;

nbrData = length(data);

pVec = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
nbrP = length(pVec);
nbrRep = 10;

graphletDists = zeros(nbrRep, 21);
dStat = zeros(nbrRep, nbrP);

results = cell(nbrData, 2);

meanD = zeros(1,nbrP);
maxD = zeros(1,nbrP);

% Main loop
for i = 1:nbrData
    am = data(i).am;
    al = data(i).al;
    n = length(al);
    origD = countconnected5graphlets(am, al);
    origCdf = cumsum(origD/sum(origD));
    for j = 1:nbrP
        iP = pVec(j);
        sampleSize = ceil(iP*n);
        for k = 1:nbrRep
            while true
                gDist = EdgeSampler(am, al, sampleSize, 5);
                if any(gDist)
                    break
                end
            end
            gCdf = cumsum(gDist/sum(gDist));
            graphletDists(k,:) = gDist;
            D = max(abs(origCdf - gCdf));
            dStat(k,j) = D;                        
        end    
    end
    meanD = meanD + mean(dStat,1);
    results(i,1) = {graphletDists};
    results(i,2) = {dStat};
    fprintf('%0.2f\n', i/nbrData)
end

meanD = meanD / nbrData;
plot(pVec, meanD)
