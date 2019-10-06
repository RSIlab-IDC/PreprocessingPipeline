global eventChannel;
TestFig = figure;
eventChannel{1} = '    ';
mnuFile = uimenu(TestFig,'Label','File');
mnuOptions = uimenu(TestFig,'Label','Options');
sbmnuDisplay = uimenu('Parent',mnuOptions,'Label','Display');
sbmnuEvent = uimenu('Parent',mnuOptions,'Label','Set Event Channel', ...
	'Callback', 'eventChannel = inputdlg(''Event Channel:''),testevent;');
