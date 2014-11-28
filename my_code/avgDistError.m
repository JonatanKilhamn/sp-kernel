function avgError = avgDistError(dists1, dists2)

% Computes the total distribution error between two sets of distributions;
% they must be the same size but they may differ in number of trailing
% zeros.
%
% Input: dists1, dists2: cell structures of size n x 1
%
% Output: the total error sum_i { | dists1_i - dists2_i | }


n = length(dists1);

distLengths = zeros(n, 2);
for i = 1:n
    distLengths(i,1) = length(dists1{i});
    distLengths(i,2) = length(dists2{i});
end
maxLength = max(max(distLengths));



avgError = 0;
for i = 1:n
    dist1 = padToLength(dists1{i}, maxLength);
    dist2 = padToLength(dists2{i}, maxLength);
    avgError = avgError + sum(abs(dist1-dist2));
end

avgError = avgError / n;

end
