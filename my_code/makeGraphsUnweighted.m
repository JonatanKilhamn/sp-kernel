function res = makeGraphsUnweighted(graphs)

N = size(graphs, 2);
ams = cell(N,1);

for i = 1:N
    ams{i} = (graphs(i).am > 0);
end

res = struct('am',ams);
end
