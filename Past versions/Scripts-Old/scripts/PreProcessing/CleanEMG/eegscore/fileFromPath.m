function f = fileFromPath(p)

% function f = fileFromPath(p)
%
% This function takes in a file (possibly prepended with a full path)
% and returns just the file name sans path.
%

[d, n, e] = fileparts(p);
f = [n e];
