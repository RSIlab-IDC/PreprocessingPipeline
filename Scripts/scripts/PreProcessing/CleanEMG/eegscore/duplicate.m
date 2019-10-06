function r = duplicate(m)
%
% function r = duplicate(m)
% 
% This function returns 1 if an integer element of m
% is duplicated
% else returns 0

if all(diff(sort(m)))
  r = 0;
else
  r = 1;
end

