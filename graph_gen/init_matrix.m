function matrix = init_matrix( n, mu, sigma )
%INIT_MATRIX Summary of this function goes here
%   Detailed explanation goes here

matrix = zeros(n);
coords = linspace(-1,1,n);

for i = 1:n
    for j = 1:n
        matrix(i,j) = mvnpdf([coords(i), coords(j)], mu, sigma);
    end
end

matrix = matrix./max(max(matrix));
surf(matrix)

end

