load('CHANNELLOG2.mat');
tempChannelLoc = cell2table(CHANNELLOG.ToCleanChannelLocation);
tempChannelLoc.newName = tempChannelLoc.Var1;

flagDoNotTouch = {'DNC'};
strToSearch = {'SOF'};
buffer = {'D:\playingGround\SOF'};
for i=1:height(tempChannelLoc)
    if ~contains(tempChannelLoc.Var1(i),flagDoNotTouch)
        strToEdit = tempChannelLoc.newName(i);
        tempChannelLoc.newName(i) = strcat(buffer,extractAfter(strToEdit, strToSearch));
    end
end

CHANNELLOG.ToCleanChannelLocation = tempChannelLoc.newName;
save('CHANNELLOG','CHANNELLOG');