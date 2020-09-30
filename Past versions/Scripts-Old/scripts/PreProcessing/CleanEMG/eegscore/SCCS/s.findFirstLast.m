h35695
s 00018/00000/00000
d D 1.1 01/07/06 11:43:18 greischar 1 0
c date and time created 01/07/06 11:43:18 by greischar
e
u
U
f e 0
t
T
I 1
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

E 1
