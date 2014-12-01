%% Setup

experiment_setup;

dataset = 'GENP';

paramsFilename = ...
    ['./my_code/data/params_', dataset];
load(paramsFilename);


%sizes = [100, 200, 500, 1000, 2000, 5000, 10000, 20000];
nSizes = length(sizes);

toRun = 1:3;

doStandard = 1;
doSampleLast = 1;
doSampleFirst = 1;
doVoronoi = 1;


%%

paramsFilename = ['./my_code/data/params_', dataset];
load(paramsFilename)
% We now have nTrials, ms, graphSize and densities

%nMValues = length(ms);
%nDensities = length(densitiesToRun);

stdPrepRuntimes = zeros(1, nSizes);
stdQueryRuntimes = zeros(1, nSizes);

smpFstPrepRuntimes = zeros(nMValues, nSizes);
smpFstQueryRuntimes = zeros(nMValues, nSizes);
smpFstPrepOps = zeros(nMValues, nSizes);
smpFstQueryOps = zeros(nMValues, nSizes);

smpLstPrepRuntimes = zeros(nMValues, nSizes);
smpLstQueryRuntimes = zeros(nMValues, nSizes);

vorPrepRuntimes = zeros(nMValues, nSizes, nDensities);
vorQueryRuntimes = zeros(nMValues, nSizes, nDensities);
vorPrepOps = zeros(nMValues, nSizes, nDensities);
vorQueryOps = zeros(nMValues, nSizes, nDensities);



runtimesFilename = ['./my_code/data/runtimes_', dataset];
%load(runtimesFilename)

%%
for i = toRun
    %% Pick out the data
    
    graphSize = sizes(i);
    
    dataFilename = ['./my_code/data/', dataset ...
        num2str(graphSize)];
    load(dataFilename)
    % we now have GRAPHS and lgraphs loaded
    Graphs = GRAPHS;
    labels = lgraphs;
    
    if (doStandard || doSampleLast)
        %fwFilename = ['./my_code/data/fw_', dataset ...
        %    num2str(graphSize)];
        %load(fwFilename)
        fwRuntimeFilename = ['./my_code/data/fwRuntime_', dataset ...
            num2str(graphSize)];
        load(fwRuntimeFilename)
        % we now have fw and fwRuntimes loaded
    end
    
    if doSampleFirst
        smpFstFilename = ['./my_code/data/smpFstKrnVal_', dataset ...
            num2str(graphSize)];
        load(smpFstFilename)
        % we now have sampleFirstKernelValues and sampleFirstRunTimes loaded
    end
    
    if doSampleLast
        smpLstFilename = ['./my_code/data/smpLstKrnVal_', dataset ...
            num2str(graphSize)];
        load(smpLstFilename)
        % we now have sampleLastKernelValues and sampleLastRunTimes loaded
    end
    
    if doStandard
        stdKrnFilename = ['./my_code/data/stdKrnVal_', dataset ...
            num2str(graphSize)];
        load(stdKrnFilename)
        % we now have standardKernelValues and standardKernelRuntime loaded
    end
    
    
  
    
    if doStandard
        stdPrepRuntimes(i) = sum(fwRuntimes);
        stdQueryRuntimes(i) = standardKernelRuntime;
    end
    
    if doSampleFirst
        smpFstPrepRuntimes(:, i) = 0;
        smpFstQueryRuntimes(:, i) = mean(sampleFirstRunTimes, 2);
        smpFstPrepOps(:, i) = 0;
        smpFstQueryOps(:, i) = mean(sampleFirstOps, 2);
    end
    
    if doSampleLast
        smpLstPrepRuntimes(:, i) = sum(fwRuntimes);
        smpLstQueryRuntimes(:, i) = mean(sampleLastRunTimes, 2);
    end
    
    if doVoronoi
        for j = 1:nDensities
            density = densities(j);
            
            vorPreRuntimeFilename = ...
                ['./my_code/data/vorPreRuntime_', dataset ...
                num2str(graphSize) '_' num2str(density) '.mat'];
            load(vorPreRuntimeFilename);
            % we now have vorPreRuntimes and vorPreOps
            
            vorValuesFilename = ...
                ['./my_code/data/vorKrnVal_', dataset ...
                num2str(graphSize) '_' num2str(density) '.mat'];
            load(vorValuesFilename, 'voronoiRunTimes', 'voronoiOps');
            
            vorPrepRuntimes(:, i, j) = sum(vorPreRuntimes);
            vorQueryRuntimes(:, i, j) = mean(voronoiRunTimes, 2);
            vorPrepOps(:, i, j) = sum(vorPreOps);
            vorQueryOps(:, i, j) = mean(voronoiOps, 2);
            
        end
        
    end
    
end

save(runtimesFilename, 'stdPrepRuntimes', 'stdQueryRuntimes', ...
    'smpFstPrepRuntimes', 'smpFstQueryRuntimes', 'smpLstPrepRuntimes', ...
    'smpLstQueryRuntimes', 'vorPrepRuntimes', 'vorQueryRuntimes', ...
    'smpFstPrepOps', 'smpFstQueryOps', 'vorPrepOps', 'vorQueryOps')

