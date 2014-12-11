function tf = isconnected(am)

%[~, pred, ~] = graphtraverse(am, 1, 'Directed', false, 'Method', 'DFS');
[disc,pred,close] = graphalgs('bfs', 0, false, am, 1, Inf);
tf = ~any(isnan(pred));
end
