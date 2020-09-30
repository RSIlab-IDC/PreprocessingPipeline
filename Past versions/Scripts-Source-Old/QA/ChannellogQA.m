unqValue=unique(CHANNELLOG.pid);
listValues = CHANNELLOG.pid;
unqCount = zeros(length(unqValue),1);

idx=1;
for i=1:length(unqValue)
    for j=idx:length(listValues)
        if isequal(unqValue(i),listValues(j))
            unqCount(i) = unqCount(i)+1;
        else
            idx=j;
            break
        end
    end
end