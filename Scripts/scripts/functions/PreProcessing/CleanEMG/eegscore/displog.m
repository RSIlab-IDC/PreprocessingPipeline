function displog(s)

% function displog(s)
%
% This function displays the string 's' using the 'disp' command, then
% opens the log file named in the global variable LOGFILENAME, and
% appends it to the file, along with a timestamp.
%

global LOGFILENAME;

disp(s);

if size(LOGFILENAME, 2) > 0
	fid = fopen(LOGFILENAME, 'a');
	if fid < 1
		disp(['displog(): Cant open ' LOGFILENAME ' for append.']);
	else
		h = getenv('HOST');
		u = getenv('USER');
		d = datestr(now, 'dd-mmm-yyyy HH:MM:SS');
		fprintf(fid, '%s:%s:%s: %s\n', h, u, d, s);
		fclose(fid);
	end
end
