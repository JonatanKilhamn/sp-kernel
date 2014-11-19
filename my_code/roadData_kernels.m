%% Setup

experiment_setup;

% sample subgraphs of size 100, 200, 500, 1 000, 2 000, 5 000,
% 10 000, 20 000
sizes = [100, 200, 500, 1000, 2000, 5000, 10000, 20000];
sizesToRun = sizes(1);

densities = 0.1*[1 2 3 5 9];
densitiesToRun = densities(1:5);
nDensities = length(densitiesToRun);

%%

doStandard = 0;
doSampleLast = 0;
doSampleFirst = 0;
doVoronoi = 1;


for graphSize = sizesToRun
    %% Pick out the data
    
    roadDataFilename = ['./my_code/data/ROADS' ...
        num2str(graphSize)];
    load(roadDataFilename)
    % we now have ROADS and lroads loaded
    
    nGraphs = size(ROADS, 2);
    Graphs = ROADS;
    labels = lroads;
    
    
    if doStandard || doSampleLast
        fwFilename = ['./my_code/data/fw_ROADS' ...
            num2str(graphSize)];
        load(fwFilename)
        % we now have fwROADS and fwRuntimesROADS loaded
        shortestPathMatrices = fwROADS;
    end
    
    
    
    %% Standard kernel:
    if doStandard
        
        t = cputime;
        standardKernelValues = shortestPathKernel(Graphs, shortestPathMatrices);
        standardKernelRuntime = cputime - t;
        
        standKernValuesFilename = ...
            ['./my_code/data/stdKrnVal_ROADS' ...
            num2str(graphSize)];
        save(standKernValuesFilename, 'standardKernelValues', ...
            'standardKernelRuntime');
    end
    
    %%
    
    % sampling:
    nTrials = 4,%20; % compute all sampled kernels several times
    %nTrials = 1;
    ms = [10 20 40 80 140 200];
    %ms = [10];
    nMValues = length(ms);
    
    paramsFilename = ...
        ['./my_code/data/params_ROADS' ...
        num2str(graphSize)];
    save(paramsFilename, 'graphSize', 'nTrials', 'ms', 'nGraphs', ...
        'densities');
    
    
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
            ['./my_code/data/smpLstKrnVal_ROADS' ...
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
            ['./my_code/data/smpFstKrnVal_ROADS' ...
            num2str(graphSize)];
        save(sampFstValuesFilename, 'sampleFirstKernelValues', ...
            'sampleFirstRunTimes');
    end
    
    if doVoronoi
        disp('Voronoi kernel:')
        for density = densitiesToRun
            % loading
            vorPreFilename = ['./my_code/data/vorPre_ROADS' ...
                num2str(graphSize) '_' num2str(density) '.mat'];
            load(vorPreFilename);
            % We now have vorAdjROADS and groupingsROADS
            
            % compute Voronoi kernel
            for i = 1:nMValues
                for j = 1:nTrials
                    t = cputime;
                    voronoiKernelValues{i, j} = ...
                        voronoiKernel(Graphs, ms(i), groupingsROADS, ...
                        vorAdjROADS);
                    disp(['Finished trial ' num2str(j) ' out of ' ...
                        num2str(nTrials) ' for m-value ' ...
                        num2str(ms(i)), ' and density ' ...
                        num2str(density)])
                    voronoiRunTimes(i, j) = cputime - t;
                end
            end
            
            vorValuesFilename = ...
                ['./my_code/data/vorKrnVal_ROADS' ...
                num2str(graphSize) '_' num2str(density) '.mat'];
            save(vorValuesFilename, 'voronoiKernelValues', ...
                'voronoiRunTimes');
        end
    end
    
end

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





