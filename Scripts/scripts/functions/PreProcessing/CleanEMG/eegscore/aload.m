function [varargout] = aload(fileName)

% function [varargout] = aload(fileName)
%
% This function loads multiple variables from an ASCII (human editable)
% file that is created by 'asave()'. It is useful for cases where
% the built-in Matlab functions 'load' and 'save' need to be used to
% save multiple variables within a single text file.
%
% fileName is the name of a text file to open for read.
% varargout is the variable-length list of variables to be loaded.
%
% Example:
%
% err = asave('asciiDataFile', a2DArray, aString, aScalar);
% ...
% [other2DArray, otherString, otherScalar] = aload('asciiDataFile');
%
% NOTE: The actual filename used is "fileName.m"

err = 0;
xx=fileName
eval(fileName);

for i = 1:nargout
	cmd = sprintf('varargout{%d} = v%d;', i, i);
	eval(cmd);
end
