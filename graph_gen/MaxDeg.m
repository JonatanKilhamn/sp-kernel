function deg = MaxDeg( dataset )
%MAXDEG computes maximum degree of dataset

n = length(dataset);
deg = 0;

for i = 1:n
    tmpDeg = max(cellfun('length',dataset(i).al));
    if tmpDeg > deg
        deg = tmpDeg;
    end
end
fprintf('Maximum degree: %d\n', deg);
end

