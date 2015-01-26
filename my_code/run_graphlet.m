function fin = run_graphlet(dataset, sizeInd)

experiment_setup;

fin = 1;

run_kernels(dataset, sizeInd, 0, 0, 0, 0, 0, 1, 1);

end
