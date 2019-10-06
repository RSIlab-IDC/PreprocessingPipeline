function cbeegsview(action)

% This is the callback function for the eegscore() function
%
% It is not intended for external use.

% Define the global values
eegsinclude;

%set(get(get(0, 'CurrentFigure'), 'CurrentObject'), 'Selected', 'off');

switch action

case 'time_cb',
%	sliderMax = ((NSamp)/ Samp_Rate) - xSecsWidth;
%make sure sliderMax is at least 0.01
%	sliderMax = max(sliderMax,0,01);
	sliderMax = get(timeSlider,'Max');
	timeStart = ceil(get(timeSlider, 'Value') * 16 / xSecsWidth); %integer number of quarter windows
	timeStart = timeStart * xSecsWidth / 16;    % time at integer number of quarter windows
	timeStart = max(min(timeStart,sliderMax),0);  %make sure timeStart is between 0 and sliderMax
	timeEnd = timeStart + xSecsWidth;
	set(timeSlider, 'Value', timeStart);
        eegsplot([]);

case 'chan_cb',
	sliderValue = get(channelSlider, 'Value');
	MaxValue = get(channelSlider, 'Max');
	chanStart = round(MaxValue - sliderValue + 1);
	chanStart = max(chanStart,1);
	eegsplot([]);

case 'y_in',
	maxYValue = maxYValue / 2;
        for chanNum = 1:totChans
  	  if chanInfo(chanNum).useMyY == 1
            Ymax = chanInfo(chanNum).maxYValue;  % use channel setting
          else
            Ymax = maxYValue;         % use global setting
          end
       	  set(eegPlot(chanNum), 'YLim',[-Ymax Ymax]);
	end

case 'y_out',
	maxYValue = maxYValue * 2;
	for chanNum = 1:totChans
	  if chanInfo(chanNum).useMyY == 1
            Ymax = chanInfo(chanNum).maxYValue;  % use channel setting
          else
            Ymax = maxYValue;         % use global setting
          end
	  set(eegPlot(chanNum), 'YLim',[-Ymax Ymax]);
	end

case 'x_in',
%	sliderMax = ((NSamp)/ Samp_Rate) - xSecsWidth;
%	sliderMax = get(timeSlider,'Max');
%make sure sliderMax is at least 0.01
%	sliderMax = max(sliderMax,0.01);
	xSecsWidth = xSecsWidth / 2;
	timeStart = round(get(timeSlider, 'Value') * 4 / xSecsWidth); %test
	timeStart = timeStart * xSecsWidth / 4;  %test
	if (NSamp/Samp_Rate - xSecsWidth == 0)
		sliderStep = 1.0
	else
		sliderStep = xSecsWidth/(NSamp/Samp_Rate - xSecsWidth);  % test
	end
        % sliderStep = (Samp_Rate * xSecsWidth)/NSamp;
	if abs(sliderStep) >= 1
		sliderStep = 1.0;
	end
	sliderMax = ((NSamp)/ Samp_Rate) - xSecsWidth;  % new value for sliderMax
	sliderMax = max(sliderMax,0.01);      %make sure sliderMax is at least 0.01
	timeStart = max(min(timeStart, sliderMax), 0);
	timeEnd = timeStart + xSecsWidth;
	set(timeSlider, 'SliderStep',[sliderStep/1.25 sliderStep], ...  %test
		'Max', sliderMax, ...
		'Value', timeStart);
        eegsplot([]);

case 'x_out',
	%
	% First, figure out the maximum "to the right" point that the
	% slider can be at with the current time magnification. Make
	% sure that it has a positive value.
	%
	sliderMax = ((NSamp)/ Samp_Rate) - xSecsWidth;
	sliderMax = max(sliderMax,0.01);
	%
	% Now bump the magnification out by a factor of 2 (make the
	% viewed window twice as wide).
	%
	xSecsWidth = xSecsWidth * 2;
	%
	% Next, get the current slider button position, and round it
	% up or down to the nearest 1/4-window "unit".
	%
	timeStart = round(get(timeSlider, 'Value') * 4 / xSecsWidth);  %test
	timeStart = timeStart * xSecsWidth / 4;  %test
	%
	% Now update the max "to the right" position.
	%
	sliderMax = ((NSamp)/ Samp_Rate) - xSecsWidth;
	sliderMax = max(sliderMax,0.01);
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
	if (NSamp/Samp_Rate - xSecsWidth == 0)
		sliderStep = 1.0
	else
		sliderStep = xSecsWidth/(NSamp/Samp_Rate - xSecsWidth);  % test
	end
        % sliderStep = (Samp_Rate * xSecsWidth)/NSamp;
	if abs(sliderStep) >= 1
		sliderStep = 1.0;
	end
	%
	% Now refresh the slider with everything that has been updated.
	%
	set(timeSlider, 'SliderStep',[sliderStep/1.25 sliderStep], ...
		'Max', sliderMax, ...
		'Value', timeStart);     %test
	%
	% Finally, redraw all of the visible data with the new window
	%
        eegsplot([]);

