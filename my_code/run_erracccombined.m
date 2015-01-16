function fin = run_erracccombined(dataset, maxSizeInd)
%% Setup

experiment_setup;

%dataset = 'PROTO';

paramsFilename = ...
    ['./my_code/data/params_', dataset];
load(paramsFilename);
nSizes = length(sizes);



doStandard = 1;
doSampleFirst = 1;
doSampleLast = 1;
doVoronoi = 1;


%%


stdAccuracy = zeros(1, nSizes);
smpFstAccuracies = zeros(nMValues, nSizes);
smpFstErrors = zeros(nMValues, nSizes);
smpFstDistErrors = zeros(nMValues, nSizes);

smpLstAccuracies = zeros(nMValues, nSizes);
smpLstErrors = zeros(nMValues, nSizes);
smpLstDistErrors = zeros(nMValues, nSizes);

vorErrors = zeros(nMValues, nSizes, nDensityFactors);
vorAccuracies = zeros(nMValues, nSizes, nDensityFactors);
vorDistErrors = zeros(nMValues, nSizes, nDensityFactors);

errAccFilename = ['./my_code/data/errAcc_', dataset];


save(errAccFilename, 'stdAccuracy', 'smpFstAccuracies', ...
    'smpFstErrors', 'smpFstDistErrors', 'smpLstAccuracies', ...
    'smpLstErrors', 'smpLstDistErrors', 'vorErrors', 'vorAccuracies', ...
    'vorDistErrors');


disp('Saved blank file')


%%

for i = 1:maxSizeInd
    %% Pick out the data
    graphSize = sizes(i);
    disp(['Combining error and accuracy data for size ', ...
        num2str(graphSize)]);
    
    %     dataFilename = ['./my_code/data/', dataset ...
    %         num2str(graphSize)];
    %     load(dataFilename)
    % we now have GRAPHS and lgraphs loaded
    errFilename = ['./my_code/data/errVal_', dataset ...
        num2str(graphSize)];
    load(errFilename)
    % we now have smpFstAvgError, smpLstAvgError and vorAvgError loaded
    accFilename = ['./my_code/data/accVal_', dataset ...
        num2str(graphSize)];
    load(accFilename)
    % we now have smpFstAvgAccuracy, smpLstAvgAccuracy and vorAvgAccuracy
    % loaded
    stdAccFilename = ['./my_code/data/stdAcc_', dataset ...
        num2str(graphSize)];
    load(stdAccFilename)
    % we now have stdKrnAccuracy loaded
    distErrFilename = ['./my_code/data/distErr_', dataset ...
        num2str(graphSize)];
    load(distErrFilename)
    % we now have stdKrnAccuracy loaded
    
    
    
    nMValues = length(ms);
    %%
    
    if doStandard
        stdAccuracy(i) = stdKrnAccuracy;
    end
    
    if doSampleFirst
        smpFstAccuracies(:, i) = smpFstAvgAccuracy;
        smpFstErrors(:, i) = smpFstAvgError(:, 1);
        smpFstDistErrors(:, i) = smpFstAvgDistError;
    end
    
    if doSampleLast
        smpLstAccuracies(:, i) = smpLstAvgAccuracy;
        smpLstErrors(:, i) = smpLstAvgError(:, 1);
        smpLstDistErrors(:, i) = smpLstAvgDistError;
    end
    
    if doVoronoi
        for j = 1:nDensityFactors
            vorErrors(:, i, j) = vorAvgError(:, j);
            vorDistErrors(:, i, j) = vorAvgDistError(:, j);
            vorAccuracies(:, i, j) = vorAvgAccuracy(:, j);
        end
    end
    
    
end



save(errAccFilename, 'stdAccuracy', 'smpFstAccuracies', ...
    'smpFstErrors', 'smpFstDistErrors', 'smpLstAccuracies', ...
    'smpLstErrors', 'smpLstDistErrors', 'vorErrors', 'vorAccuracies', ...
    'vorDistErrors');

disp('Saved final results')

fin = 1;


end

