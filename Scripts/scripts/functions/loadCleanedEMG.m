% function loadCleanedEMG

channels = {'EMG_ZYG', 'EMG_Corr', 'EMG_Orb'};
powerChannels = {'EMG_POWER_ZYG', 'EMG_POWER_Corr', 'EMG_POWER_Orb'};
cleanChannels = {'Clean_EMG_POWER_ZYG', 'Clean_EMG_POWER_Corr', 'Clean_EMG_POWER_Orb'};

tasks = {'MainStory', 'FirstBaseline', 'SecondBaseline', 'RatingNegative', 'RatingPositive'};

% load the data structure
fileName = [GetASBasePath(),'\Matlab\data\ASData.mat'];
load(fileName,'-mat')
cleanedFileName = [GetASBasePath(),'\Matlab\data\ProcessedData\EMG\Sorted\emgResults.mat'];
load(cleanedFileName,'-mat')

numSubjects = length(ASData);

for i=1:1:numSubjects
    subjectID =  ASData(i).SubjectID
    cleanedIndex = 0;
    for jj=1:length(emgResults)
        if strcmp(subjectID, emgResults(jj).sessionId)
            cleanedIndex = jj;
            break;
        end
    end
    if cleanedIndex == 0
        continue;
    end
    for t=1:length(tasks)
        task=tasks{t};
        for c=1:length(channels)
            channel = channels{c};
            powerChannel = powerChannels{c};
            cleanChannel = cleanChannels{c};
            taskStr = task;
            if isfield(emgResults(cleanedIndex), taskStr) && isfield(emgResults(cleanedIndex).(taskStr), channel)
                cleanedSignal = emgResults(cleanedIndex).(taskStr).(channel);
                if isfield(ASData(i).(taskStr), powerChannel) && ~isempty(ASData(i).(taskStr).(powerChannel))
                    ASData(i).(taskStr).(cleanChannel) = cleanedSignal;
                end
            end
        end
    end
end
% saving the data structure to a file
dirToSave = [GetASBasePath(),'\Matlab\data\ASData'];
save(dirToSave, 'ASData');

% end