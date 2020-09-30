%function eegsinit

% This is the initialization function for eegscore.m

% Define the global values
%eegsinclude;

%chanStart = 1;
% m = max(max(allChannelData));
% n = -min(min(allChannelData));
% maxYValue = max([m n]);
%maxYValue = findMaxYValue(datFileName, allChannelData);
maxYValue = 100.0;
yOffset = 0;
%xSecsWidth = 16;
%if xSecsWidth > (NSamp / Samp_Rate)
%	xSecsWidth = NSamp / (Samp_Rate * 2);
%end
%timeStart = 0;
%timeEnd = xSecsWidth;
numChansShown = 8;
%if numChansShown > NChan
%	numChansShown = NChan;
%end
%changesMade = 0;
%inEditMode = 0;
NChan = 8;
for i=1:NChan
	chanInfo(i).number = i;
	chanInfo(i).type = 25;
	chanInfo(i).isVisible = 1;
	chanInfo(i).maxYValue = maxYValue;
	chanInfo(i).yOffset = yOffset;
	chanInfo(i).useMyY = 0;
	chanInfo(i).name = num2str(i);
	chanInfo(i).description = num2str(i);
end


for i=1:25
	chanTypeInfo(i).type = i;
	chanTypeInfo(i).isVisible = 1;
	chanTypeInfo(i).maxYValue = maxYValue;
	chanTypeInfo(i).yOffset = yOffset;
	chanTypeInfo(i).useMyY = 0;
end

chanTypeInfo(1).name = 'EDA';
chanTypeInfo(1).description = 'skin resistance';

chanTypeInfo(2).name = 'EEG';
chanTypeInfo(2).description = 'PC-collected';

chanTypeInfo(3).name = 'EKG';
chanTypeInfo(3).description = 'pulses for generating a heart-rate (.HR) file';

chanTypeInfo(4).name = 'EOG';
chanTypeInfo(4).description = 'Grass Model 12';

chanTypeInfo(5).name = 'EMG';
chanTypeInfo(5).description = 'integrated';

chanTypeInfo(6).name = 'EMG';
chanTypeInfo(6).description = 'raw';

chanTypeInfo(7).name = 'resp';
chanTypeInfo(7).description = 'respiration';

chanTypeInfo(8).name = 'temp';
chanTypeInfo(8).description = 'temperature';

chanTypeInfo(9).name = 'EDA';
chanTypeInfo(9).description = 'skin conductance, Grass Model 7';

chanTypeInfo(10).name = 'EKG';
chanTypeInfo(10).description = 'raw';

chanTypeInfo(11).name = 'cpm';
chanTypeInfo(11).description = 'cephalic plethysmography';

chanTypeInfo(12).name = 'EMG';
chanTypeInfo(12).description = 'integrated w/ noise correction, Grass Model 7';

chanTypeInfo(13).name = 'EKG';
chanTypeInfo(13).description = 'pulses';

chanTypeInfo(14).name = 'VEOG';
chanTypeInfo(14).description = 'vertical EOG (Grass Model 12)';

chanTypeInfo(15).name = 'HEOG';
chanTypeInfo(15).description = 'horizontal EOG (Grass Model 12)';

chanTypeInfo(16).name = 'prob';
chanTypeInfo(16).description = 'secondary trigger';

chanTypeInfo(17).name = 'pot';
chanTypeInfo(17).description = 'potentiometer';

chanTypeInfo(18).name = 'trig';
chanTypeInfo(18).description = 'primary';

chanTypeInfo(19).name = 'VEOG';
chanTypeInfo(19).description = 'vertical EOG (Grass Model 12)';

chanTypeInfo(20).name = 'HEOG';
chanTypeInfo(20).description = 'horizontal EOG (Grass Model 12)';

chanTypeInfo(21).name = 'EMG';
chanTypeInfo(21).description = 'integrated, w/ noise correction,Grass Model 12';

chanTypeInfo(22).name = 'EDA';
chanTypeInfo(22).description = 'skin conductance, Grass Model 12';

chanTypeInfo(23).name = '???';
chanTypeInfo(23).description = 'uncalibrated A-D counts';

chanTypeInfo(24).name = 'EDA';
chanTypeInfo(24).description = 'skin conductance, Coulbourn S71-22 coupler';

chanTypeInfo(25).name = 'EEG';
chanTypeInfo(25).description = 'EGI-collected EEG';

fid = fopen('EEGSCORE.CFG','rt');
if (fid == -1)
	return;
end

while (1)
	s = jgets(fid);
	if (s == -1)
		break;
	end
	l = length(s);
	if (strncmp(s, 'NUM CHANS SHOWN:', 16) == 1)
		numChansShown = str2num(s(17:l));
		numChansShown = min(NChan, min(32, max(numChansShown, 1)));
	elseif (strncmp(s, 'X SECS WIDTH:', 13) == 1)
		xSecsWidth = str2num(s(14:l));
	elseif (strncmp(s, 'MAX Y VALUE:', 12) == 1)
		maxYValue = str2num(s(13:l));
	elseif (strncmp(s, 'CHANNEL', 7) == 1)
		j = findstr(s, '~');
		k = contiguize(findstrnum(s));
		i = str2num(s(k(1):k(2)));
		chanInfo(i).name = s(j(1)+1:j(2)-1);
		chanInfo(i).description = [];
		chanInfo(i).description = s(j(3)+1:j(4)-1);
		chanInfo(i).number = i;
		chanInfo(i).type = str2num(s(k(3):k(4)));
		chanInfo(i).isVisible = str2num(s(k(5):k(6)));
		chanInfo(i).maxYValue = str2num(s(k(7):k(8)));
		chanInfo(i).yOffset = str2num(s(k(9):k(10)));
		chanInfo(i).useMyY = str2num(s(k(11):k(12)));
	elseif (strncmp(s, 'CHAN TYPE', 9) == 1)
		j = findstr(s, '~');
		k = contiguize(findstrnum(s));
		i = str2num(s(k(1):k(2)));
		chanTypeInfo(i).name = [];
		chanTypeInfo(i).name = s(j(1)+1:j(2)-1);
		chanTypeInfo(i).description = [];
		chanTypeInfo(i).description = s(j(3)+1:j(4)-1);
		chanTypeInfo(i).isVisible = str2num(s(k(3):k(4)));
		chanTypeInfo(i).maxYValue = str2num(s(k(5):k(6)));
		chanTypeInfo(i).yOffset = str2num(s(k(7):k(8)));
		chanTypeInfo(i).useMyY = str2num(s(k(9):k(10)));
	end
end

fclose(fid);
