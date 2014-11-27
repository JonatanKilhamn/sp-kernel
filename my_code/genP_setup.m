experiment_setup;

dataset = 'GENP';

doCreateData = 0;
doStoreParams = 1;

sizes = [100, 200, 500, 1000, 2000, 5000, 10000, 20000];
nGraphs = 100;

p1 = 0.1;
p2 = 0.101;

if doCreateData
    for graphSize = sizes(1);
        
        filename = ['./my_code/data/', dataset, num2str(graphSize)];
        
        [GRAPHS, lgraphs] = er_set(ceil(nGraphs/2), graphSize, p1, p2);
        
        save(filename, 'GRAPHS', 'lgraphs', '-v7.3');
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
    densities = [0.04 0.1];
    
    paramsFilename = ...
        ['./my_code/data/params_', dataset];
    save(paramsFilename, 'sizes', 'nTrials', 'ms', 'nGraphs', ...
        'nMValues', 'densities', 'p1', 'p2');
end