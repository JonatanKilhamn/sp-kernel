datasets = cell(1,5);
datasets{1} = DD;
datasets{2} = ENZYMES;
datasets{3} = MUTAG;
datasets{4} = NCI1;
datasets{5} = NCI109;

datasetSizes = zeros(1,5);

for d = 1:length(datasets)
    acc = 0;
    for i=1:length(datasets{d})
        acc = acc+length(datasets{d}(i).am);
    end
    datasetSizes(d) = acc/length(datasets{d});
end
