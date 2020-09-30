
function err = asave(fileName, varargin)

% function err = asave(fileName, varargin)
%
% This function saves multiple variables in an ASCII (human editable)
% file that can be read by 'aload()'. It is useful for cases where
% the built-in Matlab functions 'load' and 'save' need to be used to
% save multiple variables within a single text file.
%
% fileName is the name of a text file to open for write.
% varargin is the variable-length list of variables to be saved.
%
% Example:
%
% err = asave('asciiDataFile', a2DArray, aString, aScalar);
% ...
% [other2DArray, otherString, otherScalar] = aload('asciiDataFile');
%
% NOTE: The actual filename used is "fileName.m"

err = 0;

fid = fopen([fileName '.m'], 'w');
if fid > 1
	for i = 1:nargin-1
		err = asave1(fid, i, varargin{i});
	end
	fclose(fid);
else
	err = 1;
end
