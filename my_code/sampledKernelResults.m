function [Ks, avgErrors, runtimes] = sampledKernelResults(AllDs, ms, nbrOfTrials, refKs)
% input:
%
% AllDs is a 1 x nbrOfPoints cell structure. AllDs{i} contains a
% cell structure with distances for one set of graphs. If the same
% graphs are used for all data points, AllDs{i} = Ds for all i.
%
% ms is a vector of length nbrOfPoints containing the m values to use
% for each point
%
% refK is a 1 x nbrOfPoints cell structure with the kernel values for the
% unsampled kernel

nbrOfPoints = length(AllDs);
Ks = cell(1,nbrOfPoints);
avgErrors = zeros(nbrOfPoints,1);
runtimes = zeros(nbrOfPoints,1);

%nbrOfTrials = 50;

for i = 1:nbrOfPoints
    Ds = AllDs{i};
    N = length(Ds);
    error = 0;
    time = 0;
    for j = 1:nbrOfTrials
        [Ksamp, t, ~, ~] = NormSPkernelFromDsSampled(Ds, 'm', ms(i));
        time = time + t;
        error = error + sum(sum(abs(Ksamp-refKs{i})))/(N^2);
    end
    Ks{i} = Ksamp;
    avgErrors(i) = error/nbrOfTrials;
    runtimes(i) = time/nbrOfTrials;
end


end