function nSamples = getNSamples(epsilon, delta)
if nargin < 2
    delta = 0.1;
end
if nargin < 1
    epsilon = 0.1;
end

nSamples = ceil((15*log(2) + log(1/(1-sqrt(1-delta))))/(2*epsilon));

end