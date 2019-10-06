h32699
s 00022/00000/00000
d D 1.1 01/07/06 11:41:14 greischar 1 0
c date and time created 01/07/06 11:41:14 by greischar
e
u
U
f e 0
t
T
I 1
% script to display instructions for eegscore
position = [200 200 500 600];
bgColor = [1 1 1]*0.8;
helpFig = figure('BackingStore', 'off','Name', 'EEGSCORE Description', ...
	'NumberTitle', 'off', ...
	'Position',position, 'Color', bgColor, ...
	'Menubar', 'none');
textpos =  [0 50 500 550];
%helpText(1,1) = {'     eegscoreNEW requires a much more complicated configuration file than the previous version. Thus, it was decided to set up the configuration file prior to scoring.  Go to the directory containing the files to be scored and start eegscoreNEW.  Choose a representative file for setting up the configuration file.  After you hit ''load'' in the Files window a question dialog will prompt whether to create a default config file, open an existing one, or change an existing one.  Choose the create default config file.  A basic configuration file will be created which tells eegscoreNEW to display the channels in numerical order with channels named with their display number, and no fixed channels or channel with adjusted range or bias (ie pretty much like the original eegscore).  Set up the channel settings for a good initial state for starting each scoring session. Upon exiting from eegscoreNEW a prompt will ask if you want to change the name of the config file from the default (e.g. EEGSCORE128v1.CFG) where 128 is the number of channels in the data.  Restart eegscoreNEW and at the configuration prompt choose open existing config file.  Now you will be at a good starting setup and can make minor channel adjustments with ''chan settings'' (described below) in order to more easily score this file; however, these minor setting changes will not be saved at the end of the scoring session.  If it is necessary to change the original config file (if something set up in the original turns out to be a bad setting) start up eegscoreNEW, choose the ''change existing config'' at the prompt, make the needed changes and upon exiting there will be the prompt to save these changes.'};
helpText(1,1) = {'P1 '};
helpText(1,2) = {'     Modifications to the channel display (and also to the config file) are made using a new button called ''chan settings'' where you can edit each channel''s name, display order, range/offset, and set whether to use the range/offset values, whether the channel will be displayed (visibility), and whether the channel should be displayed in a fixed window at the bottom of the screen.'};
helpText(1,3) = {'     After you click ''chan settings'' to open the channel edit window, first click on the channel you want to edit in the listbox in the upper left, you can then use the up/down arrow keys to scroll through the channels and see each one''s settings. Once a particular channel is selected its properties can be edited in the appropriate windows. The ''use range/offset'' button must be selected for the input values to be used. The other channels which don''t have ''use range/offset'' checked are controlled by the Yin, Yout buttons.'};
helpText(1,4) = {'      Vertical scales are now located on alternating ends of the plots since they all could have different scales and need to be labelled. Selecting data with the left button marks it bad, with the right button good; or you can change your mind in the Edit Options window as before.  Click on the numGoodWins button to compute the total number of good 1sec/0.5sec overlap windows in the scored data. This needs to be manually updated after additional scoring since it can take about 20s on 128 channel data.'};
helpText(1,5) = {'     Upon exiting or choosing another file the option to change the name for the saved config file is given in case it might be useful for a particular type of file left to be scored.'}; 
h = uicontrol('Parent', helpFig, 'Style', 'text', ...
	'BackgroundColor', [1 1 1], ...
	'Position', textpos, ...
	'Fontsize', 14, ...
	'HorizontalAlignment','left');
outstring = textwrap(h,helpText);
set(h,'String',outstring);

E 1
