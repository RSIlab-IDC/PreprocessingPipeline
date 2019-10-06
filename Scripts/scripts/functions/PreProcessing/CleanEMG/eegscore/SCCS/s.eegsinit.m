h11387
s 00080/00000/00000
d D 1.1 01/07/06 11:42:43 greischar 1 0
c date and time created 01/07/06 11:42:43 by greischar
e
u
U
f e 0
t
T
I 1
function eegsinit

% This is the initialization function for eegscore.m

% Define the global values
eegsinclude;

chanStart = 1;
fixLineColor = [0 0.5 0];  %initialize fixLineColor can be reset in config file
goodLineColor = [0 0.5 0];  %initialize goodLineColor can be reset in config file
badLineColor = [1 0 0];  %initialize badLineColor currently fixed as red 
%maxYValue = findMaxYValue(datFileName, allChannelData);
maxYValue = 100;
yOffset = 0;
xSecsWidth = 16;
changesMade = 0;
inEditMode = 0;
saveCFG = 0;
eegscoreCFG = [];
KeepOrder = [1:totChans];       %initialize channel order vector
while (isempty(eegscoreCFG))
	qstr = questdlg('New eegscore v1 configuration','Configuration','Create default v1 config file?', ...
		'Choose existing v1 config file?','Change existing v1 config file?', ...
		'Create default v1 config file?');
	if strncmp(qstr,'Create',6)
		for i=1:totChans
			chanInfo(i).displayOrder = i;
			chanInfo(i).type = 25;
			chanInfo(i).isVisible = 1;
			chanInfo(i).fixed = 0;
			chanInfo(i).maxYValue = maxYValue;
			chanInfo(i).yOffset = yOffset;
			chanInfo(i).useMyY = 0;
			chanInfo(i).name = num2str(i);
			chanInfo(i).description = num2str(i);
		end
		datScale = 10;  %initialize datScale
	   numChansShown = 8;
		eegscoreCFG = ['EEGSCORE' num2str(totChans) 'v1.CFG'];
		saveCFG = 1;
	else
		[f d] = uigetfile('*v1.CFG', 'Please select configuration file');
		if (f ~= 0)
			eegscoreCFG = [d f];
			loadEEGSCORECFG;
		end
		if strncmp(qstr,'Change',6)
			saveCFG = 1;
		end
	end
end
for j=1:totChans
	KeepOrder(chanInfo(j).displayOrder) = j;
end
eegsBuildDisplayOrder;
% make sure numChansShown is less than or equal to number of channels in DisplayOrder
while numChansShown > length(DisplayOrder)
	numChansShown = numChansShown/2;
end
% make sure xSecsWidth is less than data length
while (xSecsWidth > NSamp/Samp_Rate)
	xSecsWidth = xSecsWidth/2;
end
timeStart = 0;
timeEnd = xSecsWidth;
%numChansShown = 16;
if numChansShown > totChans
	numChansShown = totChans;
end

% if eegFigure already exists (menu 'New' or 'Files' button pushed)
% add new work file name above axes and to window name
if (eegFigure > 0)
	delete(findobj(labelAxes,'Tag', 'fileLabel'));
	text(0.08,0.96,datFileName,'Parent',labelAxes, 'Tag', 'fileLabel', ...
		'Interpreter','none', ...
		'FontUnits','normalized','Fontsize',0.017,'Color',[0 0 1]);
	set(eegFigure,'Name',['EEG Data Viewer: ' datFileName]);
end

E 1
