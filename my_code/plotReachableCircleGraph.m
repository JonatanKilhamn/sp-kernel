function plotReachableCircleGraph(am, startIndex)

N = size(am, 1);

[row, col] = find(am);
reached = zeros(1, N);
queue = zeros(1, N);
queue(startIndex) = 1;
while sum(queue) > 0
    nodes = find(queue);
    node = nodes(1);
    connected = col(row == node);
    new = zeros(1, N);
    for i = 1:length(connected)
        if ~reached(connected(i))
            new(connected(i)) = 1;
        end
    end
    queue = max(queue, new);
    queue(node) = 0;
    reached(node) = 1;
    disp(['Reached node ' num2str(node)]);
end




degs = (1:N)*(2*pi)/N;
xs = cos(degs);
ys = sin(degs);
figure(1)
clf
plot(xs, ys, 'k.');
hold on
for i = 1:length(row)
    xsToDraw = [xs(row(i)), xs(col(i))];
    ysToDraw = [ys(row(i)), ys(col(i))];
    if reached(row(i)) == 1
        plot(xs(row(i)),ys(row(i)), 'og');
        plot(xs(col(i)),ys(col(i)), 'og');
        plot(xsToDraw, ysToDraw, '-g');
    else 
        plot(xsToDraw, ysToDraw, '-b');
        plot(xs(row(i)),ys(row(i)), 'ob');
        plot(xs(col(i)),ys(col(i)), 'ob');
    end
end
