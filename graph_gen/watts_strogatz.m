function G = watts_strogatz( n, k, beta )
%WATTS_STROGATZ Returns a small-world random graph generated according to
%the Watts-Strogatz model of n nodes, mean degree k and parameter beta.

if (mod(k,2) ~= 0)
    fprintf('Error: k must be an even integer.\nExiting\n')
    return
end

% initial graph: regular lattice ring
G = zeros(n);

% connect to k/2 closest neighbours in each direction
for i = 1:n
    for j = -k/2:k/2
        neighbour =  mod(i + j, n);
        if neighbour == 0
            neighbour = n;
        end
        G(i, neighbour) = 1;
    end
    G(i,i) = 0;
end

% modify edges (n_i, n_j) for i < j
adjList = createAdjList(G);
for i = 1:n
    currentAdjList = adjList{i};
    newAdjList = currentAdjList( currentAdjList <= i );
    currentAdjList( currentAdjList <= i ) = [];
    
    while ~isempty(currentAdjList)
        if rand < beta
            possibleNodes = 1:n;
            possibleNodes(i) = [];
            possibleNodes(ismember(possibleNodes,newAdjList)) = [];
            newAdjList = [newAdjList, possibleNodes(randi(...
                length(possibleNodes)))];
        else
            newAdjList = [newAdjList, currentAdjList(end)];
        end
        currentAdjList(end) = [];
    end    
    adjList{i} = newAdjList;
end

G = zeros(n);

for i = 1:n
    for j = 1:length(adjList{i})
        G(i,adjList{i}(j)) = 1;
    end
end

figure
%gplot(A,xy)
x = cos(2*pi.*(1/n:1/n:n));
y = sin(2*pi.*(1/n:1/n:n));

%[x y h] = graph_draw(A);
gplot(G,[x' y']);
hold on
scatter(x,y,50,'filled');
axis square;

end

