load('MUTAG.mat');
load('DD.mat');
load('NCI1.mat');
load('NCI109.mat');
load('ENZYMES.mat');

%% Section off the data

% Use 'Graphs' and 'labels' for the relevant data
%Graphs = NCI1(1500:2000);
%labels = lnci1(1500:2000);
%Graphs = DD(650:700);
%labels = ldd(680:700);

Graphs = DD(680:720);
labels = ldd(680:720);

%% Calculate kernels and run svm cross-validation

epsilon = 0.1;
delta = 0.05;

% Include Kdumb, the kernel just returning 1, for fun
Ksp = NormSPkernel(Graphs);
Ksamp = NormSPkernelSampled(Graphs,'e',epsilon,'d',delta);
Kdumb = ones(size(Ksp));

Ks = cell(1,3);

Ks{1} = Ksp;
Ks{2} = Ksamp;
Ks{3} = Kdumb;


[res] = runsvm(Ks,labels);
res.optkernel

%% Just the Floyd-Warshall-step

N=size(Graphs,2);
Ds = cell(1,N); % shortest path distance matrices for each graph
t=cputime; % for measuring runtime

% compute Ds
sizes = zeros(1,N);
maxpath=0;
for i=1:N
    Ds{i}=floydwarshall(Graphs(i).am);
    % if rem(i,100)==0 disp(i); end
    disp(['Finished F-W on graph ', num2str(i), ' out of ', num2str(N)]);
end
disp(['The preprocessing step took ', num2str(cputime-t), ' sec']);

%% Calculating the kernels from known distance matrices
% also stores runtimes

% 1: setup

ms = [20 40 60 80 100 120 140 160 180 200];
Ks = cell(1,length(ms)+1);
avgErrors = zeros(length(ms),1);
runtimes = zeros(length(ms),1);

%%

% 2: reference kernel value

t=cputime;
refK = NormSPkernelFromDs(Ds);
Ks{length(ms)+1} = refK;
refRuntime = cputime-t;

%% 

% 3: sampled kernels

% several trials to averge errors and runtimes between
nbrOfTrials = 50;

for i = 1:length(ms)
%i = 1;
    error = 0;
    time = 0;
    for j = 1:nbrOfTrials
        %t = cputime;
        [Ksamp, t, ~, ~] = NormSPkernelFromDsSampled(Ds, 'm', ms(i));
        %time = time + cputime - t;
        time = time + t;
        error = error + sum(sum(abs(Ksamp-Ks{end})))/(N^2);
    end
    Ks{i} = Ksamp;
    avgErrors(i) = error/nbrOfTrials;
    runtimes(i) = time/nbrOfTrials;
end

%% Trying out sampledKernelResults.m
% Using the same graphs, different ms, to get the data from the previous
% section

nbrOfTrials = 50;
nbrOfPoints = length(ms);
allDs = cell(1,nbrOfPoints);
refKs = cell(1,nbrOfPoints);
for i = 1:nbrOfPoints
    allDs{i} = Ds;
    refKs{i} = refK;
end
[Ks, avgErrors, runtimes] = sampledKernelResults(allDs, ms, nbrOfTrials, refKs);



%%

figure(1);
plot(ms,avgErrors,'-*');
figure(2);
plot(ms,runtimes,'-*',[ms(1) ms(end)],[refRuntime refRuntime]);
axis([ms(1) ms(end) 0 (refRuntime*1.1)]);


%%

% Large graphs are interesting
% Use DD
% Wanted data:
% - kernel value accuracy compared to no. of samples
% - classification acc. compared to no. of samples
% - runtime compared to number of graphs in set
% - runtime compared to size of graphs

% NormSPkernel and -Sampled: DD(680:687) in 146 sec


% Write kernels NormSP and NormSPSampled which take the
% floyd-warshal distance matrix as input




