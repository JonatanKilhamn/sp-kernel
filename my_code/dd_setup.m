experiment_setup;

dataset = 'DD';

doRenameVars = 1;
doStoreParams = 1;

sizes = 1;
nSizes = length(sizes);
nGraphs = 1178;

if doRenameVars
    for graphSize = sizes
        dataFilename = ['./my_code/data/', dataset ...
            num2str(graphSize)];
        load(dataFilename)
        GRAPHS = DD;
        lgraphs = ldd;
        save(dataFilename, 'GRAPHS', 'lgraphs')
    end
end

if doStoreParams
    % sampling params:
    nTrials = 20; % compute all sampled kernels several times
    nVorPreTrials = 5;
    nVorTrials = 10;
        
    hs = 0:4;
    nhValues = length(hs);
    
    %nTrials = 1;
    ms = [10 20 40 80 140 200];
    %ms = [10 200];
    %ms = [10];
    nMValues = length(ms);
    
    % voronoi params
    densityFactors = [1, 5, 10];
    nDensityFactors = length(densityFactors);
    
    paramsFilename = ...
        ['./my_code/data/params_', dataset];
    save(paramsFilename, 'sizes', 'nSizes', 'nTrials', 'nVorPreTrials', ...
        'nVorTrials', 'ms', 'nGraphs', 'nMValues', 'densityFactors', ...
        'nDensityFactors', 'hs', 'nhValues');
end
