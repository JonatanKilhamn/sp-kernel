% Generates .mat-files of synthetic graph data, choose one of the types.

clear all;
clc;

% number_of_graphs = 20;
% p_value = 0.3;
% node_intervall = [15, 20];

dataset_name = input('Dataset name: ', 's');
graph_model = input('Graph model (ba/er/kron): ', 's');

if strcmp(graph_model, 'ba')
    graph_gen = 'MakeBAMat';
elseif strcmp(graph_model, 'er')
    graph_gen = 'MakeERMat';
elseif strcmp(graph_model, 'kron')
    graph_gen = 'MakeKRONMat';
end

node_min = input('Smallest n: ');
node_max = input('Largest n: ');
node_intervall = [node_min, node_max];
number_of_graphs = input('Number of graphs: ');
create_two = input('Create two datasets with different p? (y/n) :', 's');

if create_two == 'y'
    p1 = input('Parameter/init matrix for set 1: ');
    p2 = input('Parameter/init matrix for set 2: ');
    data1 = eval([graph_gen, '( number_of_graphs, p1, node_intervall )']);
    l1 = ones(number_of_graphs,1);
    data2 = eval([graph_gen, '( number_of_graphs, p2, node_intervall )']);
    l2 = 2*ones(number_of_graphs,1);
    l = [l1; l2];
    data = [data1, data2];
else
    p = input('Parameter: ');
    label = input('Label (1,2,3,...): ');
    data = eval([graph_gen, '( number_of_graphs, p, node_intervall )']);
    l = label * ones(number_of_graphs,1);
end

lstr = ['l', dataset_name];

eval([lstr, '=l;']);
eval([dataset_name, '=data;']);

save(dataset_name, lstr, dataset_name);