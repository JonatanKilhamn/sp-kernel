experiment_setup;

dataset = 'ROADS';

sizes = [100, 200, 500, 1000, 2000, 5000, 10000, 20000];

sizesToRun = sizes(1);

noOfSections = 8;
currentSection = 1;

for graphSize = sizesToRun
    
    dataFilename = ['./my_code/data/', dataset ...
        num2str(graphSize)];
    load(dataFilename)
    % we now have GRAPHS and lgraphs loaded
    nGraphs = size(GRAPHS, 2);
    
    
    % Use these two rows for the first section:
    %fwCombined = cell(1, nGraphs);
    %fwCombinedRuntimes = zeros(1, nGraphs);
    
    fwFilename = ['./my_code/data/fw_', dataset ...
        num2str(graphSize)];
    fwRuntimeFilename = ...
        ['./my_code/data/fwRuntime_', dataset ...
        num2str(graphSize)];
    % Use these rows for the other sections:
    load(fwFilename);
    load(fwRuntimeFilename);
    
    
    for section = currentSection
        fwSectionFilename = ['./my_code/data/fw_', dataset ...
            num2str(graphSize) '-' num2str(section)];
        fwSectionRuntimeFilename = ...
            ['./my_code/data/fwRuntime_', dataset ...
            num2str(graphSize) '-' num2str(section)];
        
        load(fwSectionFilename)
        load(fwSectionRuntimeFilename)
        % now we have fw and fwRuntimes
        
        
        startInd = floor((section-1)*(nGraphs/noOfSections))+1;
        stopInd = floor(section*(nGraphs/noOfSections));
        for i=startInd:stopInd
            fwCombined{i} = fw{i};
            fwCombinedRuntimes(i) = fwRuntimes(i);
        end
        
        clear('fwRuntimes');
        clear('fw');
        

        save(fwFilename, 'fwCombined', '-v7.3');
        save(fwRuntimeFilename, 'fwCombinedRuntimes', '-v7.3');
        
    end
 
    
end
disp('Done');
