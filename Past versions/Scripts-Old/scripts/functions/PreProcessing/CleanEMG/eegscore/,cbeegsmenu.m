function cbeegsmenu(action)
%
% function cbeegsmenu(action)
% this function handles the menu callbacks for eegscore

% Define the global values
eegsinclude;


switch action

case 'print',
	[c,m] = computer;
	if (strcmp(c,'PCWIN'))
		qstr = questdlg('Default printer will be used','Printer Options', ...
			'OK','Cancel','Cancel');
		if (strcmp(qstr,'Cancel') ~= 1)
			print -dwinc
		end
	else	
		qstr = questdlg('Choose printer','Printer Options','B/W HP8100DN', ...
				'Color HP4500DN','Cancel','B/W HP8100DN');
		if (strcmp(qstr,'Cancel') ~= 1)
			print -dpsc out.ps
			if (strcmp(qstr,'Color HP4500DN'))
				msg = 'lpr -Php4500dn -s -r out.ps';
			else
				msg = 'lpr -s -r out.ps';
			end;
			unix(msg);
			msg = ['rm -f ' 'out.ps'];
			unix(msg);
		end;
	end;
	
case 'fcDisplay',
	qstr = questdlg('Fixed channel display','Plot line color:','Green', ...
		'Blue','Black','Green');
	if (strcmp(qstr,'Green'))
		fixLineColor = [0 0.5 0];
	elseif (strcmp(qstr,'Blue'))
		fixLineColor = [0 0 0.5];
	elseif (strcmp(qstr,'Black'))
		fixLineColor = [0 0 0];
	end
	eegsplot([]);

case 'goodColor',
	qstr = questdlg('Channel display','Plot line color:','Green', ...
		'Blue','Black','Green');
	if (strcmp(qstr,'Green'))
		goodLineColor = [0 0.5 0];
	elseif (strcmp(qstr,'Blue'))
		goodLineColor = [0 0 0.5];
	elseif (strcmp(qstr,'Black'))
		goodLineColor = [0 0 0];
	end
	eegsplot([]);
	
case 'event_chan',
	evChan = inputdlg('Event Channel:');
	if (length(evChan) > 0)
		eventChannel = str2num(evChan{1});
	end
	
case 'NumGoodWins',
	eegswork('on');
	txt(1) = {'Number of good 1 second windows'};
	txt(2) = {' '};
	txt(3) = {[num2str(eegsNumGoodWins('FIXED')) ' Fixed']};
	txt(4) = {[num2str(eegsNumGoodWins('FLOATING')) ' Floating']};
	eegswork('off');
	msgbox(txt,'Number 1 sec good wins'); 

	

otherwise,
	disp(action);
	
end


