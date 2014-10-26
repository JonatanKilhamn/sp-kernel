load ER3;

data = ER3;
t=length(data);
p=0.1:0.1:1;
maxRep = length(p);

nbrTimes = 30;

actualNbr = zeros(maxRep,1);
GRAFTNbr = zeros(maxRep,1);
absoluteError = zeros(maxRep,1);
relativeCoverage = zeros(maxRep,1);



tic
for i = 1:t
    res = countconnected5graphlets(data(i).am,data(i).al);
    actualNbr(i) = res(21);
end
t1 = toc;


disp(t1)

meanActualNbr = mean(actualNbr);

tic


for iRep = 1:maxRep   
    
for i = 1:t
    
    GRAFTNbr(i) = GRAFT(data(i).am,data(i).al,5,p(iRep));
    
end

meanGRAFTNbr = mean(GRAFTNbr);
absoluteError(iRep) = abs(meanActualNbr - (meanGRAFTNbr));
relativeCoverage(iRep) = (meanGRAFTNbr) / meanActualNbr;

end


t2 = toc / maxRep;
disp(t2)
plotyy(p,relativeCoverage,p,absoluteError);
