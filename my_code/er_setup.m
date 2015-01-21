experiment_setup;

dataset = 'ER';

doCreateData = 1;
doStoreParams = 1;

sizes = [100, 200, 500, 1000, 2000, 5000, 10000, 20000];
%sizes = 10;
nSizes = length(sizes);
nGraphs = 100;

p1 = 0.1;
p2 = 0.109;

sizesToRun = sizes(1:6);

if doCreateData
    for graphSize = sizesToRun
        
        filename = ['./my_code/data/', dataset, num2str(graphSize)];
        
        [GRAPHS, lgraphs] = er_set(ceil(nGraphs/2), graphSize, p1, p2);
        
        save(filename, 'GRAPHS', 'lgraphs', '-v7.3');
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
        'nDensityFactors', 'p1', 'p2');
end