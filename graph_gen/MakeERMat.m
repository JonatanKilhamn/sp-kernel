function output = MakeERMat( number_of_graphs, p_value,...
    n_intervall )
%MAKEERMAT Generates output of ER-graphs for SVM classification
%   number_of_graphs = the number of graphs in dataset
%   p_value = the desired probability for edges
%   n_intervall = intervall for size of network [n_min, n_max]
%   Author: Carl Retzner, 2014

if length(n_intervall) ~= 2
    disp('Error: n_intevall must be vector of size 2');
    return;
end

output = struct;

for i = 1:number_of_graphs
    
    n = randi(n_intervall,1);
    G = erdosRenyi(n,p_value); % generate graph
    
    A = createAdjList(G);
    output(i).am = sparse(G);
    output(i).al = A;
end

end

