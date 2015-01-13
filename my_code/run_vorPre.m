experiment_setup;

dataset = 'PROTO';

paramsFilename = ...
    ['./my_code/data/params_', dataset];
load(paramsFilename);

sizesToRun = sizes(1:6);
densityFacToRun = densityFactors(1:3);


section = 1;
noOfSections = 1;
%disp('Cleared the section assignment');

for graphSize = sizesToRun
    dataFilename = ['./my_code/data/', dataset, ...
        num2str(graphSize)];
    load(dataFilename)
    % we now have GRAPHS and lgraphs loaded
    
    for densityFactor = densityFacToRun
        
        vorPreFilename = ['./my_code/data/vorPre_', dataset ...
            num2str(graphSize) '_' num2str(densityFactor)];
        vorPreRuntimeFilename = ...
            ['./my_code/data/vorPreRuntime_', dataset ...
            num2str(graphSize) '_' num2str(densityFactor)];
        if (noOfSections ~= 1)
            vorPreFilename = [vorPreFilename '_' num2str(section)];
            vorPreRuntimeFilename = [vorPreRuntimeFilename '_' ...
                num2str(section)];
        end
        
        vorPreFilename = [vorPreFilename '.mat'];
        vorPreRuntimeFilename = [vorPreRuntimeFilename '.mat'];
            
        %load(fwFilename)
        %load(fwRuntimeFilename)
        % now we have fw and fwRuntimes
        % if this is the first run for this size, replace load with the
        % following:
        vorAdj = cell(nGraphs, nVorPreTrials);
        groupings = cell(nGraphs, nVorPreTrials);
        vorShortestPaths = cell(nGraphs, nVorPreTrials);
        vorPreRuntimes = zeros(nGraphs, nVorPreTrials);
        vorPreOps = zeros(nGraphs, nVorPreTrials);
        
        startInd = floor((section-1)*(nGraphs/noOfSections))+1;
        stopInd = floor(section*(nGraphs/noOfSections));
        
        t = cputime; % for measuring runtime
        % compute shortest paths
        disp(['Entered voronoi loop for graph size ' ...
             num2str(graphSize) ' and density ' num2str(densityFactor)]);
        for i=startInd:stopInd
            
            density = graphSize^(-2/3)*densityFactor;
            
            for j=1:nVorPreTrials
                ti = cputime;
                [vorAdj{i,j}, groupings{i,j}, vorPreOps(i,j)] = ...
                    voronoi_preprocessing(GRAPHS(i).am, density);
                
                
                vorPreRuntimes(i,j) = cputime - ti;
                save(vorPreFilename, 'vorAdj', 'groupings', '-v7.3');
                save(vorPreRuntimeFilename, 'vorPreRuntimes', '-v7.3');
            end
            disp(['Finished voronoi preprocessing on graph ', ...
                num2str(i), ', working toward ', num2str(stopInd)]);
        end
        disp(['Processing  ', num2str(nGraphs), ' graphs took ', ...
            num2str(cputime-t), ' sec']);
        
        save(vorPreFilename, 'vorAdj', 'groupings', 'vorShortestPaths', ...
            '-v7.3');
        save(vorPreRuntimeFilename, 'vorPreRuntimes', 'vorPreOps', '-v7.3');
    end
end
