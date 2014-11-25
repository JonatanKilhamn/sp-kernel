%% Setup

experiment_setup;

dataset = 'ROADS';

% sample subgraphs of size 100, 200, 500, 1 000, 2 000, 5 000,
% 10 000, 20 000
sizes = [100, 200, 500, 1000, 2000, 5000, 10000, 20000];
sizesToRun = sizes(1);

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
save(paramsFilename, 'sizes', 'sizesToRun', 'nTrials', 'ms', ...
    'nMValues', 'nGraphs', 'densities', 'densitiesToRun', ...
    'nDensities');

%%

doStandard = 1;
doSampleLast = 0;
doSampleFirst = 0;
doVoronoi = 0;


for graphSize = sizesToRun
    %% Pick out the data
    disp('Loading data')
    dataFilename = ['./my_code/data/', dataset ...
        num2str(graphSize)];
    load(dataFilename)
    % we now have GRAPHS and lgraphs loaded
    disp('Data loaded')
    nGraphs = size(GRAPHS, 2);
    Graphs = GRAPHS;
    labels = lgraphs;
    
    
    if doStandard || doSampleLast
        clear fwCombined;
        disp('Loading fw data')
        fwFilename = ['./my_code/data/fw_', dataset ...
            num2str(graphSize)];
        load(fwFilename)
        % we now have fw (or fwCombined) loaded
        
        if exist('fwCombined', 'var')
            disp('Using fwCombinedR instead of fwR')
            fw = fwCombined;
        end
        
        
        shortestPathMatrices = fw;
    end
    
    
    
    %% Standard kernel:

    if doStandard
        disp('Standard kernel')
        t = cputime;
        standardKernelValues = shortestPathKernel(Graphs, shortestPathMatrices);
        standardKernelRuntime = cputime - t;
        
        standKernValuesFilename = ...
            ['./my_code/data/stdKrnVal_', dataset ...
            num2str(graphSize)];
        save(standKernValuesFilename, 'standardKernelValues', ...
            'standardKernelRuntime');
    end
    
    %% Sampling
   
   
    
    
    sampleLastKernelValues = cell(nMValues, nTrials);
    sampleLastRunTimes = zeros(nMValues, nTrials);
    
    sampleFirstKernelValues = cell(nMValues, nTrials);
    sampleFirstRunTimes = zeros(nMValues, nTrials);
    
    voronoiKernelValues = cell(nMValues, nTrials);
    voronoiRunTimes = zeros(nMValues, nTrials);
    
    %%
    if doSampleLast
        disp('SampleLast kernel:')
        % compute sampleLast kernel: kernel values, runtimes
        for i = 1:nMValues
            for j = 1:nTrials
                t = cputime;
                sampleLastKernelValues{i, j} = sampleLastKernel(Graphs, ...
                    ms(i), shortestPathMatrices);
                sampleLastRunTimes(i, j) = cputime - t;
                disp(['Finished trial ' num2str(j) ' out of ' ...
                    num2str(nTrials) ' for m-value ' num2str(ms(i))])
            end
        end
        
        
        sampLastValuesFilename = ...
            ['./my_code/data/smpLstKrnVal_', dataset ...
            num2str(graphSize)];
        save(sampLastValuesFilename, 'sampleLastKernelValues', ...
            'sampleLastRunTimes');
    end
    
    %%
    
    if doSampleFirst
        disp('SampleFirst kernel:')
        % compute sampleFirst kernel
        for i = 1:nMValues
            for j = 1:nTrials
                t = cputime;
                sampleFirstKernelValues{i, j} = ...
                    sampleFirstKernel(Graphs, ms(i));
                disp(['Finished trial ' num2str(j) ' out of ' ...
                    num2str(nTrials) ' for m-value ' num2str(ms(i))])
                sampleFirstRunTimes(i, j) = cputime - t;
            end
        end
        
        sampFstValuesFilename = ...
            ['./my_code/data/smpFstKrnVal_', dataset ...
            num2str(graphSize)];
        save(sampFstValuesFilename, 'sampleFirstKernelValues', ...
            'sampleFirstRunTimes');
    end
    
    if doVoronoi
        disp('Voronoi kernel:')
        for density = densitiesToRun
            % loading
            vorPreFilename = ['./my_code/data/vorPre_', dataset ...
                num2str(graphSize) '_' num2str(density) '.mat'];
            load(vorPreFilename);
            % We now have vorAdj and groupings
            
            groupingMats = cell(1, nGraphs);
            for i = 1:nGraphs
                groupingMats{i} = repmat(groupings{i},1,10) == ...
                    repmat(1:10, nGraphs, 1);
            end
            
            
            % compute Voronoi kernel
            for i = 1:nMValues
                for j = 1:nTrials
                    t = cputime;
                    
%                     voronoiKernelValues{i, j} = ...
%                         voronoiKernel(Graphs, ms(i), groupings, ...
%                         vorAdj);
                    voronoiKernelValues{i, j} = ...
                        voronoiKernel(Graphs, ms(i), groupingMats, ...
                        vorAdj);
                    disp(['Finished trial ' num2str(j) ' out of ' ...
                        num2str(nTrials) ' for m-value ' ...
                        num2str(ms(i)), ' and density ' ...
                        num2str(density)])
                    voronoiRunTimes(i, j) = cputime - t;
                end
            end
            
            vorValuesFilename = ...
                ['./my_code/data/vorKrnVal_', dataset ...
                num2str(graphSize) '_' num2str(density) '.mat'];
            save(vorValuesFilename, 'voronoiKernelValues', ...
                'voronoiRunTimes');
        end
    end
    
end

% Comments
% Overview:


% compute kernels:
% standard kernel: compute kernel for all graph collections
% - prereq: floyd-warshal for all graph collections

% sample-last: compute kernel for all graph sizes, for all sample sizes,
% for some number of trials
% - prereq: f-w here too

% sample-first: compute kernel for all graph sizes, for few sample sizes,
% for some number of trials
% - prereqs: nothing


