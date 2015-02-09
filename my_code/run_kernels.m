%% Setup
function fin = run_kernels(dataset, sizeInd, doStandard, doSampleLast, ...
    doSampleFirst, doVoronoi, doWL, doGraphlets, doSaveDists)

experiment_setup;

%dataset = 'GENP';

paramsFilename = ...
    ['./my_code/data/params_', dataset];
load(paramsFilename)


sizesToRun = sizes(sizeInd);



densityFactorsToRun = densityFactors(1:3);


%%

%doStandard = 0;
%doSampleLast = 0;
%doSampleFirst = 1;
%doVoronoi = 1;


%doSaveDists = 1;

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
    
    %% Our kernels
    
    smpLstKrnValues = cell(nMValues, nTrials);
    smpLstDists = cell(nMValues, nTrials);
    smpLstRunTimes = zeros(nMValues, nTrials);
    
    smpFstKrnValues = cell(nMValues, nTrials);
    smpFstDists = cell(nMValues, nTrials);
    smpFstRunTimes = zeros(nMValues, nTrials);
    smpFstOps = zeros(nMValues, nTrials);
    
    vorKrnValues = cell(nMValues, nVorPreTrials, nVorTrials);
    vorDists = cell(nMValues, nVorPreTrials, nVorTrials);
    vorRunTimes = zeros(nMValues, nVorPreTrials, nVorTrials);
    vorOps = zeros(nMValues, nVorPreTrials, nVorTrials);
    
    %% Reference kernels
    
    %no need to preallocate wlKrnValues
    
    graphletKrnValues = cell(nMValues, nTrials);
    graphletRunTimes = zeros(nMValues, nTrials);

    
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
    
    %%
    
    if doVoronoi
        disp('Voronoi kernel:')
        for density = densityFactorsToRun
            % loading
            vorPreFilename = ['./my_code/data/vorPre_', dataset ...
                num2str(graphSize) '_' num2str(density) '.mat'];
            load(vorPreFilename);
            % We now have vorAdj and groupings
            
            groupingMats = cell(nGraphs, nVorPreTrials);
            for i = 1:nGraphs
                N = length(Graphs(i).am);
                for j = 1:nVorPreTrials
                    nVorNodes = size(vorAdj{i, j}, 1);
                    groupingMats{i, j} = ...
                        repmat(groupings{i,j}, 1, nVorNodes) == ...
                        repmat(1:nVorNodes, N, 1);
                end
            end
            
            
            % compute Voronoi kernel
            for i = 1:nMValues
            %for i = nMValues
                for j = 1:nVorPreTrials
                    for k = 1:nVorTrials
                        t = cputime;
                        
                        [vorKrnValues{i, j, k}, vorDists{i, j, k}, ...
                            vorOps(i, j, k)] = ...
                            voronoiKernel(Graphs, ms(i), ...
                            groupingMats(:, j), vorAdj(:, j));
                        % TODO: send in shortest-path-matrix
                        vorRunTimes(i, j, k) = cputime - t;
                    end
                    disp(['Finished trial set ' num2str(j) ' out of ' ...
                        num2str(nVorPreTrials) ' for m-value ' ...
                        num2str(ms(i)), ' and density ' ...
                        num2str(density)])
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
    
    %% Weisfeiler-Lehman
    
    if doWL
        disp('Weisfeiler-Lehman kernel:')
        
        hmax = max(hs);
        % compute WL kernel
        [wlKrnValues, wlRunTimes] = WL(Graphs, hmax,0);
        disp(['Finished W-L kernel for for h-values 0 through ' ...
            num2str(hmax)]);
    
        wlValuesFilename = ...
            ['./my_code/data/wlKrnVal_', dataset ...
            num2str(graphSize)];
        save(wlValuesFilename, 'wlKrnValues', ...
            'wlRunTimes');
        
    end
    
    %% Graphlet kernel
    
    if doGraphlets
        disp('Graphlet sampling kernel:')
        
        UnweightedGraphs = makeGraphsUnweighted(Graphs);
        
        % compute WL kernel
        for i = 1:nMValues
            for j = 1:nTrials
                [graphletKrnValues{i,j}, graphletRunTimes(i,j)] = ...
                    gestkernel3(UnweightedGraphs, ms(i));
            end
            disp(['Finished graphlet kernel for for m-value ' ...
                num2str(ms(i))])
        end
        graphletValuesFilename = ...
            ['./my_code/data/graphletKrnVal_', dataset ...
            num2str(graphSize)];
        save(graphletValuesFilename, 'graphletKrnValues', ...
            'graphletRunTimes');
        
        
    end
    
end

fin = 1;

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


