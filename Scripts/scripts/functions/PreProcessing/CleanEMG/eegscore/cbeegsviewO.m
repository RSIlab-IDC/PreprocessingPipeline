function dbeegsview(action)

% This is the callback function for the eegscore() function
%
% It is not intended for external use.

% Define the global values
eegsinclude;

set(get(get(0, 'CurrentFigure'), 'CurrentObject'), 'Selected', 'off');

switch action

case 'time_cb',
	sliderMax = (NSamp / Samp_Rate) - xSecsWidth;
	if sliderMax <= 0
		sliderMax = 0.01;
	end
	timeStart = round(get(timeSlider, 'Value') * 2 / xSecsWidth);
	timeStart = timeStart * xSecsWidth / 2;
	if timeStart > sliderMax
		timeStart = sliderMax;
	end
	if timeStart < 0
		timeStart = 0;
	end
	set(timeSlider, 'Value', timeStart);
	timeEnd = timeStart + xSecsWidth;
	for plotNum = 1:numChansShown
		chanNum = plotNum + chanStart - 1;
		set(eegPlot(chanNum), 'XLim',[timeStart timeEnd]);
	end

case 'chan_cb',
	sliderValue = get(channelSlider, 'Value');
	chanStart = round((NChan - (numChansShown - 2)) - sliderValue);
	if chanStart < 1
		chanStart = 1;
	end
	eegsplot([]);

case 'y_in',
	maxYValue = maxYValue / 2;
	for chanNum = 1:NChan
		set(eegPlot(chanNum), 'YLim',[-maxYValue maxYValue]);
	end

case 'y_out',
	maxYValue = maxYValue * 2;
	for chanNum = 1:NChan
		set(eegPlot(chanNum), 'YLim',[-maxYValue maxYValue]);
	end

case 'x_in',
	sliderMax = (NSamp / Samp_Rate) - xSecsWidth;
	if sliderMax <= 0
		sliderMax = 0.01;
	end
	xSecsWidth = xSecsWidth / 2;
	timeStart = round(get(timeSlider, 'Value') * 2 / xSecsWidth);
	timeStart = timeStart * xSecsWidth / 2;
	sliderStep = (Samp_Rate * xSecsWidth)/NSamp;
	if sliderStep >= 1
		sliderStep = 0.99;
	end
	sliderMax = (NSamp / Samp_Rate) - xSecsWidth;
	if sliderMax <= 0
		sliderMax = 0.01;
	end
	timeStart = max(min(timeStart, sliderMax), 0);
	timeEnd = timeStart + xSecsWidth;
	set(timeSlider, 'SliderStep',[sliderStep/2 sliderStep], ...
		'Max', sliderMax, ...
		'Value', timeStart);
	for plotNum = 1:numChansShown
		chanNum = plotNum + chanStart - 1;
		set(eegPlot(chanNum), 'XLim',[timeStart timeEnd]);
	end

case 'x_out',
	%
	% First, figure out the maximum "to the right" point that the
	% slider can be at with the current time magnification. Make
	% sure that it has a positive value.
	%
	sliderMax = (NSamp / Samp_Rate) - xSecsWidth;
	if sliderMax <= 0
		sliderMax = 0.01;
	end
	%
	% Now bump the magnification out by a factor of 2 (make the
	% viewed window twice as wide).
	%
	xSecsWidth = xSecsWidth * 2;
	%
	% Next, get the current slider button position, and round it
	% up or down to the nearest 1/2-window "unit".
	%
	timeStart = round(get(timeSlider, 'Value') * 2 / xSecsWidth);
	timeStart = timeStart * xSecsWidth / 2;
	%
	% Now update the max "to the right" position.
	%
	sliderMax = (NSamp / Samp_Rate) - xSecsWidth;
	if sliderMax <= 0
		sliderMax = 0.01;
	end
	%
	% Make sure that the current (rounded) slider position isn't illegal.
	%
	timeStart = max(min(timeStart, sliderMax), 0);
	%
	% Set the end of the current window to the start + the width
	%
	timeEnd = timeStart + xSecsWidth;
	%
	% figure out a reasonable value for the "arrow button" step size.
	%
	sliderStep = (Samp_Rate * xSecsWidth)/NSamp;
	if sliderStep >= 1
		sliderStep = 0.99;
	end
	%
	% Now refresh the slider with everything that has been updated.
	%
	set(timeSlider, 'SliderStep',[sliderStep/2 sliderStep], ...
		'Max', sliderMax, ...
		'Value', timeStart);
	%
	% Finally, redraw all of the visible data with the new window
	%
	for plotNum = 1:numChansShown
		chanNum = plotNum + chanStart - 1;
		set(eegPlot(chanNum), 'XLim',[timeStart timeEnd]);
	end

