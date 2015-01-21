experiment_setup;

dataset = 'ROADS';

doCreateData = 0;
doStoreParams = 1;

sizes = [100, 200, 500, 1000, 2000, 5000, 10000, 20000];
nSizes = length(sizes);
nGraphs = 100;

toRun = 1:6;

if doCreateData
    for graphSize = sizes(toRun);
        [~, dataset] = CreateRoadData(graphSize, nGraphs);
    end
end

if doStoreParams
    % sampling params:
    nTrials = 20; % compute all sampled kernels several times
    nVorPreTrials = 5;
    nVorTrials = 10;
    %nTrials = 1;
    %ms = [10 20 40 80 140 200];
    ms = [10 200];
    %ms = [10];
    nMValues = length(ms);
    
    % voronoi params
    densityFactors = [1, 5, 10];
    nDensityFactors = length(densityFactors);
    
    paramsFilename = ...
        ['./my_code/data/params_', dataset];
    save(paramsFilename, 'sizes', 'nSizes', 'nTrials', 'nVorPreTrials', ...
        'nVorTrials', 'ms', 'nGraphs', 'nMValues', 'densityFactors', ...
        'nDensityFactors');
end
