experiment_setup;

dataset = 'GENP';

paramsFilename = ...
    ['./my_code/data/params_', dataset];
load(paramsFilename);

sizesToRun = sizes(1:5);
densitiesToRun = densities(1:2);


section = 1;
noOfSections = 1;
%disp('Cleared the section assignment');

for graphSize = sizesToRun
    dataFilename = ['./my_code/data/', dataset, ...
        num2str(graphSize)];
    load(dataFilename)
    % we now have GRAPHS and lgraphs loaded
    
    for density = densitiesToRun
        
        vorPreFilename = ['./my_code/data/vorPre_', dataset ...
            num2str(graphSize) '_' num2str(density)];
        vorPreRuntimeFilename = ...
            ['./my_code/data/vorPreRuntime_', dataset ...
            num2str(graphSize) '_' num2str(density)];
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
        vorAdj = cell(1, nGraphs);
        groupings = cell(1, nGraphs);
        vorPreRuntimes = zeros(1, nGraphs);
        vorPreOps = zeros(1, nGraphs);
        
        startInd = floor((section-1)*(nGraphs/noOfSections))+1;
        stopInd = floor(section*(nGraphs/noOfSections));
        
        t = cputime; % for measuring runtime
        % compute shortest paths
        disp(['Entered voronoi loop for graph size ' ...
             num2str(graphSize) ' and density ' num2str(density)]);
        for i=startInd:stopInd
            
            ti = cputime;
            [vorAdj{i}, groupings{i}, vorPreOps(i)] = ...
                voronoi_preprocessing(GRAPHS(i).am, density);
            vorPreRuntimes(i) = cputime - ti;
            save(vorPreFilename, 'vorAdj', 'groupings', '-v7.3');
            save(vorPreRuntimeFilename, 'vorPreRuntimes', '-v7.3');
            disp(['Finished voronoi preprocessing on graph ', ...
                num2str(i), ', working toward ', num2str(stopInd)]);
        end
        disp(['Processing  ', num2str(nGraphs), ' graphs took ', ...
            num2str(cputime-t), ' sec']);
        
        save(vorPreFilename, 'vorAdj', 'groupings', '-v7.3');
        save(vorPreRuntimeFilename, 'vorPreRuntimes', 'vorPreOps', '-v7.3');
    end
end
