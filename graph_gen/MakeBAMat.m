function output = MakeBAMat( number_of_graphs, k_value,...
    n_intervall )
%MAKEERMAT Generates output of BA-graphs for SVM classification
%   number_of_graphs = the number of graphs in dataset
%   k_value = the desired sparsity of the graph
%   n_intervall = intervall for size of network [n_min, n_max]
%   Author: Carl Retzner, 2014

if length(n_intervall) ~= 2
    disp('Error: n_intevall must be vector of size 2');
    return;
end

output = struct;

for i = 1:number_of_graphs
    
    n = randi(n_intervall,1);
    G = barabasi_albert(n,k_value); % generate graph
    
    A = createAdjList(G);
    output(i).am = sparse(G);
    output(i).al = A;
end

end

