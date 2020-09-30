function eegsplot(dummy)

% Mid-level EEG data plotting routine used by eegscore().
%
% Not intended for external use.

% Define the global values
eegsinclude;

sampStart = round(timeStart*Samp_Rate) + 1;
sampEnd = round(timeEnd*Samp_Rate) + 1;
sampEnd = min(sampEnd,NSamp);      %rounding of timeStart may cause sampEnd to be > NSamp
delete(findobj(get(labelAxes,'Children'), 'flat', 'Tag', 'LABEL'));
numInVis = 0;
for i = 1:totChans
	if (chanInfo(i).isVisible == 0)
		numInVis = numInVis + 1;
	end
	thisPlot = eegPlotList(i);
	delete(findobj(get(thisPlot, 'Children'), ...
		'flat', 'Tag', 'BADLINE'));
	delete(findobj(get(thisPlot, 'Children'), ...
		'flat', 'Tag', 'GOODLINE'));
	set(thisPlot, 'Visible','off', 'ButtonDownFcn', '');
	kids = get(thisPlot, 'Children');
	for kidNum = 1:size(kids,1)
		set(kids(kidNum), 'Visible','off', 'ButtonDownFcn', '');
	end
end
% display number of invisible channels

delete(findobj(labelAxes,'Tag','inVis'));
text(0.08,0.09,['Number of channels not shown: ' num2str(numInVis)], ...
		'Parent',labelAxes,'Tag','inVis','Fontsize',12,'Color',[0 0 0]);


% Turn off the "working..." message if it is on.
eegswork('off');
for i = 1:numChansChange
       ichan = i+chanStart-1;
       chanNum = DisplayOrder(ichan);
       thisPlot = eegPlotList(chanNum);
       yThickness = 0.8 / numChansShown;
       yOffset = 0.95 - (i * yThickness);
	text(0.86,yOffset+yThickness/2,chanInfo(chanNum).name, ...
		'Parent',labelAxes,'Tag','LABEL','Fontsize',10,'Color',[0 0 1]);
       if mod(i,2) == 0
           scalepos = 'right';
        else
           scalepos = 'left';
        end
	if chanInfo(chanNum).useMyY
		Ymax = chanInfo(chanNum).maxYValue;
	else
		Ymax = maxYValue;
	end
       set(thisPlot, 'XLim',[timeStart timeEnd], ...
	'YLim', [-Ymax Ymax], ...
       'XColor', deflColor, 'YColor', [0 0 0], ...
       'YAxisLocation', scalepos, ...
       'ButtonDownFcn', 'cbeegsedit(''selection'')', ...
       'Position',[0.08 yOffset 0.75 yThickness], ...
       'Visible','on');
       if i < numChansShown
          set(thisPlot, 'XTickLabel', ' ');
	else
	  set(thisPlot, 'XTickLabelMode', 'auto');
       end
	if chanInfo(chanNum).useMyY
		lineData = double(allChannelData(sampStart:sampEnd,chanNum))./datScale ...
				 - chanInfo(chanNum).yOffset;
	else
		lineData = double(allChannelData(sampStart:sampEnd,chanNum))./datScale;
	end
	line('Parent', thisPlot, ...
		'Color',goodLineColor, ...
		'Visible','off', ...
		'Tag', 'GOODLINE', ...
		'XData',timeLine(sampStart:sampEnd), ...
		'YData',lineData);
	vis = get(eegPlotList(i), 'Visible');
	badList = mask2list(~allChannelMask(sampStart:sampEnd,chanNum));
	for j = 1:size(badList,1)
		line('Parent', thisPlot, ...
			'Color',badLineColor, ...
			'Tag', 'BADLINE', ...
			'Visible',vis, ...
			'XData', ...
			timeLine(sampStart+badList(j,1)-1:sampStart+badList(j,2)-1), ...
			'YData', ...
			lineData(badList(j,1):badList(j,2)));
	end
       kids = get(thisPlot, 'Children');
       for kidNum = 1:size(kids,1)
         set(kids(kidNum), 'Visible','on', ...
        'ButtonDownFcn', 'cbeegsedit(''selection'')');
       end
end  % for
if numChansShown < numFixed
  return;
end
% Now display the fixed channels at end of the DisplayOrder vector
for i = NChanToDisplay - numFixed + 1: NChanToDisplay
	chanNum = DisplayOrder(i);
	thisPlot = eegPlotList(chanNum);
	yThickness = 0.8 / numChansShown;
	ipos = numChansChange + i - (NChanToDisplay - numFixed);
	yOffset = 0.95 - (ipos * yThickness);
	text(0.86,yOffset+yThickness/2,chanInfo(chanNum).name, ...
		'Parent',labelAxes,'Tag','LABEL','Fontsize',10,'Color',[0 0 0]);
        if mod(ipos,2) == 0
          scalepos = 'right';
        else
          scalepos = 'left';
        end
	if chanInfo(chanNum).useMyY
		Ymax = chanInfo(chanNum).maxYValue;
	else
		Ymax = maxYValue;
	end
	set(thisPlot, 'XLim',[timeStart timeEnd], ...
		'YLim', [-Ymax Ymax], ...
		'XColor', deflColor, 'YColor', [0 0 0], ...
                'YAxisLocation', scalepos, ...
		'ButtonDownFcn', 'cbeegsedit(''selection'')', ...
		'Position',[0.08 yOffset 0.75 yThickness], ...
		'Visible','on');
        if i < NChanToDisplay
          set(thisPlot, 'XTickLabel', ' ');
	else
	  set(thisPlot, 'XTickLabelMode','auto');
        end
	if chanInfo(chanNum).useMyY
		lineData = double(allChannelData(sampStart:sampEnd,chanNum))./datScale ...
				 - chanInfo(chanNum).yOffset;
	else
		lineData = double(allChannelData(sampStart:sampEnd,chanNum))./datScale;
	end
	line('Parent', thisPlot, ...
		'Color',fixLineColor, ...
		'Visible','off', ...
		'Tag', 'GOODLINE', ...
		'XData',timeLine(sampStart:sampEnd), ...
		'YData',lineData);
	vis = get(eegPlotList(i), 'Visible');
	badList = mask2list(~allChannelMask(sampStart:sampEnd,chanNum));
	for j = 1:size(badList,1)
		line('Parent', thisPlot, ...
			'Color',badLineColor, ...
			'Tag', 'BADLINE', ...
			'Visible',vis, ...
			'XData', ...
			timeLine(sampStart+badList(j,1)-1:sampStart+badList(j,2)-1), ...
			'YData', ...
			lineData(badList(j,1):badList(j,2)));
	end
	kids = get(thisPlot, 'Children');
	for kidNum = 1:size(kids,1)
		set(kids(kidNum), 'Visible','on', ...
			'ButtonDownFcn', 'cbeegsedit(''selection'')');
	end
end
set(eegPlotList(chanNum), 'XColor',[0 0 0], 'YColor',[0 0 0]);
set(0,'CurrentFigure',eegFigure);
%figure(eegFigure);
set(eegFigure,'Selected','on');
