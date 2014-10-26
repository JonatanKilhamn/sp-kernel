clear variables

% Need data and graphletkernels on path
addpath(genpath([pwd, '/..']));

dataset = 'DD';
n = 150;
tMix = 100;
k = 5;
nbrDataSets = 1;

load(dataset)
data = eval(dataset);

startSet = 100;
for i = 1:nbrDataSets
    al = data(startSet + i).al;
    am = data(startSet + i).am;
%     Takes very long time!
%     [freq1, t1] = SampleGraphlets(al, k, n, 'ars', am);
%     PrintDist(freq1./n, t1, 'ars');
    [freq2, t2] = SampleGraphlets(al, am, k, n, 'mhs', tMix);
    PrintDist(freq2./n, t2, 'mhs');
%     [freq3, t3] = SampleGraphlets(al, k, n, 'rve');
%     PrintDist(freq3./n, t3, 'rve');
%     [freq4, t4] = SampleGraphlets(al, am, k, n, 'nrs');
%     PrintDist(freq4./n, t4, 'nrs');
    tic;
    freq5 = countconnected5graphlets(am, al);
    t5 = toc;
    PrintDist(freq5./sum(freq5), t5, 'all');
    fprintf('\n\n')
end