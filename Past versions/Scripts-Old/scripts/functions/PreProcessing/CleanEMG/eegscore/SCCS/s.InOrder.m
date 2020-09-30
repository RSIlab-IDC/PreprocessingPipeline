h59217
s 00019/00001/00014
d D 1.2 04/01/08 13:35:55 greischar 2 1
c added scaler handling
e
s 00015/00000/00000
d D 1.1 01/07/06 11:36:56 greischar 1 0
c date and time created 01/07/06 11:36:56 by greischar
e
u
U
f e 0
t
T
I 1
function r = InOrder(m)
%
% function r =InOrder(m)
% 
% This function returns 1 if integer elements of m
D 2
% monotonically increase/decrease by 1
E 2
I 2
% monotonically increase/decrease by 1 (or m is scalar [1x1])
E 2
% else returns 0

I 2
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

E 2
test = diff(m) - ones(1,size(m,2)-1);
if any(test)
  r = 0;
else
  r = 1;
end

E 1
