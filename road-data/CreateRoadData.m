function success = CreateRoadData(sizeOfSampled, nGraphs)
%sizeOfSampled = 100;
%nGraphs = 120;


doCa = true;
doTx = true;
sampleCa = true;
sampleTx = true;
merge = true;
filename = ['~/dokument/exjobb/my_code/data/ROADS' num2str(sizeOfSampled)];

%path(path, genpath('../'))

if doCa
    da = importdata('roadNet-CA.txt');
    d1 = da.data(:,1)+1;
    d2 = da.data(:,2)+1;
    n = max(max(da.data))+1;
    
    
    [~, idxv] = sort(d1);
    d1 = d1(idxv);
    d2 = d2(idxv);
    
    disp('import done')
    amca = sparse(d1, d2, ones(size(d1)));
    disp('matrix done')
    
    ss = full(sum(amca));
    maxDeg = max(ss);
    alca = createAdjListFromEdgeList(n, [d1, d2], maxDeg);
    
    clear('da', 'd1', 'd2');
end
if doTx
    da = importdata('roadNet-TX.txt');
    
    n = max(max(da.data))+1;
    d1 = da.data(:,1)+1;
    d2 = da.data(:,2)+1;
    
    [~, idxv] = sort(d1);
    d1 = d1(idxv);
    d2 = d2(idxv);
    
    disp('import done')
    amtx = sparse(d1, d2, ones(size(d1)));
    disp('matrix done')
    
    ss = full(sum(amca));
    maxDeg = max(ss);
    altx = createAdjListFromEdgeList(n, [d1, d2], maxDeg);
    
    clear('da', 'd1', 'd2');
end
if sampleCa
    %caGraphs = MetropolisHastingsSampling(amca, alca, 1e4, 100, 10000, 500);
    caGraphs = MetropolisHastingsSampling(amca, alca, sizeOfSampled, nGraphs/2, 1000, 500);
    disp(['Completed CA graphs for size ' num2str(sizeOfSampled)])
end
if sampleTx
    %txGraphs = MetropolisHastingsSampling(amtx, altx, 1e4, 100, 10000, 500);
    txGraphs = MetropolisHastingsSampling(amtx, altx, sizeOfSampled, nGraphs/2, 1000, 500);
    disp(['Completed TX graphs for size ' num2str(sizeOfSampled)])
end

if merge
    nca = length(caGraphs);
    ntx = length(txGraphs);
    lca = zeros(nca,1);
    ltx = ones(ntx,1);
    
    labels = [lca; ltx];
    data = [caGraphs, txGraphs];
    
    ROADS = data;
    lroads = labels;
    save(filename, 'ROADS', 'lroads');
end

success = 1;

end