case 'fewer_channels',
	if numChansShown > 2*numFixed
		numChansShown = floor(numChansShown / 2);
		if numChansShown < 1
			numChansShown = 1;
		end
		setChanSlider;
		eegsplot([]);
	end

case 'more_channels',
	numChansShown = numChansShown * 2;
	if numChansShown > NChanToDisplay
		numChansShown = numChansShown/2;
                return;
	end
	if numChansShown > 32
		numChansShown = 32;
	end
	setChanSlider;
	sliderValue = get(channelSlider, 'Value');
	MaxValue = get(channelSlider, 'Max');
	chanStart = round(MaxValue - sliderValue + 1);
	if numChansShown == NChanToDisplay
		chanStart = 1;
	end
	if chanStart < 1
		chanStart = 1;
	end
	eegsplot([]);

case 'edit_channels',
	cbeegseditchan('create');
	cbeegseditchan('update');

case 'cancel',
	if saveCFG > 0
		saveEEGSCORECFG;
	end
	if changesMade > 0
		if (eegsfile('check') ~= 1)
			close('all','force');
                        clear all            %make sure globals are clear
		end
	else
		close('all','force');
                clear all
	end

case 'file',
	eegsfile('dialog');

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

case 'previous',
	set(timeSlider,'Value',previoustime);
	cbeegsview('time_cb');

case 'next',
	set(timeSlider,'Value',nextime);
	cbeegsview('time_cb');

case 'nextEvent',
	if (eventChannel > 0)
		set(timeSlider,'Value',next_event);
		cbeegsview('time_cb');
	else
		warnMsg = {'You must specify an event channel' ...
				'using Options menu before using nextEvent'};
		b = warndlg(warnMsg,'nextEvent Error');
		end

case 'prevEvent',
	if (eventChannel > 0)
		set(timeSlider,'Value',prev_event);
		cbeegsview('time_cb');
	else
		warnMsg = {'You must specify an event channel' ...
				'using Options menu before using prevEvent'};
		b = warndlg(warnMsg,'prevEvent Error');
	end
	

case 'keypress',
	k = abs(get(get(0, 'CurrentFigure'), 'CurrentCharacter'));
	switch k
	case 27,	% ESC
		cbeegsview('cancel');

	case {28 66 98},	% Left arrow or B or b 
		% Move left in X axis (time)
		sliderMax = get(timeSlider,'Max');
		timeStart = round(get(timeSlider, 'Value') * 2 / xSecsWidth);
		timeStart = timeStart * xSecsWidth / 2;
		timeStart = timeStart - xSecsWidth;
		timeStart = max(min(timeStart, sliderMax), 0);
		timeEnd = timeStart + xSecsWidth;
		set(timeSlider, 'Value', timeStart);
		cbeegsview('time_cb');

	case {29 32},	% Right arrow or space bar 
		% Move right in X axis (time)
		sliderMax = get(timeSlider,'Max');
		timeStart = round(get(timeSlider, 'Value') * 2 / xSecsWidth);
		timeStart = timeStart * xSecsWidth / 2;
		timeStart = timeStart + xSecsWidth;
		timeStart = max(min(timeStart, sliderMax), 0);
		timeEnd = timeStart + xSecsWidth;
		set(timeSlider, 'Value', timeStart);
		cbeegsview('time_cb');

	case {30 65 97},   % Up arrow or A or a
		% Move up (decrease) one windowful of channels
		sliderValue = get(channelSlider, 'Value') + numChansChange;
		maxValue = totChans - (numChansShown - 1);
		sliderValue = max(min(sliderValue, maxValue), 1);
		set(channelSlider, 'Value', sliderValue);
		cbeegsview('chan_cb');

	case {31 90 122},	% Down or Z or z
		% Move down (increase) one windowful of channels
		sliderValue = get(channelSlider, 'Value') - numChansChange;
		maxValue = totChans - (numChansShown - 1);
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

	otherwise,
		disp(['Unsupported keypress: ' num2str(k)]);
	end

