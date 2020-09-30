h42847
s 00056/00000/00000
d D 1.1 01/07/06 11:42:54 greischar 1 0
c date and time created 01/07/06 11:42:54 by greischar
e
u
U
f e 0
t
T
I 1

function eegswork(action)

% function eegswork(action) -- turns "Working" message on and off
% for eegscore(). Not for external use.

% Define the global values
eegsinclude;

switch action

case 'on',
	if (WorkingFigure == 0)
		eegswork('create');
	end
	set(WorkingFigure, 'Visible', 'on');
	figure(WorkingFigure);
	disp('Working. One moment, please...');

case 'off',
	if (WorkingFigure ~= 0)
		set(WorkingFigure, 'Visible', 'off');
	end

case 'create',
	ScreenSize = get(0, 'ScreenSize');
	XCenter = floor((ScreenSize(1) + ScreenSize(3)) / 2);
	YCenter = floor((ScreenSize(2) + ScreenSize(4)) / 2);
	position = [XCenter-125 YCenter-20 250 40];

	WorkingFigure = figure('Color',deflColor, ...
		'Colormap',eegViewColorMap, ...
		'MenuBar', 'none', ...
		'Name', 'Working...', ...
		'NumberTitle', 'off', ...
		'Position',position, ...
		'Visible','on', ...
		'Tag','Working');
	WorkingText = uicontrol('Parent',WorkingFigure, ...
		'Visible','on', ...
		'Units','normalized', ...
		'FontUnits','normalized', ...
		'FontSize',0.3, ...
		'BackgroundColor',deflColor, ...
		'HorizontalAlignment','center', ...
		'Interruptible','off', ...
		'Position',[0.05 0.05 0.9 0.9], ...
		'String','Working. One moment, please...', ...
		'Style','text');

otherwise,
	disp(action);

end

drawnow;
E 1
