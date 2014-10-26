experiment_setup;

sizes = [100, 200, 500, 1000, 2000, 5000, 10000, 20000];
nGraphs = 100;


for graphSize = sizes(3:end);
    CreateRoadData(graphSize, nGraphs)
end


