load('MUTAG.mat');
load('DD.mat');
load('NCI1.mat');
load('NCI109.mat');
load('ENZYMES.mat');

ms = [20 40 60 80 100 150 200];
nMValues = length(ms);

spDD = cell(1, size(DD,2));
cmDD = cell(1, size(DD,2));
fwRuntimesDD = zeros(1, size(DD,2));
cmRuntimesDD = zeros(1, size(DD,2));

sfSpDD = cell(nMValues, size(DD, 2));
sfSpRuntimesDD = zeros(nMValues, size(DD,2));

load('spmatrices.mat');

%%

startInd = 3;
stopInd = 200;

N = stopInd - startInd + 1;

%%
t = cputime; % for measuring runtime

% compute shortest paths

for i=startInd:stopInd
    ti = cputime;
    spDD{i} = floydwarshall(DD(i).am);
    % if rem(i,100)==0 disp(i); end
    fwRuntimesDD(i) = cputime - ti;
    disp(['Finished F-W on graph ', num2str(i), ', working toward ', ...
        num2str(stopInd)]);
end
disp(['Processing  ', num2str(N), ' graphs took ', ...
    num2str(cputime-t), ' sec']);


%% compute cost matrices
t = cputime;

for i=startInd:stopInd
    ti = cputime;
    
    
    adjacencyMatrix = DD(i).am;
    n = size(adjacencyMatrix, 1);

    if (ismember('el', fieldnames(DD(i))))
        %TODO: handle graphs with distance labels, i.e. not all distances
        % are 1
    end
    
    costMatrix = Inf(n,n); % If A(i,j)==0 and i~=j D(i,j)=Inf;
    filter = adjacencyMatrix~=0; % if A(i,j)=1...
    costMatrix(filter) = adjacencyMatrix(filter); % ... then D(i,j)=w(i,j);
    for j=1:n
        costMatrix(j,j)=0; % set the diagonal to zero
    end
    
    cmDD{i} = costMatrix;
    cmRuntimesDD(i) = cputime - ti;
    
    disp(['Finished cost matrix on graph ' num2str(i) ...
        ', working toward ' num2str(stopInd)]);
    
end

%% Compute sample-first shortest-path distributions (dijkstra's)

j = 1;
nSamples = ms(j);

for i=1:N
  sfSpDD{j, i} = ...
      sampleFirstShortestPathDistribution(costMatrices{i}, nSamples);
  disp(['Completed graph ' num2str(i) ' out of ' num2str(N)])
end


%%

savefile = 'data/spmatrices.mat';
save(savefile, 'spDD', 'fwRuntimesDD', 'cmDD', 'cmRuntimesDD', ...
    'sfSpDD', 'sfSpRuntimesDD', 'cmInfDD');