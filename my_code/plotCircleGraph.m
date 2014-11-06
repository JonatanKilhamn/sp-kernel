function pl = plotCircleGraph(am)

N = size(am, 1);
degs = (1:N)*(2*pi)/N;
xs = cos(degs);
ys = sin(degs);

pl = plot(xs,ys, '--ko'); hold on
[row, col] = find(am);
for i = 1:length(row)
    plot([xs(row(i)), xs(col(i))], [ys(row(i)), ys(col(i))], '-');
end
