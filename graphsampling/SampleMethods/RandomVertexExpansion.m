function vSet = RandomVertexExpansion(al, am, k)
%RANDOMVERTEXEXPANSION Summary of this function goes here
%   Detailed explanation goes here

% Check for empty nodes
nonEmptyList = cellfun(@isempty, al);
n = length(al);
vSet = 1:n;
vSet(nonEmptyList) = [];

edgeList = zeros(k-1, 2);

% First step
nPrime = length(vSet);
idx = randi(nPrime);
edgeList(1,1) = vSet(idx);
a = al{idx};
nA = length(a);
idx2 = randi(nA);
edgeList(1,2) = a(idx2);

for i = 2:k-1
    possibleEdgeList = getPossibleNeighbors(edgeList, al);
    nP = size(possibleEdgeList,1);
    idxK = randi(nP);
    edgeList(i,:) = possibleEdgeList(idxK,:);
end

vSet = unique(edgeList);
end

function possibleEdgeList = getPossibleNeighbors(edgeList, al)
    % First, remove all of the zero entries in edgeList
    rmIdx = find(edgeList==0, 1, 'first');
    edgeList(rmIdx:end,:) = [];
    
    % Next, find out how many possible edges we can find
    nodeList = unique(edgeList);
    nbrPossibleEdges = sum(cellfun(@length, al(nodeList)));
    
    % Init list and iterate
    possibleEdgeList = zeros(nbrPossibleEdges, 2);
    startIdx = 1;
    for i = 1:length(nodeList)
        iN = nodeList(i);
        a = al{iN};
        % Pop edges that already are in edgeList
        a(ismember(a,nodeList)) = [];
        % Construct a list with new possible edges
        nbrNewEdges = length(a);
        tmpList(:, 2) = a';
        tmpList(:, 1) = iN;
        
        % Add to new list
        possibleEdgeList(startIdx:startIdx+nbrNewEdges-1,:) = tmpList;
        clear('tmpList');
        startIdx = startIdx + nbrNewEdges;        
    end
    
    % Finally, remove the elements that were not filled
    rmIdx = find(possibleEdgeList == 0, 1, 'first');
    possibleEdgeList(rmIdx:end,:) = [];
end


% function possibleEdgeList = getPossibleNeighbors(edgeList, al)
% % edgeList is k x 2 array
% % al is n x 1 cell array containing the adjacency lists 
% rmIdx = find(~edgeList, 1, 'first');
% edgeList(rmIdx:end,:) = [];
% k = size(edgeList,1);
% nodes = unique(edgeList);
% nodes(nodes==0) = [];
% maxNbr = sum(cellfun(@length, al(nodes)));
% possibleEdgeList = zeros(maxNbr,2);
% for i = 1:k
%     iE = edgeList(i,:);
%     % Get all adjacent nodes and create new list
%     neighbors = al{iE(1)};
%     tmpList(:,2) = neighbors';
%     tmpList(:,1) = iE(1);
%     nNeighbors = length(neighbors);
%     % Add to possible neigbors
%     idx = find(~possibleEdgeList, 1, 'first');
%     possibleEdgeList(idx:idx+nNeighbors-1,:) = tmpList;
%     tmpList(:) = [];
%     
%     neighbors = al{iE(2)};    
%     tmpList(:,2) = neighbors';
%     tmpList(:,1) = iE(2);
%     nNeighbors = length(neighbors);
%     % Add to possible neigbors
%     idx = find(~possibleEdgeList, 1, 'first');
%     possibleEdgeList(idx:idx+nNeighbors-1,:) = tmpList;
%     tmpList(:) = [];
% end %for
% toRmv = logical(prod(ismember(possibleEdgeList, edgeList),2)); % find out which are in the list already
% firstZero = find(possibleEdgeList==0, 1, 'first');
% toRmv(firstZero:end, :) = 1;
% possibleEdgeList(toRmv,:) = [];
% 
% end % getPossibleNeighbors