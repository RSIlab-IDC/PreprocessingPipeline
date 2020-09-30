function eegsUpdateDisplayOrder
%
% function eegsUpdateDisplayOrder
% 
% This function updates the global DisplayOrder vector by taking
% values from chanInfo(i).number where i is the channel number and  
% the .number element is the display order number for 
% the channel.  If .number <= 0 that channel is not displayed
%
% Define global values
eegsinclude;
DisplayOrder = [];
chanFixed = [];
for i=1:totChans
 if chanInfo(i).isVisible > 0 
    DisplayOrder = [DisplayOrder chanInfo(i).displayOrder];
 end
 if chanInfo(i).fixed > 0
    chanFixed = [chanFixed i];
 end
end
