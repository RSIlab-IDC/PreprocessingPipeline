function eegshelp(action)
%
% function eegshelp(action)
% This function displays help windows for
% selections in the Help menu of eegscore
% script to display instructions for eegscore
eegsinclude;
switch action

case 'newFeatures',
	helpText(1,1) = {'      Specify individual channel names, display order, visibility, range, and offset.'};
	helpText(1,2) = {'     '};
	helpText(1,3) = {'      Place fixed channels (e.g. eye, heart or trigger) at the bottom of the screen.  These do not scroll when moving through the rest of the channels. '};
	helpText(1,4) = {'     '};
	helpText(1,5) = {'      Jump to next or previous ''bad'' period in the record. '};
	helpText(1,6) = {'     '};
	helpText(1,7) = {'      Jump to next or previous event if event channels have been recorded. '};
	helpText(1,8) = {'     '};
	helpText(1,9) = {'      Compute the number of good 1 sec, 0.5 sec overlap windows which can be used to estimate the power spectral density. '};
	helpText(1,10) = {'     '};
	helpText(1,11) = {'      Print current EEG display'};
	helpText(1,12) = {'     '};
	helpText(1,13) = {'      Vertical scales are now located on alternating ends of the plots since they all could have different scales and need to be labelled. Selecting data with the left button marks it bad, with the right button good; or you can change your mind in the Edit Options window as before.  Click on the numGoodWins button to compute the total number of good 1sec/0.5sec overlap windows in the scored data. This needs to be manually updated after additional scoring since it can take about 20s on 128 channel data.'}; 


case 'chanSettings',
	helpText(1,1) = {'     Modifications to the channel display (and also to the config file) are made using a new button called ''chan settings'' where you can edit each channel''s name, display order, range/offset, and set whether to use the range/offset values, whether the channel will be displayed (visibility), and whether the channel should be displayed in a fixed window at the bottom of the screen.'};
	helpText(1,2) = {'     After you click ''chan settings'' to open the channel edit window, first click on the channel you want to edit in the listbox in the upper left, you can then use the up/down arrow keys to scroll through the channels and see each one''s settings. Once a particular channel is selected its properties can be edited in the appropriate windows. The ''use range/offset'' button must be selected for the input range/offset values to be used. The other channels which don''t have ''use range/offset'' checked are controlled by the Yin, Yout buttons.'};


case 'markGoodBad',

	helpText(1,1) = {'     Marking areas of the EEG record as bad/good is done by selecting the channels and time range on the screen by dragging the mouse with the left/right button held down. Upon finishing the selection and letting up the button the Edit Options window appears.  This window lists the time and channel range of the selection.  In addition, the length of the selection in seconds and the frequency corresponding to this delta t are listed.  If the selection was made with the left mouse button the mark bad option is already selected. If the right mouse button was used the mark good option is selected. These can be changed if desired. Options are available to mark bad/good all times for the selected channels or all channels for the selected times.  It is also possible to manually input the time range. Click ''Doit'' to carry out the desired marking or ''Cancel'' to return to the main plots window. '};


case 'configFile',
	helpText(1,1) = {'     eegscoreNEW requires a more complicated configuration file than the previous version. After you hit ''load'' it will prompt you whether to create a default, open an existing, or modify an existing configuration file.  Choose create default if this is the first time scoring a particular type of data.  A basic configuration file will be created which tells eegscoreNEW to display the channels in numerical order with channels named with their display number, and no fixed channels or channel with adjusted range or bias. If you have chosen create a new or modify an existing configuration file then at the end of the scoring session you will be prompted to save the configuration file (and change its name, if desired) with all the modifications made during the session.'};


case 'numGoodWins',
	helpText(1,1) = {'     Clicking on the NumGoodWindows button will compute the number of good 1 second windows with 0.5 second overlap that dopowerall will use for estimating the power spectral densities for both fixed and floating windows'};

case 'close',
   set(helpFig,'Visible', 'off');
   return;
   
otherwise,
	disp(action);
end
bgColor = [1 1 1]*0.8;
winName = ['Help: ' action];
helpFig = figure('BackingStore', 'off', ...
	'Name', winName, ...
	'NumberTitle', 'off', ...
	'CloseRequestFcn', 'eegshelp(''close'')', ...
	'Position',[100 100 400 600], ...
	'Color', bgColor, ...
	'Units', 'normalized', ...
	'Menubar', 'none');
textpos =  [0.05 0.15 0.9 0.8];
h = uicontrol('Parent', helpFig, ...
	'Style', 'text', ...
	'BackgroundColor', [1 1 1], ...
	'Units', 'normalized', ...
   'Position', textpos, ...
   'FontUnits', 'normalized', ...
	'Fontsize', 0.03, ...
	'HorizontalAlignment','left');
outstring = textwrap(h,helpText);
set(h,'String',outstring);
closeButton = uicontrol('Parent',helpFig, ...
	'Style', 'pushbutton', ...
	'FontUnits','normalized', ...
	'FontSize',0.4, ...
	'Units', 'normalized', ...
	'Position',[0.40 0.05 0.20 0.05], ...
	'String', 'Close', ...
   'CallBack','eegshelp(''close'')');
