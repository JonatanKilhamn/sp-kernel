%% Setup

experiment_setup;

% sample subgraphs of size 100, 200, 500, 1 000, 2 000, 5 000,
% 10 000, 20 000
sizes = [100, 200, 500, 1000, 2000, 5000, 10000, 20000];
nSizes = length(sizes);

toRun = 1:5;

%%

paramsFilename = './my_code/data/params_ROADS100';
load(paramsFilename)
% use any params because they are all the same; the matrices created by
% this script are only possible if the same ms are used for all graph sizes
% We now have nTrials, ms, graphSize and densities
nMValues = length(ms);
nDensities = length(densities);
    
stdAccuracy = zeros(1, nSizes);
smpFstAccuracies = zeros(nMValues, nSizes);
smpFstErrors = zeros(nMValues, nSizes);
smpLstAccuracies = zeros(nMValues, nSizes);
smpLstErrors = zeros(nMValues, nSizes);
vorErrors = zeros(nMValues, nSizes, nDensities);
vorAccuracies = zeros(nMValues, nSizes, nDensities);

errAccFilename = './my_code/data/errAcc_ROADS';
%load(errAccFilename)



%%

for i = toRun
    %% Pick out the data
    
    graphSize = sizes(i);

%     roadDataFilename = ['./my_code/data/ROADS' ...
%         num2str(graphSize)];
%     load(roadDataFilename)
    % we now have ROADS and lroads loaded
    errFilename = ['./my_code/data/errVal_ROADS' ...
        num2str(graphSize)];
    load(errFilename)
    % we now have smpFstAvgError, smpLstAvgError and vorAvgError loaded
    accFilename = ['./my_code/data/accVal_ROADS' ...
        num2str(graphSize)];
    load(accFilename)
    % we now have smpFstAvgAccuracy, smpLstAvgAccuracy and vorAvgAccuracy
    % loaded
    stdAccFilename = ['./my_code/data/stdAcc_ROADS' ...
        num2str(graphSize)];
    load(stdAccFilename)
    % we now have stdKrnAccuracy loaded
    paramsFilename = ...
        ['./my_code/data/params_ROADS' ...
        num2str(graphSize)];
    load(paramsFilename)
    % we now have nTrials, ms, graphSize and nGraphs loaded

    
    
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

