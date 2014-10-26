experiment_setup;

% sample subgraphs of size 100, 200, 500, 1 000, 2 000, 5 000,
% 10 000, 20 000
sizes = [100, 200, 500, 1000, 2000, 5000, 10000, 20000];
nSizes = length(sizes);

paramsFilename = './my_code/data/params_ROADS100';
load(paramsFilename)
% use any params because they are all the same; the matrices created by
% this script are only possible if the same ms are used for all graph sizes
% We now have nTrials, ms, and graphSize
nMValues = length(ms);
runtimesFilename = './my_code/data/runtimes_ROADS';
load(runtimesFilename)
% loads stdPrepRuntimes, stdQueryRuntimes, smpFstPrepRuntimes, 
% smpFstQueryRuntimes, smpLstPrepRuntimes, smpLstQueryRuntimes

%%

toPlotInds = 1:4;

stdPrepRuntimes = stdPrepRuntimes(:, toPlotInds);
stdQueryRuntimes = stdQueryRuntimes(:, toPlotInds);
smpFstPrepRuntimes = smpFstPrepRuntimes(:, toPlotInds);
smpFstQueryRuntimes = smpFstQueryRuntimes(:, toPlotInds);
smpLstPrepRuntimes = smpLstPrepRuntimes(:, toPlotInds);
smpLstQueryRuntimes = smpLstQueryRuntimes(:, toPlotInds);

sizesToPlot = sizes(toPlotInds);

stdTotalRuntimes = stdPrepRuntimes+stdQueryRuntimes;
smpFstTotalRuntimes = smpFstPrepRuntimes+smpFstQueryRuntimes;
smpLstTotalRuntimes = smpLstPrepRuntimes+smpLstQueryRuntimes;

%% Show results
% 

figure(1)
semilogy(sizesToPlot, stdQueryRuntimes, '-x', ...
    sizesToPlot, smpLstQueryRuntimes(1, :), '-x', ...
    sizesToPlot, smpLstQueryRuntimes(end, :), '-x', ...
    sizesToPlot, smpFstQueryRuntimes(1, :), '-x', ...
    sizesToPlot, smpFstQueryRuntimes(end, :), '-x')%, ...
legend('Standard', 'SampleLast (m=10)', ...
    'SampleLast (m=200)', ...
    'SampleFirst (m=10)', 'SampleFirst (m=200)', ...
    'Location', 'SouthEast')
    %'Standard', 'Standard w/ preprocessing', ...
title(['Kernel computation query runtime on ROADSX w/ size(x) in [100, 1000]'])
xlabel('Graph size')
ylabel('Mean query runtime (over 20 trials)')

%%

figure(2)
semilogy(sizes, stdTotalRuntimes, '-x', ...
    sizes, smpLstTotalRuntimes(1, :), '-x', ...
    sizes, smpLstTotalRuntimes(end, :), '-x', ...
    sizes, smpFstTotalRuntimes(1, :), '-x', ...
    sizes, smpFstTotalRuntimes(end, :), '-x')%, ...
legend('Standard', 'SampleLast (m=10)', ...
    'SampleLast (m=200)', ...
    'SampleFirst (m=10)', 'SampleFirst (m=200)', ...
    'Location', 'NorthWest')
    %'Standard', 'Standard w/ preprocessing', ...
title(['Total kernel computation runtime on ROADSX (X in [100, 1000])'])
xlabel('Graph size')
ylabel('Mean runtime (over 20 trials)')

%%

graphSizeInd = 2;
graphSize = sizes(graphSizeInd);

figure(3)
semilogy([0 ms(end)+100], [1 1]*(stdQueryRuntimes(graphSizeInd)), ...
    [0 ms(end)+100], [1 1]*(stdTotalRuntimes(graphSizeInd)), 'k', ...
    ms, smpLstQueryRuntimes(:, graphSizeInd), '--o', ...
    ms, smpLstTotalRuntimes(:, graphSizeInd), '--o', ...
    ms, smpFstTotalRuntimes(:, graphSizeInd), '--o')
xlim([0 ms(end)*1.1])
legend('Standard, query', 'Standard, total', ...
    'SampleLast, query', 'SampleLast, total', ...
    'SampleFirst, total', ...
    'Location', 'NorthEastOutside')
title(['Kernel computation runtime on ROADS' num2str(graphSize)])
xlabel('No. of samples')
ylabel('Mean runtime (per query or in total)')

