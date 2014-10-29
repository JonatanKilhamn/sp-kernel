% fejk-experiment

experiment_setup;

filename = './my_code/data/fake_result';
pwd

interval = 1;

maxMin = 0.1;

nIntervals = maxMin*60/interval;

t = 0;

for i = 1:nIntervals
    pause(interval)
    t = t+interval;
    disp(t);
    save(filename, 't');
end
