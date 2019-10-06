h01997
s 00031/00000/00000
d D 1.1 01/07/06 11:44:08 greischar 1 0
c date and time created 01/07/06 11:44:08 by greischar
e
u
U
f e 0
t
T
I 1
function l = mask2list(m)

% function l = mask2list(m)
%
% This function examines a 1-dimensional mask (an array made up of 0s and 1s)
% and returns a 2-dimensional array made up of the start/stop endpoints of
% the contiguous non-0 segments within the mask.
%
% The list can be useful for using the mask to plot data in different colors.
% Vectorized version using shift and add 8/99

l = [];
% check to make sure m is a column vector and transpose if necessary
[r c] = size(m);
if (r == 1)
   m = m';
end
if (sum(m) > 0)
   msr =  [0; m(1:end-1)];
   n = xor(m,msr);
   c12 = find(n==1);
   if (rem(length(c12),2) ~= 0)
      c12(end+1)=length(m)+1;
   end
   c1 = c12(1:2:end-1);
   c2 = c12(2:2:end);
   c2 = c2 - 1;
   l = [c1 c2];
else
   l = [];
end
E 1
