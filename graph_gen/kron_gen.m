function G = kron_gen(k, init_matrix, path_to_snap)
% KRON_GEN Generates Kronecker random graphs by using stanford-snap github
% code.
%   k = how many powers of kronecker initial matrix
%   init_matrix = initial matrix
%   path_to_snap = string with path to local clone of github repo
%
%   Author: Carl 2014

% generate edge list txt from c++ lib
strmatrix = regexprep(mat2str(init_matrix),'\[|\]','');
command = ['cd ' path_to_snap '/examples/krongen;' ...
    './krongen -o:tmp_kron.txt -m:"' strmatrix '" -i:' num2str(k)];
unix(command);

% get edgelist from txt
command = ['cd ' path_to_snap '/examples/krongen;' ...
    'cat tmp_kron.txt | sed 1,4d > matlab_read.txt'];
unix(command);
edgeList = load([path_to_snap '/examples/krongen/matlab_read.txt']) + 1;

G = zeros(size(init_matrix,1)^k);

for j = 1:size(edgeList,1)
    G(edgeList(j,1),edgeList(j,2)) = 1;
end

G(logical(eye(size(G)))) = 0;

% remove temporary files
command = ['cd ' path_to_snap ...
    '/examples/krongen; rm tmp_kron.txt; rm matlab_read.txt'];
unix(command);