experiment_setup;

dataset = 'ROADS';

sizes = [100, 200, 500, 1000, 2000, 5000, 10000, 20000];

sizesToRun = sizes(7);

section = 1;
noOfSections = 8;
disp('Cleared the section assignment');

for graphSize = sizesToRun
    dataFilename = ['./my_code/data/', dataset ...
        num2str(graphSize)];
    load(dataFilename)
    % we now have GRAPHS and lgraphs loaded
    nGraphs = size(GRAPHS, 2);
    
    if (noOfSections == 1)
        fwFilename = ['./my_code/data/fw_', dataset ...
            num2str(graphSize)];
        fwRuntimeFilename = ...
            ['./my_code/data/fwRuntime_', dataset ...
            num2str(graphSize)];        
    else
        fwFilename = ['./my_code/data/fw_', dataset ...
            num2str(graphSize) '-' num2str(section)];
        fwRuntimeFilename = ...
            ['./my_code/data/fwRuntime_', dataset ...
            num2str(graphSize) '-' num2str(section)];
    end
    %load(fwFilename)
    %load(fwRuntimeFilename)
    % now we have fw and fwRuntimes
    % if this is the first run for this size, replace load with the
    % following:
    fw = cell(1, nGraphs);
    fwRuntimes = zeros(1, nGraphs);
    
    
    startInd = floor((section-1)*(nGraphs/noOfSections))+1;
    stopInd = floor(section*(nGraphs/noOfSections));
    
    t = cputime; % for measuring runtime
    % compute shortest paths
    disp('Entered floyd-warshal loop');
    for i=startInd:stopInd
        ti = cputime;
        fw{i} = floydwarshall_mod(GRAPHS(i).am);
        fwRuntimes(i) = cputime - ti;
        disp(['Finished F-W on graph ', num2str(i), ', working toward ', ...
            num2str(stopInd)]);
        save(fwFilename, 'fw', '-v7.3');
        save(fwRuntimeFilename, 'fwRuntimes', '-v7.3');
        
        
    end
    disp(['Processing  ', num2str(nGraphs), ' graphs took ', ...
        num2str(cputime-t), ' sec']);
    
    save(fwFilename, 'fw', '-v7.3');
    save(fwRuntimeFilename, 'fwRuntimes', '-v7.3');
    
end
