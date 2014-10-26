function count = ExploreNeighborhood3(A, L, i, j)
%EXPLORENEIGHBORHOOD3 Summary of this function goes here
%   Detailed explanation goes here

w = [1/2, 1/6]; % 1/number of length-2 paths in graphlets of type 1 and type 2 respectively
count = [0,0];

for k=L{j}
    if k~=i
        if A(i,k)
            count(2)=count(2)+w(2);
        else
            count(1)=count(1)+w(1);
        end
    end
end

end

