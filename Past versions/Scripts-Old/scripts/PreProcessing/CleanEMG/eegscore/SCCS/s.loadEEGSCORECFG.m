h06685
s 00066/00000/00000
d D 1.1 01/07/06 11:43:47 greischar 1 0
c date and time created 01/07/06 11:43:47 by greischar
e
u
U
f e 0
t
T
I 1
function loadEEGSCORECFG
%
% function loadEEGSCORECFG
%
% This function loads the configuration file for EEGSCORE
%
eegsinclude;
for i=1:totChans
	chanInfo(i).displayOrder = i;
	chanInfo(i).type = 25;
	chanInfo(i).isVisible = 1;
	chanInfo(i).maxYValue = maxYValue;
	chanInfo(i).yOffset = yOffset;
	chanInfo(i).useMyY = 0;
	chanInfo(i).name = num2str(i);
	chanInfo(i).description = num2str(i);
end

fid = fopen(eegscoreCFG,'rt');
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
		numChansShown = min(totChans, min(32, max(numChansShown, 1)));
	elseif (strncmp(s, 'X SECS WIDTH:', 13) == 1)
		xSecsWidth = str2num(s(14:l));
	elseif (strncmp(s, 'MAX Y VALUE:', 12) == 1)
		maxYValue = str2num(s(13:l));
	elseif (strncmp(s, 'DATA SCALE:', 11) == 1)
		datScale = str2num(s(12:l));
	elseif (strncmp(s, 'FIXED CHANNEL LINE COLOR:', 25) == 1)
		c = str2num(s(26:l));
		if (c == 2)
			fixLineColor = [0 0 0.5];
		elseif (c == 3)
			fixLineColor = [0 0 0];
		end
	elseif (strncmp(s, 'GOOD LINE COLOR:', 16) == 1)
		c = str2num(s(17:l));
		if (c == 2)
			goodLineColor = [0 0 0.5];
		elseif (c == 3)
			goodLineColor = [0 0 0];
		end
	elseif (strncmp(s, 'CHANNEL', 7) == 1)
		j = findstr(s, '~');
		k = contiguize(findstrnum(s));
		i = str2num(s(k(1):k(2)));
		chanInfo(i).name = s(j(1)+1:j(2)-1);
		chanInfo(i).isVisible = str2num(s(k(3):k(4)));
                chanInfo(i).fixed = str2num(s(k(5):k(6)));
                chanInfo(i).displayOrder = str2num(s(k(7):k(8)));
		chanInfo(i).maxYValue = str2num(s(k(9):k(10)));
		chanInfo(i).yOffset = str2num(s(k(11):k(12)));
		chanInfo(i).useMyY = str2num(s(k(13):k(14)));
	end
end

fclose(fid);
E 1
