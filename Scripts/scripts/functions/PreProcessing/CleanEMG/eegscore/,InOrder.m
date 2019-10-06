function r = InOrder(m)
%
% function r =InOrder(m)
% 
% This function returns 1 if integer elements of m
% monotonically increase/decrease by 1
% else returns 0

test = diff(m) - ones(1,size(m,2)-1);
if any(test)
  r = 0;
else
  r = 1;
end

