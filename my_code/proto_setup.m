experiment_setup;

dataset = 'PROTO';

doStoreParams = 1;

sizes = [100, 150, 250, 400, 650, 1000, 1500, 2500, 4000, 6500, 10000];
nSizes = length(sizes);
nGraphs = 100;

for graphSize = sizes
    dataFilename = ['./my_code/data/', dataset ...
        num2str(graphSize)];
    load(dataFilename)
    GRAPHS = PROTO;
    lgraphs = lproto;
    save(dataFilename, 'GRAPHS', 'lgraphs')
end


if doStoreParams
    % sampling params:
    nTrials = 20; % compute all sampled kernels several times
    %nTrials = 1;
    %ms = [10 20 40 80 140 200];
    ms = [10 200];
    %ms = [10];
    nMValues = length(ms);
    
    % voronoi params
    densities = [0.04 0.1];
    nDensities = length(densities);
    
    paramsFilename = ...
        ['./my_code/data/params_', dataset];
    save(paramsFilename, 'sizes', 'nSizes', 'nTrials', 'ms', 'nGraphs', ...
        'nMValues', 'densities', 'nDensities');
end
