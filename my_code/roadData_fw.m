experiment_setup;

sizes = [100, 200, 500, 1000, 2000, 5000, 10000, 20000];

sizesToRun = sizes(6);

section = 1;


for graphSize = sizesToRun
    roadDataFilename = ['./my_code/data/ROADS' ...
        num2str(graphSize)];
    load(roadDataFilename)
    % we now have ROADS and lroads loaded
    nGraphs = size(ROADS, 2);
    
    fwFilename = ['./my_code/data/fw_ROADS' ...
        num2str(graphSize) '-' num2str(section)];
    fwRuntimeFilename = ...
        ['./my_code/data/fwRuntime_ROADS' ...
        num2str(graphSize) '-' num2str(section)];
    %load(fwFilename)
    %load(fwRuntimeFilename)
    % now we have fwROADS and fwRuntimesROADS
    % if this is the first run for this size, replace load with the
    % following:
    fwROADS = cell(1, nGraphs);
    fwRuntimesROADS = zeros(1, nGraphs);
    
    
    startInd = floor((section-1)*(nGraphs/8))+1;
    stopInd = floor(section*(nGraphs/8));
    
    t = cputime; % for measuring runtime
    % compute shortest paths
    disp('Entered floyd-warshal loop');
    for i=startInd:stopInd
        ti = cputime;
        fwROADS{i} = floydwarshall(ROADS(i).am);
        fwRuntimesROADS(i) = cputime - ti;
        disp(['Finished F-W on graph ', num2str(i), ', working toward ', ...
            num2str(stopInd)]);
        save(fwFilename, 'fwROADS', '-v7.3');
        save(fwRuntimeFilename, 'fwRuntimesROADS', '-v7.3');
        
        
    end
    disp(['Processing  ', num2str(nGraphs), ' graphs took ', ...
        num2str(cputime-t), ' sec']);
    
    save(fwFilename, 'fwROADS', '-v7.3');
    save(fwRuntimeFilename, 'fwRuntimesROADS', '-v7.3');
    
end
