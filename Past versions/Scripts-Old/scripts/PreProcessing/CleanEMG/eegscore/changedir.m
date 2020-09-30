
function err = changedir(dirname)

% err = changedir(dirname)
%
% Change location to the directory 'dirname'. Returns an error if it can't
% be done. Like the Matlab-intrinsic 'cd', but lets the script do something
% other than just bomb out if the attempt fails. Calls 'cdaccess.mex'
% to do the dirty work.

err = cdaccess(dirname);
if err == 0
	cmd = ['cd ' dirname];
	eval(cmd);
end
