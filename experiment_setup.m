% setup for experiments:

[dir, ~, ~] = fileparts(mfilename('fullpath'));
cd(dir)

path(genpath('borgwardt code'), path);
path(genpath('images'), path);
path(genpath('libsvm-3.18'), path);
path(genpath('my_code'), path);
path(genpath('sebastien code'), path);
path(genpath('dijkstra_heap'), path);
path(genpath('voronoi'), path);
path(genpath('road-data'), path);
path(genpath('graph_gen'), path);
path(genpath('graphsampling'), path);



%%
% export CCOLD=$KRB5CCNAME
% 
% export KRB5CCNAME=FILE:`mktemp -p /tmp krb5cc_screen_XXXXXX`
% 
% kinit -r 7d
% <type password>
% 
% screen -S      [sessionsnamn]
% 
% nohup \matlab -nojvm -nodisplay < XX.m >& logs/XX.log &
% 
% while sleep 1000; do kinit -R; done
% 
% C-a d
%
% export KRB5CCNAME=$CCOLD
