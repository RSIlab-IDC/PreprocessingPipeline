function sc = getSelectedChans(chanMin,chanLast)
%
% function [f l] = findFirstLast(chanMin,chanLast)
% 
% This function finds the first/last positions of chanMin and chanLast in 
% the DisplayOrder vector and returns them
%
eegsinclude;
p1 = find(DisplayOrder == chanMin);
p2 = find(DisplayOrder == chanLast);
if p1 > p2
  f = p2;
  l = p1;
else
  f = p1;
  l = p2;
end

