h40555
s 00080/00000/00000
d D 1.1 01/07/06 11:43:57 greischar 1 0
c date and time created 01/07/06 11:43:57 by greischar
e
u
U
f e 0
t
T
I 1
function err = saveEEGSCORECFG

% function saveEEGSCORECFG
% This function saves the current (global) configuration values in file
% whose name is in global variable eegscoreCFG
%
%
% The saved global vars are defined in 'eegsinclude' and currently include:
%	numChansShown
%	xSecsWidth
%	maxYValue
%       chanInfo
% If a problem occurs, err is set to a descriptive string. Otherwise
% it is 0-length.

% Define the global values
eegsinclude;

err = [];
% check to see if user wants to save config file under a new name
def = {eegscoreCFG};
answer = inputdlg({'Save config file as (or cancel saving changes):'},'Save configuration file',1,def);
% if cancel was chosen answer is empty so do NOT save changes
if (size(answer,1) > 0)
	eegscoreCFG = answer{1,1};
	disp(['Saving user preferences to ' eegscoreCFG '...']);
	fid = fopen(eegscoreCFG,'wt');
	if (fid == -1)
		err = ['Cant open ' eegscoreCFG ' for write.'];
		return;
	end

	% set value for FIXED CHANNEL LINE COLOR:
	if (max(fixLineColor) == 0)
		c_fix = 3;   % black
	elseif (fixLineColor(3) == 0.5)
		c_fix = 2;   % blue
	else
		c_fix = 1;  % green
	end

	% set value for GOOD LINE COLOR:
	if (max(goodLineColor) == 0)
		c_good = 3;   % black
	elseif (goodLineColor(3) == 0.5)
		c_good = 2;   % blue
	else
		c_good = 1;  % green
	end

	fprintf(fid, '# This is the configuration file for EEGSCORE.\n');
	fprintf(fid, '# It is automatically overwritten, so your\n');
	fprintf(fid, '# changes may be overwritten by other users.\n');
	fprintf(fid, '#\n');
	fprintf(fid, '# Number of channels displayed\n');
	fprintf(fid, ['NUM CHANS SHOWN: ' num2str(numChansShown) '\n']);
	fprintf(fid, '# Display window width (in seconds)\n');
	fprintf(fid, ['X SECS WIDTH: ' num2str(xSecsWidth) '\n']);
	fprintf(fid, '# Display window height (in measured units)\n');
	fprintf(fid, ['MAX Y VALUE: ' num2str(maxYValue) '\n']);
	fprintf(fid, '# Scale factor to convert data to two byte integers)\n');
	fprintf(fid, '# use 10 (default) if data in range -3200, +3200)\n');
	fprintf(fid, ['DATA SCALE: ' num2str(datScale) '\n']);
	fprintf(fid, '#fixLineColor 1=green; 2=blue; 3=black\n');
	fprintf(fid, ['FIXED CHANNEL LINE COLOR: ' num2str(c_fix) '\n']);
	fprintf(fid, ['GOOD LINE COLOR: ' num2str(c_good) '\n']);

	fprintf(fid, '#\n# Channel-specific display info.\n');
	for i=1:length(chanInfo)
		fprintf(fid, ['CHANNEL ' num2str(i)]);
		fprintf(fid, [' VISIBLE: ' num2str(chanInfo(i).isVisible)]);
      fprintf(fid, [' FIXED: ' num2str(chanInfo(i).fixed)]);
      fprintf(fid, [' DISPLAY ORDER: ' num2str(chanInfo(i).displayOrder)]);
		fprintf(fid, [' MAX Y VALUE: ' num2str(chanInfo(i).maxYValue)]);
		fprintf(fid, [' Y OFFSET: ' num2str(chanInfo(i).yOffset)]);
		fprintf(fid, [' USE MY Y: ' num2str(chanInfo(i).useMyY)]);
		fprintf(fid, [' NAME: ~' chanInfo(i).name '~' '\n']);
	end
	fclose(fid);
end
E 1
