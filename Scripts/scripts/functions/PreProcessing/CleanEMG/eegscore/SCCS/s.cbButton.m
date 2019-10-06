h54501
s 00020/00000/00000
d D 1.1 01/07/06 11:37:09 greischar 1 0
c date and time created 01/07/06 11:37:09 by greischar
e
u
U
f e 0
t
T
I 1
function cbButton
global testFig h;
%set(gcf,'Units', 'normal');
point1 = get(gca,'CurrentPoint');
finalRect = rbbox;
point2 = get(gca,'CurrentPoint');
disp('Mouse button was pushed');
xData = [point1(1,1) point1(1,1)];
yData = [point1(1,2) point2(1,2)];
leftLine = line('Parent',h,'Color',[0 0 1], ...
   'ButtonDownFcn', 'cbLine(''left'')', ...
   'Tag', 'leftLine', ...
	'XData', xData, ...
	'YData', yData);
xData = [point2(1) point2(1)];
rightLine = line('Parent',h,'Color',[0 0 1], ...
   'ButtonDownFcn', 'cbLine(''right'')', ...
   'Tag', 'rightLine', ...
	'XData', xData, ...
	'YData', yData);
E 1
