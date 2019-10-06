function eegsBuildPlots
%
% This function builds the totChans plots for EEG Display
%

eegsinclude;

for i=1:totChans
        if chanInfo(i).useMyY == 1
          Ymax = chanInfo(i).maxYValue;  % use channel setting
        else
          Ymax = maxYValue;         % use global setting
        end
%	if chanInfo(i).useMyY
%		lineData = double(allChannelData(:,i))/10.0 - chanInfo(i).yOffset;
%	else
%		lineData = double(allChannelData(:,i))/10.0;
%	end
	eegPlot(i) = axes('Parent',eegFigure, ...
		'Box','on', ...
		'CameraUpVector',[0 1 0], ...
		'Color',[1 1 1], ...
		'ColorOrder',eegViewColorOrder, ...
		'NextPlot','add', ...
		'Position',[0.08 0.95 0.75 0.1], ...
		'XColor',deflColor, ...
		'XLim',[0 xSecsWidth], ...
		'XLimMode','manual', ...
		'YColor',deflColor, ...
		'YLim',[-Ymax Ymax], ...
		'YLimMode','manual', ...
		'Visible','off', ...
		'ZColor',[0 0 0]);
%	eegChanText(i) = text('Parent',eegPlot(i), ...
%		'Color',[0 0 1], ...
%		'Units','normalized', ...
%		'FontUnits','points', ...
%		'FontSize', 14, ...
%		'Position',[1.05 0.5], ...
%		'Visible','off', ...
%		'String',chanInfo(i).name);
end
