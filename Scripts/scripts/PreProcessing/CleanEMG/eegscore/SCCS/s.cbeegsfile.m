h34256
s 00106/00000/00000
d D 1.1 01/07/06 11:37:55 greischar 1 0
c date and time created 01/07/06 11:37:55 by greischar
e
u
U
f e 0
t
T
I 1
function cbeegsfile(action)

% This is the callback function for the eegscore() function
% when the file options pop-up window is visible.
%
% It is not intended for external use.

% Define the global values
eegsinclude;

switch action

case 'DAT',
	eegsfile('guess');
%  Changed to make filter always '*.DAT'
%	if (strcmp(datFileName, 'NADA') == 1)
		b = '*.DAT';
%	else
%		b = datFileName;
%	end
	[f, d] = uigetfile(b, 'Please select an EEG data file');
	if f ~= 0
		b = fullfile(d, f);
		if (strcmp(b, datFileName) == 0)
			eegsfile('check');
			maskInFileName = 'NADA';
			maskOutFileName = 'NADA';
			cfgFileName = 'NADA';
		end
		datFileName = b;
	end
	eegsfile('update');

case 'CFG',
	eegsfile('guess');
	if (strcmp(cfgFileName, 'NADA') == 1)
		b = '*_CFG.m';
	else
		b = cfgFileName;
	end
	[f, d] = uigetfile(b, 'Please select an EEG configuration file');
	if f ~= 0
		cfgFileName = fullfile(d, f);
	end
	eegsfile('update');

case 'INMASK',
	eegsfile('guess');
	if (strcmp(maskInFileName, 'NADA') == 1)
		b = '*.MASK';
	else
		b = maskInFileName;
	end
	[f, d] = uigetfile(b, 'Please select an EEG mask file to read from');
	if f ~= 0
		maskInFileName = fullfile(d, f);
	end
	eegsfile('update');

case 'OUTMASK',
	eegsfile('guess');
	if (strcmp(maskOutFileName, 'NADA') == 1)
		b = '*.MASK';
	else
		b = maskOutFileName;
	end
	[f, d] = uiputfile(b, 'Please select an EEG mask file to save to');
	if f ~= 0
		b = fullfile(d, f);
		if (strcmp(b, maskOutFileName) == 0)
			eegsfile('check');
		end
		maskOutFileName = b;
	end
	eegsfile('update');

case 'load',
	set(fileFigure, 'Visible', 'off');
	uiresume;
	eegswork('on');
	eegsfile('load');
	displayNeedsRefresh = 1;
	cbeegsview('noundo');
	if (editFigure ~= 0)
		eegsplot([]);
	end

case 'save',
	set(fileFigure, 'Visible', 'off');
	eegsfile('save');
	maskInFileName = maskOutFileName;
	uiresume;
	cbeegsview('noundo');

case 'cancel',
	if editFigure > 0
		set(fileFigure, 'Visible', 'off');
		uiresume;
	else
		close('all','force');
	end

otherwise,
	disp(action);

end
E 1
