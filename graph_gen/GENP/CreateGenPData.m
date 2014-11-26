function [success, dataset] = CreateGenPData(graphSize, nGraphs, p1, p2)
%sizeOfSampled = 100;
%nGraphs = 120;

dataset = 'GENP';

filename = ['./my_code/data/', dataset, num2str(graphSize)];


[GRAPHS, lgraphs] = er_set(ceil(nGraphs/2), graphSize, p1, p2);

save(filename, 'GRAPHS', 'lgraphs');

success = 1;

end

