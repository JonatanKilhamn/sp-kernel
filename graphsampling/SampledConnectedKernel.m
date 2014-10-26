function [K,runtime] = SampledConnectedKernel(Graphs, sampleFrac, gk, doDp, normalize, D, epsilon, linkernel)
%SAMPLEDCONNECTEDKERNEL Calculates the kernel matrix using sampled graphs
%   Input:  Graphs      1 x n stuct with graphs
%           sampleFrac  1 x 1 double sampling fraction
%           gk          1 x 1 int size of graphlet
%           doDp        1 x 1 bool differential privacy on/off
%           normalize   1 x 1 bool normalize on/off
%           epsilon     1 x 1 double privacy level
%           linKernel   1 x 1 bool linear kernel on/off

addNoise = doDp; % for DP computation
shape = 0;
n=length(Graphs);
switch gk
    case 3
        sz = 2;
        freq=zeros(n,2);
    case 4
        sz = 6;
        freq=zeros(n,6);
    case 5
        sz = 21;
        freq=zeros(n,21);
end

% If use differential privacy (restricted sensitivity)
if doDp    
    switch gk
        case 3
            shape = epsilon^-1 * sz*3*D^2;
        case 4
            shape = epsilon^-1 * sz*4*D^3;
        case 5
            shape = epsilon^-1 * sz*5*D^4;
    end
end
    
% If use projection
if D ~= Inf
    Graphs = ProjectToLower(Graphs, D);
end


tmp=cputime; % for measuring runtime
for i=1:n    
    % Sample according to fraction
    nbrNodes = length(Graphs(i).al);
    if round(sampleFrac*nbrNodes) < 100
        if nbrNodes > 100
            k = 100;
        else
            k = nbrNodes;
        end
    else
        k = round(sampleFrac*nbrNodes);
    end
    
    [freq(i,:)] = EdgeSampler(Graphs(i).am, Graphs(i).al, ceil(sampleFrac * nbrNodes), gk);
    % Add noise, normalize        
    freq(i,:) = (freq(i,:) + addNoise * LapNoise(0, shape, [1, sz]));
    if normalize && sum(freq(i,:)) ~= 0
        freq(i,:) = freq(i,:) ./ sum(freq(i,:));        
    end
    %freq(i,freq(i,:)>0) = 0;
    disp(i/n)
end
runtime = cputime - tmp;

if linkernel
    K = freq;
else
    K = freq * freq';
end

end
