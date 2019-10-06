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


