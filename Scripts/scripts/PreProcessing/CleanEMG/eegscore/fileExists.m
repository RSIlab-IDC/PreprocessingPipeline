function result = fileExists(filename)
%
% function result = fileExists('filename')
%
% result = 1 if filename exists 0 if not

if exist(filename,'file')
    result = 1;
else
    result = 0;
end

