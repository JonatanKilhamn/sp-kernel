function PlotGraph( G,n )
%PLOTGRAPH Plot graph on circle with edges

figure

x = cos(2*pi.*(1/n:1/n:n));
y = sin(2*pi.*(1/n:1/n:n));

gplot(G,[x' y']);
hold on
scatter(x,y,50,'filled');
axis square;

end

