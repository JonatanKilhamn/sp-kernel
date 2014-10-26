function [K,runtime] = SampledConnectedKernel(Graphs, sampleFrac, gk, t, p, dpOpt, D, epsilon, doNorm)
%SAMPLEDCONNECTEDKERNEL Calculates the kernel matrix using sampled graphs
%   Detailed explanation goes here

if ~exist('epsilon', 'var')
    epsilon = 1;
end

if ~exist('doNorm', 'var')
    doNorm = true;
end

addNoise = false; % for DP computation
shape = 0;
n=size(Graphs,2);
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
if dpOpt
    addNoise = true;
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

% Print progressbar
% Find width of cmd
wsz = matlab.desktop.commandwindow.size;
w = wsz(1);
printAt = round(linspace(1,n,w-2));
spc = repmat(32, 1, w-2);
spcstr = ['[', char(spc), ']'];
fprintf(spcstr);


tmp=cputime; % for measuring runtime
for i=1:n
    if any(printAt == i)        
        idx = find(printAt == i);
        %Remove str
        rmStr = ones(1,w)*8;
        addStr = spcstr;
        addStr(2:1+idx) =  35;
        fprintf(char(rmStr));
        fprintf(char(addStr));
    end
    
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
    
    [freq(i,:), nbrGraphlets] = LargeGraphSamplerNbr(Graphs(i).am, Graphs(i).al, k, gk, t, p);
    % Add noise, normalize    
    freq(i,:) = freq(i,:) + addNoise * LapNoise(0, shape, [1, sz]);
    if doNorm
        freq(i,:) = freq(i,:) ./ sum(freq(i,:));        
    end
end
runtime = cputime - tmp;

K = freq * freq';

end
