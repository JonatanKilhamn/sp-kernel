function [nbrConnected] = AcceptReject2(am, al, k, t)
%ACCCEPTREJECT Acceptance-Rejection sampling of induced subgraphs
%

n = size(al,1);
nbrConnected = 0;
for i = 1:t
    if mod(i,10000) == 0
        fprintf('Progress: %f\n',i/t);
    end
    vSet = randperm(n,k); % select k nodes
    if isconnected(am(vSet, vSet))
        nbrConnected = nbrConnected + 1;
    end
end

end

