function logHeader(funcName, varargin)

% function logHeader(funcName, varargin)
%
% This routine sets up the default file name for logging, and then
% adds an entry to the log file with the name of the calling function
% and its arguments. Useful for logging the start of a complex function
% call.

global LOGFILENAME
LOGFILENAME = 'PROCESS.LOG';

sq = '''';

msg = ['Function ' funcName '() called with the following arguments:'];
displog(msg);

for i= 1:nargin-1
	if ischar(varargin{i})
		msg = ['    Arg #' num2str(i) ': string ' sq varargin{i} sq];
	else
		msg = ['    Arg #' num2str(i) ': number ' num2str(varargin{i})];
	end
	displog(msg);
end

p = getenv('PWD');
msg = ['Current directory is ' p];
displog(msg);
