function n = eegsNumGoodWins(wflag)
%
% function n = eegsNumGoodWins(wflag)
%
% This function computes the number of good 1 second
% windows with 50% overlap in the current eegscore maskfile
% For use in new eegscore only
%
eegsinclude;
windLength = Samp_Rate;
xLength = size(allChannelMask,1);
overlapLength = fix(0.5*windLength);
numWindows = fix((xLength-overlapLength)/(windLength-overlapLength));
numGoodWindows = 0;
baseIndex = 1:windLength;
index = baseIndex;
for j=1:totChans
	% set up windowOffsets for this channel
	m = 0;
	windowOffsets = [];
	for i=1:numWindows
		windowOffsets = [windowOffsets m];
		m = m + (windLength - overlapLength);
	end
	for i=1:numWindows
		index = baseIndex + windowOffsets(i);
		if ((index(windLength) <= xLength) & all(allChannelMask(index,j)))
			numGoodWindows = numGoodWindows + 1;
		else
			if (strcmp(wflag, 'FLOATING'))
				creep = 0;
				foundGoodies = 0;
				while (index(windLength) < xLength)
					index = index + 1;
					creep = creep + 1;
					if (all(allChannelMask(index,j)))
						foundGoodies = 1;
						break;
					end
				end
				if (foundGoodies)
					numGoodWindows = numGoodWindows + 1;
					windowOffsets(i:numWindows) = windowOffsets(i:numWindows) + creep;
				else
					break;
				end
			end
		end
	end
end
n = numGoodWindows;


