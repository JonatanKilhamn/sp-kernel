function tf = isconnected_OLD(vSet, al)
k = length(vSet);
visited = zeros(k,1);
inProgress = visited;
unVisisted = visited+1;
tmpAl = al(vSet);
if all(DoDfs(vSet(1), vSet, tmpAl, visited, inProgress, unVisisted))
    tf = true;
else
    tf = false;
end
end

function visited = DoDfs(v, vSet, al, visited, inProgress, unVisited)
% DFS algorithm
idx = vSet == v;
inProgress(idx) = 1;
unVisited(idx) = 0;
a = al{idx};

for i = 1:length(a)
    iV = a(i);
    nextIdx = vSet == iV; % Must be unique
    if ~isempty(nextIdx) && unVisited(nextIdx)
        visited = DoDfs(iV, vSet, al, visited, inProgress, unVisited);
    end       
end
visited(idx) = 1;
end
