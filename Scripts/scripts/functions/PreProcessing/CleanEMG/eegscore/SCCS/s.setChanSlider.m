h19216
s 00058/00000/00000
d D 1.1 01/07/06 11:44:36 greischar 1 0
c date and time created 01/07/06 11:44:36 by greischar
e
u
U
f e 0
t
T
I 1
function setChanSlider
%
% This function sets up the range and steps for the channel slider
%
% Set up max and min values for channel slider
eegsinclude;
NChanToDisplay = length(DisplayOrder);
numChansChange = numChansShown - numFixed;

% Make channel slider inert if there is display room for all channels
if NChanToDisplay == numChansShown
	set(channelSlider,'Max', 1.00001, ...
	'Min', 1, ...
	'Value', 1.00001, ...
	'SliderStep',[0.0 0.000001]);
	return;
end

% MaxValue holds value such that DisplayOrder(MaxValue,....MaxValue+numChansChange-1) are the
% last elements of DisplayOrder excluding fixed channels
MaxValue = NChanToDisplay - numFixed - (numChansChange - 1);
if (MaxValue == 1)
   MinValue = 0.999;
else
   MinValue = 1;
end
if (NChanToDisplay  > 1) & (NChanToDisplay  ~= numChansChange)
   if (numChansChange < (NChanToDisplay - numFixed - numChansChange))
      %set bigstep to jump by numChansChange
      bigStep = numChansChange/((NChanToDisplay - numFixed)  - numChansChange);
   else
      bigStep = 1;
   end
   if (numChansChange == 1)
      smallStep = bigStep/1.00001;   %want both steps ~ equal
   else
      smallStep = 1/((NChanToDisplay - numFixed)  - numChansChange);
   end
else
   bigStep = 1;
   smallStep = bigStep/2;
end
% check if chanStart needs to be reset
if chanStart > MaxValue
	chanStart = MaxValue;
end
% make sure that bigStep and smallStep are not equal
if (bigStep == smallStep)
	smallStep = bigStep/1.00001;
end
sliderValue = (NChanToDisplay - (numChansShown - 2)) - chanStart;
sliderValue = max(min(sliderValue, MaxValue), 1);
set(channelSlider, ...
	'Visible', 'on', ...
	'Max', MaxValue, ...
	'Min', MinValue, ...
	'SliderStep',[smallStep bigStep], ...
	'Value',sliderValue);
E 1
