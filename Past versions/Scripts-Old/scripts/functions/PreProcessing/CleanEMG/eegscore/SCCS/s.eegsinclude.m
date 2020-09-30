h58627
s 00027/00000/00000
d D 1.1 01/07/06 11:42:38 greischar 1 0
c date and time created 01/07/06 11:42:38 by greischar
e
u
U
f e 0
t
T
I 1
% Global values for eegscore.m
%
% chanInfo is an array of structs. It contains 1 struct for each
% channel read in. Each struct has the following items:
%	name		string
%	description	longer string
%	number		channel number; allows alternate numbering
%	type		AQUIAN channel type
%	isVisible	1 = user-selected visible, 0 = no
%       fixed           1 = display as fixed window at bottom of screen
%	maxYValue	user-selected y scaling factor
%	yOffset		user-selected y offset factor
%	useMyY		1 = use chan's maxYValue & yOffset; 0 = use type's
%			or global value
%


global chanStart deflColor Samp_Rate NChan NEvent totChans NSamp eegPlot eegChanText timeSlider ...
	channelSlider maxYValue xSecsWidth numChansShown undoButton eventChannel ...
	timeStart timeEnd editFigure  selectedLine labelAxes helpFig ...
	changesMade allChannelMask maskFileName allChannelData timeLine ...
	inEditMode WorkingFigure WorkingText datFileName cfgFileName ...
	maskInFileName maskOutFileName fileFigure datUI cfgUI maskInUI ...
	maskOutUI deflColor eegViewColorMap bgColor displayNeedsRefresh ...
	undoMask chanInfo  yOffset DisplayOrder KeepOrder numFixed eegscoreCFG ...
 	numChansChange NChanToDisplay editChannels  saveCFG datScale ...
	eegFigure eegViewColorOrder selectedChannels fixLineColor goodLineColor badLineColor
E 1
