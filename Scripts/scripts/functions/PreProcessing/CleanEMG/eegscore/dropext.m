function out = dropext(fileName)
%
% function out = dropext(fileName)
%
% this function returns fileName without the extension
% i.e. 'filename' without the final '.' and any
% other characters following it: dropext('poobah.yow') returns 'poobah'.

pos = findstr(fileName,'.');
if pos > 0
    out = fileName(1:pos(end)-1);
end


    