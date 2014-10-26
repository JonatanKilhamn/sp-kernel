    al = data(startSet + i).al;
    am = data(startSet + i).am;addpath(genpath([pwd, '/..']));

dataset = 'DD';
n = 150;
tMix = [90 180 270 500];
k = 5;
nbrRuns = length(tMix);
nbrRep = 10;

load(dataset)
data = eval(dataset);
al = data(101).al;
am = data(101).am;

result = zeros(nbrRuns, nbrRep);

for i = 1:nbrRuns
    iT = tMix(i);
    for j = 1:nbrRep
       [freq2, t2] = SampleGraphlets(al, am, k, n, 'mhs', iT); 
       result(i,j) = freq2(13)/n;
    end
    disp(i/nbrRuns)
end

meanResult = mean(result,2);
plot(tMix, meanResult);