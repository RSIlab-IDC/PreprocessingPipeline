function ASRawData = removeProcesedSignals(ASRawData, tasks)

numSubjects = length(ASRawData);
taskChannels = {};
taskChannels{1} = 'EMG_POWER_ZYG';
taskChannels{2} = 'EMG_POWER_Corr';
taskChannels{3} = 'EMG_POWER_Orb';
taskChannels{4} = 'TONIC_EDA';
taskChannels{5} = 'PHASIC_EDA';
for i=1:1:numSubjects
    for c=1:length(taskChannels)
        channel = taskChannels{c};
        for t=1:length(tasks)
            task = tasks{t};
            if ~isempty(ASRawData(i).(task))
                ASRawData(i).(task) = rmfield(ASRawData(i).(task),channel);
            end
        end
    end
end





end