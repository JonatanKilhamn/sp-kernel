function fin = run_runtimes(dataset, maxSizeInd)

%% Setup

experiment_setup;

paramsFilename = ...
    ['./my_code/data/params_', dataset];
load(paramsFilename);


%sizes = [100, 200, 500, 1000, 2000, 5000, 10000, 20000];

%sizeInd = 1;

doStandard = 1;
doSampleLast = 1;
doSampleFirst = 1;
doVoronoi = 1;
doWL = 1;
doGraphlets = 1;


%%

%paramsFilename = ['./my_code/data/params_', dataset];
%load(paramsFilename)
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

vorPrepRuntimes = zeros(nMValues, nSizes, nDensityFactors);
vorQueryRuntimes = zeros(nMValues, nSizes, nDensityFactors);
vorPrepOps = zeros(nMValues, nSizes, nDensityFactors);
vorQueryOps = zeros(nMValues, nSizes, nDensityFactors);

wlRuntimes = zeros(1, nSizes);
graphletRuntimes = zeros(nMValues, nSizes);

runtimesFilename = ['./my_code/data/runtimes_', dataset];


save(runtimesFilename, 'stdPrepRuntimes', 'stdQueryRuntimes', ...
    'smpFstPrepRuntimes', 'smpFstQueryRuntimes', 'smpLstPrepRuntimes', ...
    'smpLstQueryRuntimes', 'vorPrepRuntimes', 'vorQueryRuntimes', ...
    'smpFstPrepOps', 'smpFstQueryOps', 'vorPrepOps', 'vorQueryOps', ...
    'wlRuntimes', 'graphletRuntimes')

disp('Saved blank file')


for i = 1:maxSizeInd
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
        % we now have smpFstKernelValues and smpFstRunTimes loaded
    end
    
    if doSampleLast
        smpLstFilename = ['./my_code/data/smpLstKrnVal_', dataset ...
            num2str(graphSize)];
        load(smpLstFilename)
        % we now have smpLstKernelValues and smpLstRunTimes loaded
    end
    
    if doStandard
        stdKrnFilename = ['./my_code/data/stdKrnVal_', dataset ...
            num2str(graphSize)];
        load(stdKrnFilename)
        % we now have standardKernelValues and standardKernelRuntime loaded
    end
    
    if doWL
        wlKrnFilename = ['./my_code/data/wlKrnVal_', dataset ...
            num2str(graphSize)];
        load(wlKrnFilename)
        % we now have wlKrnValues and wlRunTimes loaded
    end
    
    if doGraphlets
        graphletKrnFilename = ['./my_code/data/graphletKrnVal_', dataset ...
            num2str(graphSize)];
        load(graphletKrnFilename)
        % we now have graphletKrnValues and graphletRunTimes loaded
    end
    
    %%
    
    
    if doStandard
        stdPrepRuntimes(i) = sum(fwRuntimes);
        stdQueryRuntimes(i) = standardKernelRuntime;
    end
    
    if doSampleFirst
        smpFstPrepRuntimes(:, i) = 0;
        smpFstQueryRuntimes(:, i) = mean(smpFstRunTimes, 2);
        smpFstPrepOps(:, i) = 0;
        smpFstQueryOps(:, i) = mean(smpFstOps, 2);
    end
    
    if doSampleLast
        smpLstPrepRuntimes(:, i) = sum(fwRuntimes);
        smpLstQueryRuntimes(:, i) = mean(smpLstRunTimes, 2);
    end
    
    if doVoronoi
        for j = 1:nDensityFactors
            densityFactor = densityFactors(j);
            
            vorPreRuntimeFilename = ...
                ['./my_code/data/vorPreRuntime_', dataset ...
                num2str(graphSize) '_' num2str(densityFactor) '.mat'];
            load(vorPreRuntimeFilename);
            % we now have vorPreRuntimes and vorPreOps
            
            vorValuesFilename = ...
                ['./my_code/data/vorKrnVal_', dataset ...
                num2str(graphSize) '_' num2str(densityFactor) '.mat'];
            load(vorValuesFilename, 'vorRunTimes', 'vorOps');
            
            vorPrepRuntimes(:, i, j) = mean(sum(vorPreRuntimes, 1));
            vorQueryRuntimes(:, i, j) = mean(mean(vorRunTimes, 2), 3);
            vorPrepOps(:, i, j) = mean(sum(vorPreOps, 1));
            vorQueryOps(:, i, j) = mean(mean(vorOps, 2), 3);
            
            %vorRuntimes(i,j,k) = runtime of Mval i, vorPreTrial j,
            %vorTrial k
            
        end
        
    end
    
    if doWL
        wlRuntimes(i) = wlRunTimes;
    end
    
    if doGraphlets
        graphletRuntimes(:, i) = mean(graphletRunTimes, 2);
    end
    
end

save(runtimesFilename, 'stdPrepRuntimes', 'stdQueryRuntimes', ...
    'smpFstPrepRuntimes', 'smpFstQueryRuntimes', 'smpLstPrepRuntimes', ...
    'smpLstQueryRuntimes', 'vorPrepRuntimes', 'vorQueryRuntimes', ...
    'smpFstPrepOps', 'smpFstQueryOps', 'vorPrepOps', 'vorQueryOps', ...
    'wlRuntimes', 'graphletRuntimes')

disp('Saved final results')

fin = 1;

end
