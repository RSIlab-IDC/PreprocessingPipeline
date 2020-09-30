function cbeegsedit(dummy)

% This is the edit-mode callback function for eegscore().
%

% Define the global values
eegsinclude;

%
% Make sure that the user can't do multiple selections at once. First
% check then set the sanity-check flag--if we're in edit mode, don't double-dip
% and then make sure the user can't rubber-band again.
%

if inEditMode == 1
	return;
end

inEditMode = 1;
for plotNum = 1:totChans
	thisPlot = eegPlot(plotNum);
	set(thisPlot, 'ButtonDownFcn', '');
	kids = get(thisPlot, 'Children');
	for kidNum = 1:size(kids,1)
		set(kids(kidNum), 'ButtonDownFcn', '');
	end
end
%
% At this point, the user has already pressed the mouse button down somewhere
% over one of the data axes. Now a rubberband box will show up, and we will
% grab the limits of it in figure-normalized coordinates (which are a lot
% more useful for figuring out which axes are covered by the box than pixel
% coords are). The Matlab manual notes that the figure's units must be reset
% to the default of pixels or other graphics calls may break. Remember that
% 0,0 in normalized coords is the LOWER-left corner of the figure.
%

set(gcf, 'Units', 'normal');
point1 = get(gcf,'CurrentPoint');
set(gcf, 'Units', 'pixels');
finalRect = rbbox;
set(gcf, 'Units', 'normal');
point2 = get(gcf,'CurrentPoint');
set(gcf, 'Units', 'pixels');
button = get(gcf,'SelectionType');         %check which button was pushed

%
% The overall data plotting area is X = 0.08 - 0.83, Y = 0.15 - 0.95
% Force the points within this area. (The "live" button-down areas for
% the plot axes extend further than the actual plotting zones, so the
% box could easily extend outside of the plotting area.)
%
plotLeftX = 0.08;
plotRightX = 0.83;
plotDownY = 0.15;
plotUpY = 0.95;
xMin = min(point1(1), point2(1));
xMax = max(point1(1), point2(1));
yMin = min(point1(2), point2(2));
yMax = max(point1(2), point2(2));

xMin = max(min(xMin, plotRightX), plotLeftX);
xMax = max(min(xMax, plotRightX), plotLeftX);
yMin = max(min(yMin, plotUpY), plotDownY);
yMax = max(min(yMax, plotUpY), plotDownY);

%
% Now translate the X values into seconds and the Y values into channels.
%

markedTimeMin = ((xMin - plotLeftX) * (timeEnd - timeStart) / (plotRightX - plotLeftX)) + timeStart;
markedTimeMax = ((xMax - plotLeftX) * (timeEnd - timeStart) / (plotRightX - plotLeftX)) + timeStart;

% zero time corresponds to sample 1
markedSampMin = round(markedTimeMin*Samp_Rate + 1);    
markedSampMax = round(markedTimeMax*Samp_Rate + 1);
%make sure markedSampMax is not greater than NSamp
if (markedSampMax > NSamp)
	markedSampMax = NSamp;
end

% Now turn around and make times correspond to sample point
markedTimeMin = (markedSampMin - 1)/Samp_Rate;
markedTimeMax = (markedSampMax - 1)/Samp_Rate;


chanEnd = chanStart + numChansShown;
chanMin = floor(((yMax - plotUpY) * (chanEnd - chanStart) / (plotDownY - plotUpY)) + chanStart);
chanMin = min(chanMin, chanEnd - 1);
chanMax = floor(((yMin - plotUpY) * (chanEnd - chanStart) / (plotDownY - plotUpY)) + chanStart);
chanMax = min(chanMax, chanEnd - 1);
selectedChannels = [];
if chanMax <= chanStart+numChansChange-1                          %all selected channels not fixed
	for i=chanMin:chanMax
		selectedChannels = [selectedChannels DisplayOrder(i)];
	end
elseif chanMin <= chanStart+numChansChange-1 & chanMax > chanStart+numChansChange-1
	for i=chanMin:chanStart+numChansChange-1
		selectedChannels = [selectedChannels DisplayOrder(i)];       %get nonFixed channels
	end
	for i=1:chanMax - (chanStart+numChansChange-1)                       %get Fixed channels
		selectedChannels = [selectedChannels DisplayOrder(NChanToDisplay-numFixed+i)];
	end
else
	for i=chanMin:chanMax                                           %all selected channels are Fixed           
		j = i - (chanStart+numChansChange-1);
		selectedChannels = [selectedChannels DisplayOrder(NChanToDisplay-numFixed+j)];	
	end
end
%
% Pop some limit lines up over the plots so the user can see what is selected.
%

xData = [markedTimeMin    markedTimeMax   markedTimeMax    markedTimeMin   markedTimeMin];
yData = [-maxYValue maxYValue -maxYValue maxYValue -maxYValue];

selectedLine = [];
for thisChan = selectedChannels
        if chanInfo(thisChan).useMyY
          maxY = chanInfo(thisChan).maxYValue;
          yData = [-maxY maxY -maxY maxY -maxY];
        end
	thisLine = line('Parent',eegPlot(thisChan), ...
		'Color',[0.0 0.0 1.0], ...
		'XData',xData, ...
		'YData',yData);
	selectedLine = [selectedLine thisLine];
end

set(editFigure, 'Visible','on');
if strcmp(button,'normal') == 0        %left button not used mark data Good
	set(findobj(editFigure,'Tag', 'ok'), 'Value',1);
	set(findobj(editFigure,'Tag', 'bad'), 'Value',0);
end
if InOrder(selectedChannels)
	set(findobj(editFigure,'Tag','minchan'), 'String', num2str(selectedChannels(1)));
	set(findobj(editFigure,'Tag','maxchan'), 'String', num2str(selectedChannels(end)));
else
	set(findobj(editFigure,'Tag','minchan'), 'String', num2str(selectedChannels(1)));
	set(findobj(editFigure,'Tag','maxchan'), 'String', 'selected');
end
strTimeMin = sprintf('%.3f',markedTimeMin);
strTimeMax = sprintf('%.3f',markedTimeMax);
set(findobj(editFigure,'Tag','mintime'), 'String', strTimeMin);
set(findobj(editFigure,'Tag','maxtime'), 'String', strTimeMax);
freq = 1.0/(markedTimeMax-markedTimeMin);
strFreq = sprintf('%.1f',freq);
set(findobj(editFigure,'Tag','frequency'), 'String', strFreq);
set(findobj(editFigure,'Tag','minsamp'), 'String', num2str(markedSampMin));
set(findobj(editFigure,'Tag','maxsamp'), 'String', num2str(markedSampMax));
DiffTime = markedTimeMax - markedTimeMin;
strDiffTime = sprintf('%.3f',DiffTime);
set(findobj(editFigure,'Tag','deltat'), 'String', strDiffTime);
kids = get(editFigure, 'Children');
for kidNum = 1:size(kids,1)
	set(kids(kidNum), 'Visible','on');
end
