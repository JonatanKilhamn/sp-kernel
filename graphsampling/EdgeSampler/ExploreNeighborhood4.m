function count = ExploreNeighborhood4(A, L, i, j)
%EXPLORENEIGBORHOOD4 Summary of this function goes here
%   Author: Otto

w = [1/24, 1/12, 1/4, 0, 1/8, 1/2]; % 1/number of length-3 paths in graphlets of type 1-6 respectively
count = zeros(1,6);
for k=L{j}
    if k~=i
        for l=L{k}
            if l~=i && l~=j
                aux = A(i,k)+A(i,l)+A(j,l);
                if aux==3 % if there are 6 edges in the graphlet, then it
                    % is fully connected
                    count(1)=count(1)+w(1);
                else
                    if aux==2 % if there are 5 edges in the graphlet,
                        % then it is of type 2
                        count(2)=count(2)+w(2);
                    else
                        if aux==1 % if there are 4 edges, then it is either
                            % of type 3 or 5
                            if A(i,l)==1 % if i and l are connected, it is of
                                % type 5, 3 otherwise
                                count(5)=count(5)+w(5);
                            else
                                count(3)=count(3)+w(3);
                            end
                        else count(6)=count(6)+w(6); % the only connected
                            % graphlet with 3
                            % edges is that of
                            % type 6
                        end
                    end
                end
            end
        end
    end
end



%%%% count "stars" %%%%
N=length(L{i});
jj = j;
for j=1:N-2
    for k=j+1:N-1
        for l=k+1:N % with this kind of enumeration we make sure
            % that i, j, k, l, and m are pairwise different
            if L{i}(j) == jj
                if A(L{i}(j),L{i}(k))==0 && A(L{i}(j),L{i}(l))==0 && A(L{i}(k),L{i}(l))==0
                    count(4)=count(4)+1;
                end
            end
        end
    end
end
%%%% end count "stars" %%%%

end

