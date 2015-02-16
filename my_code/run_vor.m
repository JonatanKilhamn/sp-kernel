function fin = run_vor(dataset, sizeInd)
experiment_setup;

paramsFilename = ...
    ['./my_code/data/params_', dataset];
load(paramsFilename);

fin = 1;

run_kernels(dataset, sizeInd, 0, 0, 0, 1, 0, 0, 1);

end
