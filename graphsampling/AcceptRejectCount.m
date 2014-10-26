function count = AcceptRejectCount(am, al, t, k)
%ACCCEPTREJECT Acceptance-Rejection sampling of induced subgraphs
%

n = size(al,1);
if k == 3
    count = zeros(1,2);
    countfunction = @countconnected3graphlets;
elseif k == 4
    count = zeros(1,6);
    countfunction = @countconnected4graphlets;
elseif k == 5
    count = zeros(1,21);
    countfunction = @countconnected5graphlets;
else
    fprintf('Not supported for size: %d',k);
    return
end
    
for i = 1:t
    if mod(i,10000) == 0
        fprintf('Progress: %f\n',i/t);
    end
    vSet = randperm(n,k); % select k nodes
    % make am for these nodes
    tmp_am = zeros(k);
    for v1 = 1:length(vSet)
        for v2 = 1:length(vSet)
            tmp_am(v1,v2) = am(vSet(v1),vSet(v2));
        end
    end
    % make al
    tmp_al = createAdjList(tmp_am);
    
    % count and update
    new_count = countfunction(tmp_am,tmp_al);
    count = count + new_count;
end

end

