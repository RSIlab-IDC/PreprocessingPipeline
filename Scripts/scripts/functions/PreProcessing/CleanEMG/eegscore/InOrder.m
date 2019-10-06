function r = InOrder(m)
%
% function r =InOrder(m)
% 
% This function returns 1 if integer elements of m
% monotonically increase/decrease by 1 (or m is scalar [1x1])
% else returns 0

% make sure m is a row or column vector
[r,c]=size(m);
if ~(r==1 | c==1) 
	error('InOrder requires a row or column vector');
end

% if column vector change to row vector
if r>1
	m = m';
end

% if m is 1x1

if r==1 & c==1
	r = 1;
	return;
end

test = diff(m) - ones(1,size(m,2)-1);
if any(test)
  r = 0;
else
  r = 1;
end

