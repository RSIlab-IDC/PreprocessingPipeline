pos = [10 10 50 100];
h = uicontrol('Style','Text','Position',pos);
string = {'This is some text to try out textwrap in a text control.', ...
	'It should be wrapped correctly'};
[outstring newpos] = textwrap(h,string);
pos(4) = newpos(4);
set(h,'String',outstring,'Position',[pos(1),pos(2),pos(3)+10,pos(4)]);
