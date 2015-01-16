function fin = run_erracc(dataset, sizeInd)
%% Setup

if sizeInd ~= 0

experiment_setup;

%dataset = 'PROTO';

paramsFilename = ...
    ['./my_code/data/params_', dataset];
load(paramsFilename);

%sizes = [100, 200, 500, 1000, 2000, 5000, 10000, 20000];

%%

sizesToRun = sizes(sizeInd);

doStandard = 1;
doSampling = 1;
doVoronoi = 1;

for graphSize = sizesToRun
    %% Pick out the data
    
   
    appending = 0;
    
    
    dataFilename = ['./my_code/data/', dataset ...
        num2str(graphSize)];
    load(dataFilename)
    % we now have GRAPHS and lgraphs loaded
    
    if doSampling
        smpFstFilename = ['./my_code/data/smpFstKrnVal_', dataset ...
            num2str(graphSize)];
        load(smpFstFilename)
        % we now have smpLstKrnValues and smpLstRunTimes loaded
        smpLstFilename = ['./my_code/data/smpLstKrnVal_', dataset ...
            num2str(graphSize)];
        load(smpLstFilename)
    end
    
    if doStandard
        % we now have smpLstKrnValues and smpLstRunTimes loaded
        stdKrnFilename = ['./my_code/data/stdKrnVal_', dataset ...
            num2str(graphSize)];
        load(stdKrnFilename)
        % we now have stdKrnValues and standardKernelRuntime loaded
    end
    
    Graphs = GRAPHS;
    labels = lgraphs;
    
    nMValues = length(ms);
    
    %% Accuracy reference number
    % run svm for non-sampling kernel, to get reference numbers
    
    
    if doStandard
        % i.e. partition needs to be in two labeled sets
        
        disp('Computing standard kernel accuracy')
        
        K = cell(1,1);
        K{1} = stdKrnValues;
        
        stdTrialAcc = zeros(1,nTrials);
        for j = 1:nTrials
            [stdKrnSvmRes] = runsvm(K,labels);
            stdTrialAcc(j) = stdKrnSvmRes.mean_acc;
        end
        stdKrnAccuracy = mean(stdTrialAcc);
        
        refAccFilename = ...
            ['./my_code/data/stdAcc_', dataset ...
            num2str(graphSize)];
        save(refAccFilename, 'stdKrnAccuracy');
    end
    
    
    errorsFilename = ...
        ['./my_code/data/errVal_', dataset ...
        num2str(graphSize)];
    accFilename = ...
        ['./my_code/data/accVal_', dataset ...
        num2str(graphSize)];
    
    if doSampling
        
        %% Comparison across sample numbers
        % compare kernel values from different sample numbers,
        % different kernels, to the standard sp-kernel
        % also runtime and accuracy
        
        
        
        % Two separate sampled kernels -> two columns of values
        
        smpFstAvgError = zeros(nMValues, 4);
        smpLstAvgError = zeros(nMValues, 4);
        
        cellK = cell(1,1);
        sampleFirstAccuracy = zeros(nMValues, nTrials);
        sampleLastAccuracy = zeros(nMValues, nTrials);
        
        
        smpFstAvgRunTimes = mean(smpLstRunTimes, 2);
        smpLstavgRunTimes = mean(smpLstRunTimes, 2);
        
        
        %% Errors and accuracy:
        
        disp('Computing samplng kernels errors and acc.s')
        
        for i = 1:nMValues
            % 1: all mean
            % 2: only within label 0
            % 3: only within label 1
            % 4: only across labels
            sampleLastError = zeros(1,4);
            sampleFirstError = zeros(1,4);
            for j = 1:nTrials
                
                
                sampleLastK = smpLstKrnValues{i,j};
                sampleLastAllErrors = abs(sampleLastK-stdKrnValues);
                
                sampleLastError(1) = sampleLastError(1) + ...
                    sum(sum(sampleLastAllErrors)) / (nGraphs^2);
                sampleLastError(2) = sampleLastError(2) + ...
                    mean(mean(sampleLastAllErrors(labels==0, labels==0)));
                sampleLastError(3) = sampleLastError(3) + ...
                    mean(mean(sampleLastAllErrors(labels==1, labels==1)));
                sampleLastError(4) = sampleLastError(4) + ...
                    mean(mean(sampleLastAllErrors(labels==0, labels==1)));
                
                
                
                sampleFirstK = smpLstKrnValues{i,j};
                sampleFirstAllErrors = abs(sampleFirstK-stdKrnValues);
                sampleFirstError(1) = sampleFirstError(1) + ...
                    sum(sum(sampleFirstAllErrors)) / (nGraphs^2);
                sampleFirstError(2) = sampleFirstError(2) + ...
                    mean(mean(sampleFirstAllErrors(labels==0, labels==0)));
                sampleFirstError(3) = sampleFirstError(3) + ...
                    mean(mean(sampleFirstAllErrors(labels==1, labels==1)));
                sampleFirstError(4) = sampleFirstError(4) + ...
                    mean(mean(sampleFirstAllErrors(labels==0, labels==1)));
                
                
                
                
                disp('Acc. for SampleLast kernel')
                sampleLastK = smpLstKrnValues{i,j};
                cellK{1} = sampleLastK;
                [res] = runsvm(cellK, labels);
                sampleLastAccuracy(i,j) = res.mean_acc;
                
                disp('Acc. for SampleFirst kernel')
                sampleFirstK = smpLstKrnValues{i,j};
                cellK{1} = sampleFirstK;
                [res] = runsvm(cellK, labels);
                sampleFirstAccuracy(i,j) = res.mean_acc;
                
                disp(['Finished smpFst and smpLst, trial ', num2str(j), ...
                    ', m=', num2str(ms(i))]);
                
            end
            smpLstAvgError(i,:) = sampleLastError./nTrials;
            smpFstAvgError(i,:) = sampleFirstError./nTrials;
        end
        smpLstAvgAccuracy = mean(sampleLastAccuracy, 2);
        smpFstAvgAccuracy = mean(sampleFirstAccuracy, 2);
        
        
        if appending
            save(errorsFilename, 'smpLstAvgError', 'smpFstAvgError', ...
                '-append');
            save(accFilename, 'smpLstAvgAccuracy', 'smpFstAvgAccuracy', ...
                '-append');
        else
            save(errorsFilename, 'smpLstAvgError', 'smpFstAvgError');
            save(accFilename, 'smpLstAvgAccuracy', 'smpFstAvgAccuracy');
            appending = 1;
        end
        
    end %of "if doSampling"
    
    %     if ~doSampling
    %         errorsFilename = ...
    %             ['./my_code/data/errVal_', dataset ...
    %             num2str(graphSize)];
    %         load(errorsFilename);
    %         accFilename = ...
    %             ['./my_code/data/accVal_', dataset ...
    %             num2str(graphSize)];
    %         load(accFilename);
    %     end
    
    
    %% Voronoi, error and accuracy
    if doVoronoi
        vorAccuracy = zeros(nMValues, nVorPreTrials, nVorTrials);
        vorAvgAccuracy = zeros(nMValues, nDensityFactors);
        vorAvgError = zeros(nMValues, nDensityFactors);
        
        for d = 1:length(densityFactors)
            densityFactor = densityFactors(d);
            
            disp(['Voronoi kernel, density = ' num2str(densityFactor)])
            
            vorValuesFilename = ...
                ['./my_code/data/vorKrnVal_', dataset ...
                num2str(graphSize) '_' num2str(densityFactor) '.mat'];
            load(vorValuesFilename);
            
            
            
            
            %for i = 1:nMValues
            for i = nMValues
                vorError = 0;
                for j = 1:nVorPreTrials
                    for k = 1:nVorTrials
                        
                        % Error value
                        vorK = vorKrnValues{i, j, k};
                        vorError = vorError + ...
                            sum(sum(abs(vorK-stdKrnValues))) / ...
                            (nGraphs^2);
                        
                        % Accuracy
                        cellK{1} = vorK;
                        [res] = runsvm(cellK, labels);
                        vorAccuracy(i, j, k) = res.mean_acc;
                    end
                end
                disp(['Finished all trials, m = ' num2str(i)])
                vorAvgError(i, d) = vorError/nTrials;
            end
            vorAvgAccuracy(:,d) = mean(mean(vorAccuracy, 2), 3);
            
            if appending
                save(accFilename, 'vorAvgAccuracy', '-append');
                save(errorsFilename, 'vorAvgError', '-append');
            else
                save(accFilename, 'vorAvgAccuracy');
                save(errorsFilename, 'vorAvgError');
            end
        end
   
    end
    
end


end
fin = 1;

run_erracccombined(dataset, sizeInd);

end
% Overview:


% accuracy: use all trials for sample-last, build mean accuracy per graph
% size, per sample size
% for now: ignore sample-first since it should be the same anyway
% UPDATE 2015-10-15: try using both and see if it can be done (i.e., will
% computations take less than, like, a week)

% error: use all trials for both sample-last and and sample-first





