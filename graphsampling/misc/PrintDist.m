function PrintDist(freq, time, method)
%PRINTDIST Summary of this function goes here
%   Detailed explanation goes here

n = length(freq);

nStr = repmat('%0.3f ', 1, n);
str = [method,' dist: ', nStr, ' in (%0.3f s)\n'];
fprintf(str, freq, time);

end

