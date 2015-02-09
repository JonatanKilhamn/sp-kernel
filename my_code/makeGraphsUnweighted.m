function res = makeGraphsUnweighted(graphs)

N = length(graphs);
ams = cell(1, N);

for i = 1:N
    ams{i} = (graphs(i).am > 0);
end

res = struct('am',ams);
end
