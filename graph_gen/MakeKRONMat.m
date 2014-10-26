function output = MakeKRONMat( number_of_graphs, init_matrix, ...
    n_intervall )
%MAKEKRONMAT Generates output of stochastic KRON-graphs for SVM classification
%   number_of_graphs = the number of graphs in dataset
%   path_to_snap = path to stanford snap c++ lib.
%   n_intervall = intervall for size of network [n_min, n_max]
%   init_matrix initial matrix
%   Author: Carl Retzner, 2014

path_to_snap = '/home/krettan/projects/skola/libs/snap';

if length(n_intervall) ~= 2
    disp('Error: n_intevall must be vector of size 2');
    return;
end

output = struct;

for i = 1:number_of_graphs
    
    n = randi(n_intervall,1);
    
    power = log(n)/log(size(init_matrix,1));
    k = floor(power);
    
    G = kron_gen(k, init_matrix, path_to_snap);
        
    A = createAdjList(G);
    output(i).am = sparse(G);
    output(i).al = A;
end

end