case 'fewer_channels',
	numChansShown = numChansShown / 2;
	if numChansShown < 1
		numChansShown = 1;
	end
	if NChan > 1
		bigStep = max(numChansShown/NChan, 2/NChan);
		sliderValue = (NChan - (numChansShown - 2)) - chanStart;
		maxValue = NChan - (numChansShown - 1);
		sliderValue = max(min(sliderValue, maxValue), 1);
		set(channelSlider, ...
			'Visible', 'on', ...
			'Max', maxValue, ...
			'Min',1, ...
			'SliderStep',[1/NChan bigStep], ...
			'Value',sliderValue);
	else
		set(channelSlider, 'Visible', 'off');
	end
	eegsplot([]);

case 'more_channels',
	numChansShown = numChansShown * 2;
	if numChansShown > NChan
		numChansShown = NChan;
	end
	if numChansShown > 32
		numChansShown = 32;
	end
	sliderValue = (NChan - (numChansShown - 2)) - chanStart;
	maxValue = NChan - (numChansShown - 1);
	sliderValue = max(min(sliderValue, maxValue), 1);
	set(channelSlider, ...
		'Visible', 'on', ...
		'Max', maxValue, ...
		'Min',1, ...
		'SliderStep',[1/NChan numChansShown/NChan], ...
		'Value',sliderValue);
	sliderValue = get(channelSlider, 'Value');
	chanStart = round((NChan - (numChansShown - 2)) - sliderValue);
	if chanStart < 1
		chanStart = 1;
	end
	eegsplot([]);

case 'cancel',
	saveEEGSCORECFG('EEGSCORE.CFG');
	if changesMade > 0
		if (eegsfile('check') ~= 1)
			close('all','force');
		end
	else
		close('all','force');
	end

case 'file',
	eegsfile('dialog');

case 'opts',
	eegsopts('dialog');

case 'noundo',
	if (changesMade > 0)
		eegswork('on');
		changesMade = 0;
		undoMask = allChannelMask;
		set(undoButton, 'Visible','off');
		eegswork('off');
	end

case 'undo',
	if (changesMade > 0)
		changesMade = changesMade - 1;
		if (changesMade < 0)
			changesMade = 0;
		end
		set(undoButton, 'Visible','off');
		% Turn on the "working..." message.
		eegswork('on');
		allChannelMask = undoMask;
		displayNeedsRefresh = 1;
		eegsplot([]);
	end

case 'keypress',
	k = abs(get(get(0, 'CurrentFigure'), 'CurrentCharacter'));
	switch k
	case 27,	% ESC
		cbeegsview('cancel');

	case 28,	% Left arrow
		% Move left in X axis (time)
		sliderMax = (NSamp / Samp_Rate) - xSecsWidth;
		timeStart = round(get(timeSlider, 'Value') * 2 / xSecsWidth);
		timeStart = timeStart * xSecsWidth / 2;
		timeStart = timeStart - xSecsWidth;
		timeStart = max(min(timeStart, sliderMax), 0);
		set(timeSlider, 'Value', timeStart);
		cbeegsview('time_cb');

	case 29,	% Right arrow
		% Move right in X axis (time)
		sliderMax = (NSamp / Samp_Rate) - xSecsWidth;
		timeStart = round(get(timeSlider, 'Value') * 2 / xSecsWidth);
		timeStart = timeStart * xSecsWidth / 2;
		timeStart = timeStart + xSecsWidth;
		timeStart = max(min(timeStart, sliderMax), 0);
		set(timeSlider, 'Value', timeStart);
		cbeegsview('time_cb');

	case 30,	% Up arrow
		% Move up (decrease) one windowful of channels
		sliderValue = get(channelSlider, 'Value') + numChansShown;
		maxValue = NChan - (numChansShown - 1);
		sliderValue = max(min(sliderValue, maxValue), 1);
		set(channelSlider, 'Value', sliderValue);
		cbeegsview('chan_cb');

	case 31,	% Down arrow
		% Move down (increase) one windowful of channels
		sliderValue = get(channelSlider, 'Value') - numChansShown;
		maxValue = NChan - (numChansShown - 1);
		sliderValue = max(min(sliderValue, maxValue), 1);
		set(channelSlider, 'Value', sliderValue);
		cbeegsview('chan_cb');

	case 91,	% '['
		cbeegsview('y_in');
	case 123,	% '{'
		cbeegsview('y_in');

	case 93,	% ']'
		cbeegsview('y_out');
	case 125,	% '}'
		cbeegsview('y_out');

	case 45,	% '-' (dash)
		cbeegsview('fewer_channels');
	case 95,	% '_' (underscore)
		cbeegsview('fewer_channels');

	case 61,	% '='
		cbeegsview('more_channels');
	case 43,	% '+'
		cbeegsview('more_channels');

	case 60,	% '<'
		cbeegsview('x_in');
	case 44,	% Comma
		cbeegsview('x_in');

	case 62,	% '>'
		cbeegsview('x_out');
	case 46,	% Period
		cbeegsview('x_out');

%	case 13,	% Return
%	case 32,	% Space bar
%	case 65,	% upper-case 'A'
%	case 90,	% upper-case 'Z'
%	case 97,	% lower-case 'a'
%	case 122,	% lower-case 'z'
%	case 127,	% Backspace
	otherwise,
		disp(['Unsupported keypress: ' num2str(k)]);
	end

otherwise,
	disp(action);

end
