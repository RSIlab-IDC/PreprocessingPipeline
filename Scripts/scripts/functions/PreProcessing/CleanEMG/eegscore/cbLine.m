function cbLine(action)
global testFig h;
[x,y] = ginput(1);
%x0 = get(findobj(h,'Tag','rightLine'),'XData');
switch action
   case 'right',
      set(findobj(h,'Tag','rightLine'),'XData',[x x]);
   case 'left',
      set(findobj(h,'Tag','leftLine'),'XData',[x x]);
   otherwise,
      disp(action);
end
   
   

