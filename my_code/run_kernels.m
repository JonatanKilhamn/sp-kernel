%% Setup

experiment_setup;

dataset = 'PROTO';

paramsFilename = ...
    ['./my_code/data/params_', dataset];
load(paramsFilename)


sizesToRun = sizes(6);


densitiesToRun = densities(1:2);


%%

doStandard = 1;
doSampleLast = 1;
doSampleFirst = 0;
doVoronoi = 0;

doSaveDists = 1;

for graphSize = sizesToRun
    %% Pick out the data
    disp('Loading data')
    dataFilename = ['./my_code/data/', dataset ...
        num2str(graphSize)];
    load(dataFilename)
    % we now have GRAPHS and lgraphs loaded
    disp('Data loaded')
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
        [stdKrnValues, stdDists] = ...
            shortestPathKernel(Graphs, shortestPathMatrices);
        standardKernelRuntime = cputime - t;
        
        standKernValuesFilename = ...
            ['./my_code/data/stdKrnVal_', dataset ...
            num2str(graphSize)];
        save(standKernValuesFilename, 'stdKrnValues', ...
            'standardKernelRuntime', 'stdDists');
    end
    
    %% Sampling
   
   
    
    
    smpLstKrnValues = cell(nMValues, nTrials);
    smpLstDists = cell(nMValues, nTrials);
    smpLstRunTimes = zeros(nMValues, nTrials);
    
    smpFstKrnValues = cell(nMValues, nTrials);
    smpFstDists = cell(nMValues, nTrials);
    smpFstRunTimes = zeros(nMValues, nTrials);
    smpFstOps = zeros(nMValues, nTrials);
    
    vorKrnValues = cell(nMValues, nTrials);
    vorDists = cell(nMValues, nTrials);
    vorRunTimes = zeros(nMValues, nTrials);
    vorOps = zeros(nMValues, nTrials);
    
    %%
    if doSampleLast
        disp('SampleLast kernel:')
        % compute sampleLast kernel: kernel values, runtimes
        for i = 1:nMValues
            for j = 1:nTrials
                t = cputime;
                [smpLstKrnValues{i, j}, smpLstDists{i,j}] = ...
                    sampleLastKernel(Graphs, ...
                    ms(i), shortestPathMatrices);
                smpLstRunTimes(i, j) = cputime - t;
                disp(['Finished trial ' num2str(j) ' out of ' ...
                    num2str(nTrials) ' for m-value ' num2str(ms(i))])
            end
        end
        
        
        smpLstValuesFilename = ...
            ['./my_code/data/smpLstKrnVal_', dataset ...
            num2str(graphSize)];
        if doSaveDists
            save(smpLstValuesFilename, 'smpLstKrnValues', ...
                'smpLstRunTimes', 'smpLstDists');
        else
            save(smpLstValuesFilename, 'smpLstKrnValues', ...
                'smpLstRunTimes');
        end
    end
    
    %%
    
    if doSampleFirst
        disp('SampleFirst kernel:')
        % compute sampleFirst kernel
        for i = 1:nMValues
            for j = 1:nTrials
                t = cputime;
                [smpFstKrnValues{i, j}, smpFstDists{i,j}, ...
                    smpFstOps(i,j)] = ...
                    sampleFirstKernel(Graphs, ms(i));
                disp(['Finished trial ' num2str(j) ' out of ' ...
                    num2str(nTrials) ' for m-value ' num2str(ms(i))])
                smpFstRunTimes(i, j) = cputime - t;
            end
        end
        
        sampFstValuesFilename = ...
            ['./my_code/data/smpFstKrnVal_', dataset ...
            num2str(graphSize)];
        if doSaveDists
            save(sampFstValuesFilename, 'smpFstKrnValues', ...
                'smpFstRunTimes', 'smpFstOps', 'smpFstDists');
        else
            save(sampFstValuesFilename, 'smpFstKrnValues', ...
                'smpFstRunTimes', 'smpFstOps');
        end
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
                nVorNodes = size(vorAdj{i}, 1);
                groupingMats{i} = repmat(groupings{i},1,nVorNodes) == ...
                    repmat(1:nVorNodes, graphSize, 1);
            end
            
            
            % compute Voronoi kernel
            %for i = 1:nMValues
            for i = nMValues
                for j = 1:nTrials
                    t = cputime;
                    
%                     voronoiKernelValues{i, j} = ...
%                         voronoiKernel(Graphs, ms(i), groupings, ...
%                         vorAdj);
                    [vorKrnValues{i, j}, vorDists{i,j}, vorOps(i,j)] = ...
                        voronoiKernel(Graphs, ms(i), groupingMats, ...
                        vorAdj);
                    disp(['Finished trial ' num2str(j) ' out of ' ...
                        num2str(nTrials) ' for m-value ' ...
                        num2str(ms(i)), ' and density ' ...
                        num2str(density)])
                    vorRunTimes(i, j) = cputime - t;
                end
            end
            
            vorValuesFilename = ...
                ['./my_code/data/vorKrnVal_', dataset ...
                num2str(graphSize) '_' num2str(density) '.mat'];
            if doSaveDists
                save(vorValuesFilename, 'vorKrnValues', ...
                    'vorRunTimes', 'vorOps', 'vorDists');
            else
                save(vorValuesFilename, 'vorKrnValues', ...
                    'vorRunTimes', 'vorOps');
            end
            
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


