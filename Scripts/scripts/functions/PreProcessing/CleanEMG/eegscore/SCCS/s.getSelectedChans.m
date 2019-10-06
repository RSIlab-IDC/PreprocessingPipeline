h39710
s 00018/00000/00000
d D 1.1 01/07/06 11:43:31 greischar 1 0
c date and time created 01/07/06 11:43:31 by greischar
e
u
U
f e 0
t
T
I 1
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

E 1
