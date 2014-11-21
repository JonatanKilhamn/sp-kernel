%% Setup

experiment_setup;

% sample subgraphs of size 100, 200, 500, 1 000, 2 000, 5 000,
% 10 000, 20 000
sizes = [100, 200, 500, 1000, 2000, 5000, 10000, 20000];
nSizes = length(sizes);

toRun = 1:5;

doStandard = 1;
doSampleLast = 1;
doSampleFirst = 1;
doVoronoi = 1;


%%

paramsFilename = './my_code/data/params_ROADS100';
load(paramsFilename)
% use any params because they are all the same; the matrices created by
% this script are only possible if the same ms are used for all graph sizes
% We now have nTrials, ms, graphSize and densities
nMValues = length(ms);
nDensities = length(densities);
    
stdPrepRuntimes = zeros(1, nSizes);
stdQueryRuntimes = zeros(1, nSizes);
smpFstPrepRuntimes = zeros(nMValues, nSizes);
smpFstQueryRuntimes = zeros(nMValues, nSizes);
smpLstPrepRuntimes = zeros(nMValues, nSizes);
smpLstQueryRuntimes = zeros(nMValues, nSizes);
vorPrepRuntimes = zeros(nMValues, nSizes, nDensities);
vorQueryRuntimes = zeros(nMValues, nSizes, nDensities);

runtimesFilename = './my_code/data/runtimes_ROADS';
load(runtimesFilename)

%%
for i = toRun
    %% Pick out the data
    
    graphSize = sizes(i);
    
    roadDataFilename = ['./my_code/data/ROADS' ...
        num2str(graphSize)];
    load(roadDataFilename)
    % we now have ROADS and lroads loaded
    
    if (doStandard || doSampleLast)
        %fwFilename = ['./my_code/data/fw_ROADS' ...
        %    num2str(graphSize)];
        %load(fwFilename)
        fwRuntimeFilename = ['./my_code/data/fwRuntime_ROADS' ...
            num2str(graphSize)];
        load(fwRuntimeFilename)
        % we now have fwROADS and fwRuntimesROADS loaded
    end
    
    if doSampleFirst
        smpFstFilename = ['./my_code/data/smpFstKrnVal_ROADS' ...
            num2str(graphSize)];
        load(smpFstFilename)
        % we now have sampleFirstKernelValues and sampleFirstRunTimes loaded
    end
    
    if doSampleLast
        smpLstFilename = ['./my_code/data/smpLstKrnVal_ROADS' ...
            num2str(graphSize)];
        load(smpLstFilename)
        % we now have sampleLastKernelValues and sampleLastRunTimes loaded
    end
    
    if doStandard
        stdKrnFilename = ['./my_code/data/stdKrnVal_ROADS' ...
            num2str(graphSize)];
        load(stdKrnFilename)
        % we now have standardKernelValues and standardKernelRuntime loaded
    end
    
    
    
    paramsFilename = ...
        ['./my_code/data/params_ROADS' ...
        num2str(graphSize)];
    load(paramsFilename)
    % we now have nTrials, ms, and graphSize

    
    nGraphs = size(ROADS, 2);
    
    Graphs = ROADS;
    labels = lroads;
    %shortestPathMatrices = fwROADS;
    
    nMValues = length(ms);
    
    if doStandard
        stdPrepRuntimes(i) = sum(fwRuntimesROADS);
        stdQueryRuntimes(i) = standardKernelRuntime;
    end
    
    if doSampleFirst
        smpFstPrepRuntimes(:, i) = 0;
        smpFstQueryRuntimes(:, i) = mean(sampleFirstRunTimes, 2);
    end
    
    if doSampleLast
        smpLstPrepRuntimes(:, i) = sum(fwRuntimesROADS);
        smpLstQueryRuntimes(:, i) = mean(sampleLastRunTimes, 2);
    end
    
    if doVoronoi
        for j = 1:nDensities
            density = densities(j);
            
            vorPreRuntimeFilename = ...
                ['./my_code/data/vorPreRuntime_ROADS' ...
                num2str(graphSize) '_' num2str(density) '.mat'];
            load(vorPreRuntimeFilename);
            % we now have vorPreRuntimesROADS
            
            vorValuesFilename = ...
                ['./my_code/data/vorKrnVal_ROADS' ...
                num2str(graphSize) '_' num2str(density) '.mat'];
            load(vorValuesFilename, 'voronoiRunTimes');
            
            vorPrepRuntimes(:, i, j) = sum(vorPreRuntimesROADS);
            vorQueryRuntimes(:, i, j) = mean(voronoiRunTimes, 2);
        end
        
    end
    
end

save(runtimesFilename, 'stdPrepRuntimes', 'stdQueryRuntimes', ...
    'smpFstPrepRuntimes', 'smpFstQueryRuntimes', 'smpLstPrepRuntimes', ...
    'smpLstQueryRuntimes')

