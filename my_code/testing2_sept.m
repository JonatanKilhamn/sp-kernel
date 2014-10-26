%% load data

%load('MUTAG.mat');
load('DD.mat');
%load('NCI1.mat');
%load('NCI109.mat');
%load('ENZYMES.mat');
load('spmatrices.mat');



%% partition data - use a certain number of graphs, or graphs of a certain size

firstInd = 1;
lastInd = 1178;

nGraphs = lastInd - firstInd + 1;

% alt 1: DD data, partition
Graphs = DD(firstInd:lastInd);
labels = ldd(firstInd:lastInd);
shortestPathMatrices = spDD(firstInd:lastInd);
costMatrices = cmDD(firstInd:lastInd);


graphSizes = zeros(1, nGraphs);
for i = 1:nGraphs
    graphSizes(i) = size(Graphs(i).nl.values, 1);
end



% alt 2: DD data, sorted by size (e.g. all DD graphs of size 200-400 nodes)

% alt 3: generated data (write own method to generate graphs

% alt 4: sample subgraphs from mega-large graphs from that other project

%% Compute kernels

% for all graphs in the partition

% compute standard sp-kernel: kernel values, runtime
t = cputime;
standardKernelValues = shortestPathKernel(Graphs, shortestPathMatrices);
standardKernelRuntime = cputime - t;

% sampling:
nTrials = 20; % compute all sampled kernels several times
%nTrials = 1;
ms = [20 40 60 80 100 150 200];
%ms = [10];
nMValues = length(ms);

%sampleLastKernelValues = cell(nMValues, nTrials);
%sampleLastRunTimes = zeros(nMValues, nTrials);

%sampleFirstKernelValues = cell(nMValues, nTrials);
%sampleFirstRunTimes = zeros(nMValues, nTrials);

%%

% load previous results; we're building the results one
% trial/m-value-combination at a time

sampleLastKernelValues = cell(nMValues, nTrials);
sampleLastRunTimes = zeros(nMValues, nTrials);

sampleFirstKernelValues = cell(nMValues, nTrials);
sampleFirstRunTimes = zeros(nMValues, nTrials);



trialsToRun = 1:20;
mValuesToRun = 2:7;


load('testing-2014-10-02.mat')


%%

disp('SampleLast kernel:')
% compute sampleLast kernel: kernel values, runtimes
for i = 1:nMValues
   for j = 1:nTrials
% for i = mValuesToRun;
%     for j = trialsToRun;
        t = cputime;
        sampleLastKernelValues{i, j} = sampleLastKernel(Graphs, ms(i), ...
            shortestPathMatrices);
        sampleLastRunTimes(i, j) = cputime - t;
        disp(['Finished trial ' num2str(j) ' out of ' num2str(nTrials), ...
            ' for m-value ' num2str(ms(i))])
    end
end


%%

disp('SampleFirst kernel:')
% compute sampleFirst kernel
%for i = 1:nMValues
%    for j = 1:nTrials
for i = mValuesToRun;
    for j = trialsToRun;
        t = cputime;
        sampleFirstKernelValues{i, j} = sampleFirstKernel(Graphs, ms(i), ...
            costMatrices);
        disp(['Finished trial ' num2str(j) ' out of ' num2str(nTrials), ...
            ' for m-value ' num2str(ms(i))])
        sampleFirstRunTimes(i, j) = cputime - t;
    end
end

%% Accuracy reference number
% run svm for non-sampling kernel, to get reference numbers

% i.e. partition needs to be in two labeled sets

K = cell(1,1);
K{1} = standardKernelValues;

[standardKernelSvmRes] = runsvm(K,labels);
%res.optkernel



%% Comparison across sample numbers
% compare kernel values from different sample numbers,
% different kernels, to the standard sp-kernel
% also runtime and accuracy

% Two separate sampled kernels -> two columns of values

nSampledKernels = 2;

avgError = zeros(nMValues, nSampledKernels);
avgRunTimes = zeros(nMValues, nSampledKernels);
avgAccuracy = zeros(nMValues, nSampledKernels);

avgRunTimes(:, 1) = mean(sampleLastRunTimes, 2);
avgRunTimes(:, 2) = mean(sampleFirstRunTimes, 2);

sampleLastAccuracy = zeros(nMValues, nTrials);
sampleFirstAccuracy = zeros(nMValues, nTrials);


%% Errors:


for i = 1:nMValues
    sampleLastError = 0;
    sampleFirstError = 0;
    for j = 1:nTrials
          sampleLastK = sampleLastKernelValues{i,j};
         sampleLastError = sampleLastError + ...
             sum(sum(abs(sampleLastK-standardKernelValues))) / (nGraphs^2);

         sampleFirstK = sampleFirstKernelValues{i,j};
         sampleFirstError = sampleFirstError + ...
             sum(sum(abs(sampleFirstK-standardKernelValues))) / (nGraphs^2);
        
    end
    avgError(i, 1) = sampleLastError/nTrials;
    avgError(i, 2) = sampleFirstError/nTrials;
end
% 

%% Accuracy:

trialsToRun = 6;

cellK = cell(1,1);

for i = 1:nMValues
    for j = trialsToRun
        sampleLastK = sampleLastKernelValues{i,j};
     
        cellK{1} = sampleLastK;
        [res] = runsvm(cellK, labels);avgRunTimes(:, 1) = mean(sampleLastRunTimes, 2);
        sampleLastAccuracy(i,j) = res.mean_acc;

        sampleFirstK = sampleFirstKernelValues{i,j};

        cellK{1} = sampleFirstK;
        [res] = runsvm(cellK, labels);
        sampleFirstAccuracy(i,j) = res.mean_acc;
    end
end
avgAccuracy(:, 1) = mean(sampleLastAccuracy(:, 1:6), 2);
avgAccuracy(:, 2) = mean(sampleFirstAccuracy(:, 1:6), 2);

%% Show results
% 
figure(1)
plot(ms, avgError(:, 1), 'b*-', ms, avgError(:, 2), 'gx-')
axis([ms(1), ms(end), 0, 1.1*max(max(avgError))])
legend('SampleLast kernel', 'SampleFirst kernel', 'Location', 'NorthEast')
title(['Error in kernel value for sampled shortest-path kernel on DD (median size ' ...
    num2str(median(graphSizes)), ' nodes)'])
xlabel('No. of samples')
ylabel(['Mean kernel value error, nTrials = ', ...
    num2str(nTrials)])
%%
figure(2)
plot(ms, avgAccuracy(:, 1), ms, avgAccuracy(:, 2), ...
    [ms(1) ms(end)], [1 1]*standardKernelSvmRes.mean_acc, '--')
legend('SampleLast kernel', 'SampleFirst kernel', ...
    'Full kernel', 'Location', 'SouthEast')
title(['Classification accuracy on DD (median size ' ...
    num2str(median(graphSizes)), ' nodes)'])
xlabel('No. of samples')
ylabel(['Mean SVM classification accuracy %, nTrials = 6'])%, ...
%    num2str(nTrials)])
%%

