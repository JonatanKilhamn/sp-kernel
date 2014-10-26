function [vSet, varargout] = AcceptReject(am, al, k)
%ACCCEPTREJECT Acceptance-Rejection sampling of induced subgraphs
%

n = size(al,1);
i = 0;
while true
    vSet = randperm(n,k); % select k nodes
    if isconnected(am(vSet, vSet))
        varargout{1} = i;
        return
    end
    i = i+1;
end

end

