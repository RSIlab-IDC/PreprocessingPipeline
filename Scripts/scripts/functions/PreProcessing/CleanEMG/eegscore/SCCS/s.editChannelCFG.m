h31904
s 00092/00000/00000
d D 1.1 01/07/06 11:39:28 greischar 1 0
c date and time created 01/07/06 11:39:28 by greischar
e
u
U
f e 0
t
T
I 1
function editChannelCFG()
% This is the machine-generated representation of a Handle Graphics object
% and its children.  Note that handle values may change when these objects
% are re-created. This may cause problems with any callbacks written to
% depend on the value of the handle at the time the object was saved.
%
% To reopen this object, just type the name of the M-file at the MATLAB
% prompt. The M-file and its associated MAT-file must be on your path.

load editChannelCFG                    

a = figure('Color',[0.8 0.8 0.8], ...
	'Colormap',mat0, ...
	'Position',[618 538 560 420], ...
	'Tag','Fig1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.701961 0.701961 0.701961], ...
	'Callback','loadEEGSCORECFG;', ...
	'Position',[16.3297 362.134 124.874 22.0931], ...
	'String','loadEEGSCORECFG', ...
	'Tag','Pushbutton1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.701961 0.701961 0.701961], ...
	'HorizontalAlignment','right', ...
	'Position',[153.691 360.213 47.0679 20.1719], ...
	'String','Channel:', ...
	'Style','text', ...
	'Tag','StaticText1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Position',[203.641 360.213 67.2398 22.0931], ...
	'Style','edit', ...
	'Tag','ChannelEdit');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Position',[79.7272 320.83 122.953 23.0536], ...
	'Style','edit', ...
	'Tag','NameEdit');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Position',[79.7272 288.171 122.953 23.0536], ...
	'Style','edit', ...
	'Tag','DescriptionEdit');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Position',[79.7272 251.669 122.953 23.0536], ...
	'Style','edit', ...
	'Tag','TypeEdit');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.701961 0.701961 0.701961], ...
	'HorizontalAlignment','right', ...
	'Position',[287.21 362.134 65.3187 20.1719], ...
	'String','DisplayOrder:', ...
	'Style','text', ...
	'Tag','StaticText2');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Position',[358.292 360.213 67.2398 22.0931], ...
	'Style','edit', ...
	'Tag','DisplayOrderEdit');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.701961 0.701961 0.701961], ...
	'HorizontalAlignment','right', ...
	'Position',[10.5663 321.79 62.4369 20.1719], ...
	'String','Name:', ...
	'Style','text', ...
	'Tag','NameText');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.701961 0.701961 0.701961], ...
	'HorizontalAlignment','right', ...
	'Position',[12.4874 290.092 61.4764 20.1719], ...
	'String','Description:', ...
	'Style','text', ...
	'Tag','DescriptionText');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.701961 0.701961 0.701961], ...
	'HorizontalAlignment','right', ...
	'Position',[11.5268 251.669 62.4369 20.1719], ...
	'String','Type:', ...
	'Style','text', ...
	'Tag','TypeText');
E 1