preprocRunTime = sum(fwRuntimesDD);


figure(3)
semilogy(ms, avgRunTimes(:, 2), ...
    ms, avgRunTimes(:, 1), ...
    ms, (avgRunTimes(:,1)+preprocRunTime), '-x', ...
    [ms(1) ms(end)], [1 1]*(standardKernelRuntime), ...
    [ms(1) ms(end)], [1 1]*(standardKernelRuntime+preprocRunTime), '--k')
legend('SampleFirst', 'SampleLast', ...
    'SampleLast w/ preprocessing', ...
    'Standard', 'Standard w/ preprocessing', ...
    'Location', 'NorthWest')
title(['Kernel computation runtime on DD (median size ' ...
    num2str(median(graphSizes)), ' nodes)'])
xlabel('No. of samples')
ylabel('Mean query runtime')


figure(4)
plot(ms, avgRunTimes(:, 2), '-*', ...
    ms, avgRunTimes(:, 1), '-*')
legend('SampleFirst', 'SampleLast', ...
    'Location', 'NorthWest')
title(['Kernel computation runtime on DD (median size ' ...
    num2str(median(graphSizes)), ' nodes)'])
xlabel('No. of samples')
ylabel('Mean query runtime')

%% Store results


savefile = '~/dokument/exjobb/my_code/data/testing-2014-10-02';
save(savefile, ...
    'sampleLastRunTimes', ...
    'sampleFirstRunTimes', 'standardKernelValues', ...
    'avgError', ...
    'sampleFirstKernelValues', ...
    'avgAccuracy', ...
    'sampleLastAccuracy', 'sampleFirstAccuracy', ...
    'standardKernelSvmRes', 'ms', 'nTrials', 'trial', 'mValue');
    
    %'sampleLastKernelValues', ...