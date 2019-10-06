function eegsBuildDisplayOrder
%
% function eegsBuildDisplayOrder
% 
% This function builds the global DisplayOrder vector by putting
% the channel number in the .DisplayOrder position of the 
% DisplayOrder vector; channels set to not visible 
% (isVisible == 0) are squeezed out of the DisplayOrder vector
% and Fixed channels are counted (numFixed) and moved to end
% of DisplayOrder vector

% Define global values
eegsinclude;

m = [];
DisplayOrder = zeros(1,totChans);
for i=1:totChans
	m = [m chanInfo(i).displayOrder];
	if chanInfo(i).isVisible > 0 
		DisplayOrder(chanInfo(i).displayOrder) = i;
	end
end
if duplicate(m) > 0
        msg = [{'Duplicates found in DisplayOrder array.'} ...
		{'Check for missing channels and change'} ...
		{'their display order to unused values.'}];
	b = warndlg(msg, ' ');
end

% move fixed channels to end of DisplayOrder vector
numFixed = 0;
for i=1:totChans
	if DisplayOrder(i) > 0 & chanInfo(DisplayOrder(i)).fixed > 0
		numFixed = numFixed + 1;
		tmp = DisplayOrder(i);
		DisplayOrder(i) = 0;
		DisplayOrder = [DisplayOrder tmp];
	end
end

% squeeze zeros (ie invisible and moved fixed channels) out of vector
DisplayOrder = DisplayOrder(find(DisplayOrder>0));
