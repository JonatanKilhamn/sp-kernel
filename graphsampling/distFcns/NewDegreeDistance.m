function q = NewDegreeDistance(am1, al1, am2, al2)
%NEWDEGREEDISTANCE Summary of this function goes here
%   TBA

als1 = cellfun(@sort, al1, 'UniformOutput', false);
als2 = cellfun(@sort, al2, 'UniformOutput', false);

ll = cellfun(@isequal, als1, als2);
idx = find(~ll);

a1 = al1{idx};
a2 = al2{idx};

q = length(a1)/length(a2);

end

