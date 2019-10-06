h25424
s 00012/00000/00000
d D 1.1 01/07/06 11:39:01 greischar 1 0
c date and time created 01/07/06 11:39:01 by greischar
e
u
U
f e 0
t
T
I 1
function cbfig(action)
global fileButton;
switch action
	case 'msg',
		msgbox('Who has focus now?');
	otherwise,
		disp(action);
end
set(fileButton,'Selected','off');
set(0,'CurrentFigure', h);


E 1
