% setup for experiments:

cd ..
path(path, genpath('borgwardt code'));
path(path, genpath('images'));
path(genpath('libsvm-3.18'), path);
path(path, genpath('my_code'));
path(path, genpath('sebastien code'));
path(path, genpath('PrivacyKernelCode/road-data'));
path(path, genpath('PrivacyKernelCode/graph_gen'));
path(path, genpath('PrivacyKernelCode/graphsampling'));



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
