function fin = run_disterr(dataset, sizeInd)
%% Setup

experiment_setup;

%dataset = 'PROTO';

paramsFilename = ...
    ['./my_code/data/params_', dataset];
load(paramsFilename);


%%

sizesToRun = sizes(sizeInd);

doSampling = 1;
doVoronoi = 1;

for graphSize = sizesToRun
    %% Pick out the data
    

    smpFstFilename = ['./my_code/data/smpFstKrnVal_', dataset ...
        num2str(graphSize)];
    load(smpFstFilename)
    % we now have smpFstKrnValues and smpFstRunTimes loaded
    smpLstFilename = ['./my_code/data/smpLstKrnVal_', dataset ...
        num2str(graphSize)];
    load(smpLstFilename)
    % we now have smpLstKrnValues and smpLstRunTimes loaded
    stdKrnFilename = ['./my_code/data/stdKrnVal_', dataset ...
        num2str(graphSize)];
    load(stdKrnFilename)
    % we now have stdKrnValues and standardKernelRuntime loaded
    

    
    
    smpLstAvgDistError = zeros(nMValues, 1);
    smpFstAvgDistError = zeros(nMValues, 1);
    
    disp('Computing sp distribution errors')
    
    if doSampling
        
        for i = 1:nMValues
            sampleLastError = 0;
            sampleFirstError = 0;
            for j = 1:nTrials
                sampleLastDists = smpLstDists{i,j};
                sampleLastError = sampleLastError + ...
                    avgDistError(sampleLastDists, stdDists);

                sampleFirstDists = smpFstDists{i,j};
                sampleFirstError = sampleFirstError + ...
                    avgDistError(sampleFirstDists, stdDists);
                
            end
            smpLstAvgDistError(i) = sampleLastError/nTrials;
            smpFstAvgDistError(i) = sampleFirstError/nTrials;
        end
        %
        
    end %of "if doSampling"
    
    % store the error values:
    errorsFilename = ...
        ['./my_code/data/distErr_', dataset ...
        num2str(graphSize)];
    save(errorsFilename, 'smpLstAvgDistError', 'smpFstAvgDistError');

    
    %% Voronoi, error and accuracy
    if doVoronoi

        vorAvgDistError = zeros(nMValues, nDensityFactors);
        
        for d = 1:nDensityFactors
            densityFactor = densityFactors(d);
            
            disp(['Voronoi kernel, density = ' num2str(densityFactor)])
            
            vorValuesFilename = ...
                ['./my_code/data/vorKrnVal_', dataset ...
                num2str(graphSize) '_' num2str(densityFactor) '.mat'];
            load(vorValuesFilename);
            
            
            for i = 1:nMValues
                vorError = 0;
                for j = 1:nTrials
                    
                voronoiDists = vorDists{i,j};
                vorError = vorError + ...
                    avgDistError(voronoiDists, stdDists);

                end
                disp(['Finished all trials, m = ' num2str(i)])
                vorAvgDistError(i, d) = vorError/(nVorPreTrials*nVorTrials);
            end
            
            save(errorsFilename, 'smpLstAvgDistError', 'smpFstAvgDistError', ...
                'vorAvgDistError');
            
        end
       
    end
    
    
    
end

fin = 1;

end



