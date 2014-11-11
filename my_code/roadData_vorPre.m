experiment_setup;

sizes = [100, 200, 500, 1000, 2000, 5000, 10000, 20000];

sizesToRun = sizes(1);

section = 1;
noOfSections = 1;
%disp('Cleared the section assignment');

for graphSize = sizesToRun
    roadDataFilename = ['./my_code/data/ROADS' ...
        num2str(graphSize)];
    load(roadDataFilename)
    % we now have ROADS and lroads loaded
    nGraphs = size(ROADS, 2);
    
    if (noOfSections == 1)
        vorPreFilename = ['./my_code/data/vorPre_ROADS' ...
            num2str(graphSize)];
        vorPreRuntimeFilename = ...
            ['./my_code/data/vorPreRuntime_ROADS' ...
            num2str(graphSize)];
    else
        vorPreFilename = ['./my_code/data/vorPre_ROADS' ...
            num2str(graphSize) '-' num2str(section)];
        vorPreRuntimeFilename = ...
            ['./my_code/data/vorPreRuntime_ROADS' ...
            num2str(graphSize) '-' num2str(section)];
    end
    %load(fwFilename)
    %load(fwRuntimeFilename)
    % now we have fwROADS and fwRuntimesROADS
    % if this is the first run for this size, replace load with the
    % following:
    vorAdjROADS = cell(1, nGraphs);
    groupingsROADS = cell(1, nGraphs);
    vorPreRuntimesROADS = zeros(1, nGraphs);
    
    
    startInd = floor((section-1)*(nGraphs/noOfSections))+1;
    stopInd = floor(section*(nGraphs/noOfSections));
    
    t = cputime; % for measuring runtime
    % compute shortest paths
    disp('Entered voronoi loop');
    for i=startInd:stopInd
        ti = cputime;
        [vorAdjROADS{i}, groupingsROADS{i}] = ...
            voronoi_preprocessing(ROADS(i).am);
        vorPreRuntimesROADS(i) = cputime - ti;
        disp(['Finished voronoi preprocessing on graph ', ...
            num2str(i), ', working toward ', num2str(stopInd)]);
        save(vorPreFilename, 'vorAdjROADS', 'groupingsROADS', '-v7.3');
        save(vorPreRuntimeFilename, 'vorPreRuntimesROADS', '-v7.3');
    end
    
    disp(['Processing  ', num2str(nGraphs), ' graphs took ', ...
        num2str(cputime-t), ' sec']);
    
    save(vorPreFilename, 'vorAdjROADS', 'groupingsROADS', '-v7.3');
    save(vorPreRuntimeFilename, 'vorPreRuntimesROADS', '-v7.3');
    
end
