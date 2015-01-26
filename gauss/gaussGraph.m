function am = gaussGraph(n, p1, inc, threshold)

mu = [0 0];

Sigma = p1 * ...
    [1 0
    0 1];

R = chol(Sigma);
points = repmat(mu,n,1) + randn(n,2)*R;

am = zeros(n);

for i = 1:n
    distances = zeros(1,n);
    for j = 1:n
        if i == j
            am(i,j) = 1;
        else
            distances(j) = norm(points(i,:)-points(j,:));
            if distances(j) > threshold
                am(i,j) = 0;
            else
                am(i,j) = floor(distances(j) / inc);
            end
        end
    end
    if sum(am(i,:)) == 0
        [minDist, ind] = min(distances);
        am(i,ind) =  floor(minDist / inc);
    end
end

am = sparse(am);


end