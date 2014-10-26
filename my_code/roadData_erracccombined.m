%% Setup

experiment_setup;

% sample subgraphs of size 100, 200, 500, 1 000, 2 000, 5 000,
% 10 000, 20 000
sizes = [100, 200, 500, 1000, 2000, 5000, 10000, 20000];
nSizes = length(sizes);
%%

paramsFilename = './my_code/data/params_ROADS100';
load(paramsFilename)
% use any params because they are all the same; the matrices created by
% this script are only possible if the same ms are used for all graph sizes
% We now have nTrials, ms, and graphSize
nMValues = length(ms);
    
stdAccuracy = zeros(1, nSizes);
smpFstAccuracies = zeros(nMValues, nSizes);
smpFstErrors = zeros(nMValues, nSizes);
smpLstAccuracies = zeros(nMValues, nSizes);
smpLstErrors = zeros(nMValues, nSizes);


errAccFilename = './my_code/data/errAcc_ROADS';
load(errAccFilename)


%%%%%
%%%%%
%%%%% TODO: change the rest of this file to deal with errors and accuracy
%%%%% as opposed to runtimes


%%
for i = 1:4
    %% Pick out the data
    
    graphSize = sizes(i);
    
    roadDataFilename = ['./my_code/data/ROADS' ...
        num2str(graphSize)];
    load(roadDataFilename)
    % we now have ROADS and lroads loaded
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
    
    stdPrepRuntimes(i) = sum(fwRuntimesROADS);
    stdQueryRuntimes(i) = standardKernelRuntime;
    
    smpFstPrepRuntimes(:, i) = 0;
    smpFstErrors(:, i) = mean(sampleFirstRunTimes, 2);
    
    smpLstAccuracies(:, i) = sum(fwRuntimesROADS);
    smpLstErrors(:, i) = mean(sampleLastRunTimes, 2);

    
end

save(errAccFilename, 'stdPrepRuntimes', 'stdQueryRuntimes', ...
    'smpFstPrepRuntimes', 'smpFstQueryRuntimes', 'smpLstPrepRuntimes', ...
    'smpLstQueryRuntimes')

