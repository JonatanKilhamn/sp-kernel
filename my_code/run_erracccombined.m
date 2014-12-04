%% Setup

experiment_setup;

dataset = 'GENP';

paramsFilename = ...
    ['./my_code/data/params_', dataset];
load(paramsFilename);
nSizes = length(sizes);

toRun = 5;

%%

    
stdAccuracy = zeros(1, nSizes);
smpFstAccuracies = zeros(nMValues, nSizes);
smpFstErrors = zeros(nMValues, nSizes);
smpFstDistErrors = zeros(nMValues, nSizes);

smpLstAccuracies = zeros(nMValues, nSizes);
smpLstErrors = zeros(nMValues, nSizes);
smpLstDistErrors = zeros(nMValues, nSizes);

vorErrors = zeros(nMValues, nSizes, nDensities);
vorAccuracies = zeros(nMValues, nSizes, nDensities);
vorDistErrors = zeros(nMValues, nSizes, nDensities);

errAccFilename = ['./my_code/data/errAcc_', dataset];
load(errAccFilename)



%%

for i = toRun
    %% Pick out the data
    graphSize = sizes(i);
    disp(['Combining error and accuracy data for size ', num2str(graphSize)]);

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
    
    stdAccuracy(i) = stdKrnAccuracy;

    smpFstAccuracies(:, i) = smpFstAvgAccuracy;
    smpFstErrors(:, i) = smpFstAvgError;
    smpFstDistErrors(:, i) = smpFstAvgDistError;

    smpLstAccuracies(:, i) = smpLstAvgAccuracy;
    smpLstErrors(:, i) = smpLstAvgError;
    smpLstDistErrors(:, i) = smpLstAvgDistError;
    
    for j = 1:nDensities
        vorErrors(:, i, j) = vorAvgError(:, j);
        vorDistErrors(:, i, j) = vorAvgDistError(:, j);
        vorAccuracies(:, i, j) = vorAvgAccuracy(:, j);
    end
    
    
    
end

save(errAccFilename, 'stdAccuracy', 'smpFstAccuracies', ...
    'smpFstErrors', 'smpFstDistErrors', 'smpLstAccuracies', ...
    'smpLstErrors', 'smpLstDistErrors', 'vorErrors', 'vorAccuracies', ...
    'vorDistErrors');

