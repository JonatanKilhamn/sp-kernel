function fin = run_sf(dataset, sizeInd)

experiment_setup;

fin = 1;

run_kernels(dataset, sizeInd, 0, 0, 1, 0, 1);

end
