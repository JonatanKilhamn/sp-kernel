%load DD
close all
data = DD;
nbr = 6;
sampleSize = 1600;
nbrRep = 25;

graphlets = 1:21;
cnt = zeros(nbrRep, 21);

am = data(nbr).am;
al = data(nbr).al;

nbrEdges = full(sum(sum(am)));

% tic
% orig = countconnected5graphlets(am, al);
% toc

for i = 1:nbrRep
%tic
cnt(i,:) = EdgeSampler(am, al, sampleSize, 5);
%toc
end
%cntn = cnt/sum(cnt);
orign = orig/sum(orig);



avgGraphlets = sum(orig)/nbrEdges;
avgGraphletsSample = sum(cnt) / nbrEdges;
figure;
plot(graphlets, mean(cnt), graphlets, orig);
figure;
plot(graphlets, orig - mean(cnt))