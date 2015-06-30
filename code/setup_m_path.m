%Set the per-project m library folder
% (can't use env vars for this on Windows)
% (can't use local ./startup.m since want to work interactively when started from Start Menu)
rmpath(userpath()) %project should be self-contained
addpath(genpath(strcat(pwd(),'/m'))) %genpath does subdirs. the pwd() now includes 'code'
