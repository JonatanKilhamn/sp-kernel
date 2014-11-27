%% Setup

experiment_setup;

dataset = 'GENP';

paramsFilename = ...
    ['./my_code/data/params_', dataset];
load(paramsFilename);
nSizes = length(sizes);

toRun = 1;

%%

    
stdAccuracy = zeros(1, nSizes);
smpFstAccuracies = zeros(nMValues, nSizes);
smpFstErrors = zeros(nMValues, nSizes);
smpLstAccuracies = zeros(nMValues, nSizes);
smpLstErrors = zeros(nMValues, nSizes);
vorErrors = zeros(nMValues, nSizes, nDensities);
vorAccuracies = zeros(nMValues, nSizes, nDensities);

errAccFilename = ['./my_code/data/errAcc_', dataset];
%load(errAccFilename)



%%

for i = toRun
    %% Pick out the data
    
    graphSize = sizes(i);

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
    
    
    nMValues = length(ms);
    %%
    
    stdAccuracy(i) = stdKrnAccuracy;
    smpFstAccuracies(:, i) = smpFstAvgAccuracy;
    smpFstErrors(:, i) = smpFstAvgError;
    smpLstAccuracies(:, i) = smpLstAvgAccuracy;
    smpLstErrors(:, i) = smpLstAvgError;
    
    for j = 1:nDensities
        vorErrors(:, i, j) = vorAvgError(:, j);
        vorAccuracies(:, i, j) = vorAvgAccuracy(:, j);
    end
    
    
    
end

save(errAccFilename, 'stdAccuracy', 'smpFstAccuracies', ...
    'smpFstErrors', 'smpLstAccuracies', 'smpLstErrors', ...
    'vorErrors', 'vorAccuracies');