otherwise,
	disp(action);

end

%functions used locally by cbeegsview
function t = previoustime;

	eegsinclude;
	timeStart = round(get(timeSlider,'Value')*4/xSecsWidth);
	timeStart = timeStart*xSecsWidth/4;
	sampStart = timeStart*Samp_Rate + 1;       %sample one is at time zero
	a = all(allChannelMask);        %locate all good channels
	b = all(~allChannelMask);       %locate all bad channels
	c = a | b;                      %all bad or all good
	d = find(c==0);                 %don't need to look at all bad/good channels
	e = ~all(allChannelMask(:,d)');  %work around using diff so that allChannelMask can be a uint8
	f = [0 e];            %shift e right one place
	e = [e 0];            %make e the same length
	g = find(xor(e,f)==1);       %xor locates start and ending points of events
	events = g(1:2:end);  %use just the start points
%	events = find(diff(~all(allChannelMask(:,d)'))==1); %sample number at start of events
	prevevents = find(events<sampStart);  %indices of event elements less than sampStart
	if isempty(prevevents)
		t = timeStart;
	else
		t = events(prevevents(end))/Samp_Rate - xSecsWidth/2;
	end
		
function nt = nextime;

	eegsinclude;
	timeStart = round(get(timeSlider,'Value')*4/xSecsWidth);
	timeStart = timeStart*xSecsWidth/4;
	sampEnd = (timeStart+xSecsWidth)*Samp_Rate;
	a = all(allChannelMask);
	b = all(~allChannelMask);
	c = a | b;
	d = find(c==0);
	e = ~all(allChannelMask(:,d)');  %work around using diff so that allChannelMask can be a uint8
	f = [0 e];            %shift e right one place
	e = [e 0];            %make e the same length
	g = find(xor(e,f)==1);       %xor locates start and ending points of events
	events = g(1:2:end);  %use just the start points
%	events = find(diff(~all(allChannelMask(:,d)'))==1); %sample number at start of events
	nextevents = find(events>sampEnd);  %indices of event elements less than sampStart
	if isempty(nextevents)
		nt = timeStart;
	else
		nt = events(nextevents(1))/Samp_Rate - xSecsWidth/2;
	end

function pe = prev_event;

	eegsinclude;
	timeStart = round(get(timeSlider,'Value')*16/xSecsWidth);
	timeStart = timeStart*xSecsWidth/16;            %time of nearest sixteenth window boundary
	sampStart = timeStart*Samp_Rate + 1;           %sample one is at zero time
	%eventChan = str2num(eventChannel{1})
	d = uint8(double(allChannelData(:,eventChannel)));
	e = (d>0)';  %e is a row vector with ones where eventChannel >0 and zeros elsewhere
	f = [0 e];
	e = [e 0];
	g = find(xor(e,f)==1);  
	events = g(1:2:end);	
%	events = find(diff(allChannelData(:,eventChannel{1})')>0); %sample number at start of events
	prevevents = find(events<sampStart);  %indices of event elements less than sampStart
	if isempty(prevevents)
		pe = timeStart;
	else
		pe = events(prevevents(end))/Samp_Rate - xSecsWidth/8;
		% prevevents(end) is the last in the list of events before sampStart (thus the closest
		% previous event)
	end

function ne = next_event;

	eegsinclude;
	timeStart = round(get(timeSlider,'Value')*16/xSecsWidth);
	timeStart = timeStart*xSecsWidth/16;
	sampEnd = (timeStart+xSecsWidth)*Samp_Rate;
	%eventChan = str2num(eventChannel{1})
	d = uint8(double(allChannelData(:,eventChannel)));
	e = (d>0)';
	f = [0 e];
	e = [e 0];
	g = find(xor(e,f)==1);
	events = g(1:2:end);	
%	events = find(diff(allChannelData(:,eventChannel{1})')>0); %sample number at start of events
	nextevents = find(events>sampEnd);  %indices of event elements less than sampStart
	if isempty(nextevents)
		ne = timeStart;
	else
		ne = events(nextevents(1))/Samp_Rate - xSecsWidth/8;
	end
