%% Setup

experiment_setup;

% sample subgraphs of size 100, 200, 500, 1 000, 2 000, 5 000,
% 10 000, 20 000
sizes = [100, 200, 500, 1000, 2000, 5000, 10000, 20000];

%%

sizesToRun = sizes(1:3);

for graphSize = sizesToRun
    %% Pick out the data
    
    roadDataFilename = ['./my_code/data/ROADS' ...
        num2str(graphSize)];
    load(roadDataFilename)
    % we now have ROADS and lroads loaded
    fwFilename = ['./my_code/data/fw_ROADS' ...
        num2str(graphSize)];
    load(fwFilename)
    % we now have fwROADS and fwRuntimesROADS loaded
    smpFstFilename = ['./my_code/data/smpFstKrnVal_ROADS' ...
        num2str(graphSize)];
    load(smpFstFilename)
    % we now have sampleFirstKernelValues and sampleFirstRunTimes loaded
    smpLstFilename = ['./my_code/data/smpLstKrnVal_ROADS' ...
        num2str(graphSize)];
    load(smpLstFilename)
    % we now have sampleLastKernelValues and sampleLastRunTimes loaded
    stdKrnFilename = ['./my_code/data/stdKrnVal_ROADS' ...
        num2str(graphSize)];
    load(stdKrnFilename)
    % we now have standardKernelValues and standardKernelRuntime loaded
    paramsFilename = ...
        ['./my_code/data/params_ROADS' ...
        num2str(graphSize)];
    load(paramsFilename)
    % we now have nTrials, ms, and graphSize
    
    nGraphs = size(ROADS, 2);
    
    Graphs = ROADS;
    labels = lroads;
    shortestPathMatrices = fwROADS;
    
    nMValues = length(ms);
    
    %% Accuracy reference number
    % run svm for non-sampling kernel, to get reference numbers
    
    % i.e. partition needs to be in two labeled sets
    
    disp('Computing standard kernel accuracy:')
    
    K = cell(1,1);
    K{1} = standardKernelValues;
    
    [standardKernelSvmRes] = runsvm(K,labels);
    stdKrnAccuracy = standardKernelSvmRes.mean_acc;
    
    refAccFilename = ...
        ['./my_code/data/stdAcc_ROADS' ...
        num2str(graphSize)];
    save(refAccFilename, 'stdKrnAccuracy');
    
    
    
    %% Comparison across sample numbers
    % compare kernel values from different sample numbers,
    % different kernels, to the standard sp-kernel
    % also runtime and accuracy
    
    % Two separate sampled kernels -> two columns of values
    
    smpFstAvgError = zeros(nMValues, 1);
    smpLstAvgError = zeros(nMValues, 1);
    %smpFstAvgAccuracy = zeros(nMValues, 1);
    %smpLstAvgAccuracy = zeros(nMValues, 1);
    
    smpFstAvgRunTimes = mean(sampleFirstRunTimes, 2);
    smpLstavgRunTimes = mean(sampleLastRunTimes, 2);
    
    
    %% Errors:
    
    disp('Computing kernel value errors')
    
    for i = 1:nMValues
        sampleLastError = 0;
        sampleFirstError = 0;
        for j = 1:nTrials
            sampleLastK = sampleLastKernelValues{i,j};
            sampleLastError = sampleLastError + ...
                sum(sum(abs(sampleLastK-standardKernelValues))) / ...
                (nGraphs^2);
            
            sampleFirstK = sampleFirstKernelValues{i,j};
            sampleFirstError = sampleFirstError + ...
                sum(sum(abs(sampleFirstK-standardKernelValues))) / ...
                (nGraphs^2);
            
        end
        smpLstAvgError(i) = sampleLastError/nTrials;
        smpFstAvgError(i) = sampleFirstError/nTrials;
    end
    %
    
    % store the error values:
    errorsFilename = ...
        ['./my_code/data/errVal_ROADS' ...
        num2str(graphSize)];
    save(errorsFilename, 'smpLstAvgError', 'smpFstAvgError');
    
    
    %% Accuracy:
    
    disp('Computing sampling kernel classification accuracies:')
    
    cellK = cell(1,1);
    
    sampleFirstAccuracy = zeros(nMValues, nTrials);
    sampleLastAccuracy = zeros(nMValues, nTrials);
    
    for i = 1:nMValues
        for j = 1:nTrials
            
            disp('Acc. for SampleLast kernel')
            sampleLastK = sampleLastKernelValues{i,j};
            cellK{1} = sampleLastK;
            [res] = runsvm(cellK, labels);
            sampleLastAccuracy(i,j) = res.mean_acc;
            
            disp('Acc. for SampleFirst kernel')
            sampleFirstK = sampleFirstKernelValues{i,j};
            cellK{1} = sampleFirstK;
            [res] = runsvm(cellK, labels);
            sampleFirstAccuracy(i,j) = res.mean_acc;
            
            disp(['Finished accuracies for trial ', num2str(j), ', m-value ', ...
                num2str(i)]);
            
        end
        disp(['Finished accuracies for all trials, m-value ', num2str(i), ...
            ' out of ', num2str(nMValues)]);
    end
    smpLstAvgAccuracy = mean(sampleLastAccuracy, 2);
    smpFstAvgAccuracy = mean(sampleFirstAccuracy, 2);
    
    % store the accuracy values
    accFilename = ...
        ['./my_code/data/accVal_ROADS' ...
        num2str(graphSize)];
    save(accFilename, 'smpLstAvgAccuracy', 'smpFstAvgAccuracy');
    
end

% Overview:


% accuracy: use all trials for sample-last, build mean accuracy per graph
% size, per sample size
% for now: ignore sample-first since it should be the same anyway
% UPDATE 2015-10-15: try using both and see if it can be done (i.e., will
% computations take less than, like, a week)

% error: use all trials for both sample-last and and sample-first





