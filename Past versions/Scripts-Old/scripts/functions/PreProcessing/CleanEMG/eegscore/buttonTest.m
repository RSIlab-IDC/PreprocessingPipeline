global testFig h;
testFig = figure('BackingStore', 'off','Name', 'DragTest');
h = axes('Parent',testFig,'XLim', [0 800], 'YLim', [0 800]);
set(h,'ButtonDownFcn','cbButton');


