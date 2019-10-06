function sc = getSelectedChans(chanFirst,chanLast)
%
% function sc = getSelectedChans(chanFirst,chanLast)
% 
% This function returns a vector containing
% the channels selected
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

