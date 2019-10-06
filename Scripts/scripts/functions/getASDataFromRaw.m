function outData = getASDataFromRaw(sampleRawData, badSignals, tasks, taskChannels)

outData = {};



numSubjects = length(sampleRawData);

for i=1:1:numSubjects
    outData(i).SubjectID =  sampleRawData(i).SubjectID;
    for c=1:length(taskChannels)
        channel = taskChannels{c};
        badChannelName = channel;
        if strcmp(channel, 'EMG_POWER_ZYG') 
            badChannelName = 'EMG_ZYG';
        elseif strcmp(channel, 'EMG_POWER_Corr') 
            badChannelName = 'EMG_Corr';
        elseif strcmp(channel, 'EMG_POWER_Orb') 
            badChannelName = 'EMG_Orb';
        elseif strcmp(channel, 'PHASIC_EDA') 
            badChannelName = 'EDA';
        end
        
        for t=1:length(tasks)
            task = tasks{t};
            if ~isempty(sampleRawData(i).(task)) && isfield(sampleRawData(i).(task), channel)
                if isempty(badSignals) || ~isfield(badSignals(i), task) || isempty(badSignals(i).(task)) || ~badSignals(i).(task).(badChannelName)
                    outData(i).(task).(channel) = sampleRawData(i).(task).(channel);
                end
            end
        end
    end
end


end