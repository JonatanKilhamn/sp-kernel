function fin = run_sl(dataset, sizeInd)

experiment_setup;

fin = 1;

run_kernels(dataset, sizeInd, 0, 1, 0, 0, 0, 0, 1);

end
