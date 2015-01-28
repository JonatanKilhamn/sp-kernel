function [graphs, labels] = gauss_set(N, n, p1, p2)


inc = 0.1;
threshold = 5*inc;



labels = [zeros(N,1); ones(N,1)];

ams = cell(1,2*N);
als = cell(1,2*N);
nls = cell(1,2*N);

for i=1:N
    
    A = gaussGraph(n, p1, inc, threshold);
    while ~isconnected(A)
        A = gaussGraph(n, p1, inc, threshold);
    end
    
    al = cell(n,1);
    for j=1:n
        al{j} = find(A(j,:));
    end
    nl= struct();
    nl.values = ones(n,1);
    
    ams{i} = A;
    als{i} = al;
    nls{i} = nl;
    
    A = gaussGraph(n, p2, inc, threshold);
    while ~isconnected(A)
        A = gaussGraph(n, p2, inc, threshold);
    end
    
    al = cell(n,1);
    for j=1:n
        al{j} = find(A(j,:));
    end
    nl= struct();
    nl.values = ones(n,1);
    
    ams{N+i} = A;
    als{N+i} = al;
    nls{N+i} = nl;
    disp(['Done with step ', num2str(i), ' out of ', num2str(N)])
end


graphs = struct('am',ams,'al',als,'nl',nls);
