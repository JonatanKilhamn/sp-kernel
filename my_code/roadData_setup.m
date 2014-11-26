experiment_setup;

doCreateData = 0;
doStoreParams = 1;

sizes = [100, 200, 500, 1000, 2000, 5000, 10000, 20000];
nGraphs = 100;

if doCreateData
    for graphSize = sizes(1);
        CreateRoadData(graphSize, nGraphs);
    end
end

if doStoreParams
    % sampling params:
    nTrials = 20; % compute all sampled kernels several times
    %nTrials = 1;
    ms = [10 20 40 80 140 200];
    %ms = [10];
    nMValues = length(ms);
    
    % voronoi params
    densities = 0.1*[1 2 3 5 9];
    densitiesToRun = densities(1);
    nDensities = length(densitiesToRun);
    
    paramsFilename = ...
        ['./my_code/data/params_', dataset];
    save(paramsFilename, 'sizes', 'nTrials', 'ms', 'nGraphs', ...
        'nMValues', 'densities');
end