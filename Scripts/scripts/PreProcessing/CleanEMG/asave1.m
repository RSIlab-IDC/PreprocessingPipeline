
function err = asave1(fid, varNum, varValue)

% function err = asave1(fid, varNum, varValue)
%
% This function saves a single variable in an ASCII (human editable)
% file that can be read by 'aload1()'. It is useful for cases where
% the built-in Matlab functions 'load' and 'save' need to be used to
% save multiple variables within a single text file.
%
% fid is the file id of a text file already open for write.
% varNum is the number of the variable within the file.
% varValue is the actual matrix (or string) to be saved.
%
% modified 25-Jan-2006 to write all values to greater precision
% long Biopac corrugator files have seven digit NSamp so that
% default g format results in round off error
% changed to '%0.15g\t'

err = 0;

% Set up a string with a single quote in it.
sq = '''';

fprintf(fid, 'v%d = [\n', varNum);

% First, get the dimensions of the matrix.

[nRows, nCols] = size(varValue);

% Next, find out if varValue is a string or numeric matrix.
if ischar(varValue) == 1
    cmd = sprintf('%s%%%d.%ds%s\\n', sq, nCols, nCols, sq);
    for i = 1:nRows
        fprintf(fid, cmd, varValue(i,:));
    end
else
    for i = 1:nRows
        fprintf(fid, '%0.15g\t', varValue(i,:));
        fprintf(fid, '\n');
    end
end
fprintf(fid, '];\n');
