function [graphs, labels] = er_set(N,n,p1,p2)

labels = [zeros(N,1); ones(N,1)];

ams = cell(2*N,1); als = cell(2*N,1); nls = cell(2*N,1);
for i=1:N
    
    A = erdosRenyi(n,p1);
    while any(all(~A,2))
        A = erdosRenyi(n,p1);
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
    
    A = erdosRenyi(n,p2);
    while any(all(~A,2))
        A = erdosRenyi(n,p2);
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

