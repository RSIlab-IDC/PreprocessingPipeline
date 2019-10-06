clear;
datafileName = [GetASBasePath(), '\Matlab\data\ASData.mat'];
load(datafileName,'-mat')

Ids = {'1_1_3','1_1_4', '1_1_5', '1_1_6', '1_1_7', '1_1_8', '1_1_9', ...
        '1_1_10', '1_1_11', '1_1_12', '1_1_13', '1_1_14', '1_1_16', '1_1_17', '1_1_18',...
        '2_1_4', '2_1_5', '2_1_6', '2_1_7', '2_1_8', '2_1_9', '2_1_10', '2_1_11'...
        , '2_1_12', '2_1_13', '2_1_14', '2_1_15', '2_1_16', '2_1_17', '2_1_18'}

taskChannels = {};
taskChannels{1} = 'EMG_POWER_ZYG';
taskChannels{2} = 'EMG_POWER_Corr';
taskChannels{3} = 'EMG_POWER_Orb';
taskChannels{4} = 'HR';
taskChannels{5} = 'PHASIC_EDA';

cleanChannels = {};
cleanChannels{1} = 'Clean_EMG_POWER_ZYG';
cleanChannels{2} = 'Clean_EMG_POWER_Corr';
cleanChannels{3} = 'Clean_EMG_POWER_Orb';
cleanChannels{4} = 'Clean_HR';
cleanChannels{5} = 'PHASIC_EDA';

tasks = {};
tasks{1} = 'MainStory';
tasks{2} = 'FirstBaseline';
tasks{3} = 'SecondBaseline';
tasks{4} = 'RatingNegative';
tasks{5} = 'RatingPositive';

tasksLength = [526, 350, 300, 286, 286];


matrixes = {};
couplesIds = {};


ind=0;
for i=1:size(ASData,2)
    subjectID = ASData(i).SubjectID
    exist=0;
    for ttt=1:size(Ids,2)
       if strcmp(subjectID, Ids{ttt}) 
           exist = 1;
           ind = ind+1;
           break;
       end
    end
    if ~exist
        continue;
    end
    couplesIds{ind} = subjectID
    for t=1:size(tasks,2)
        task = tasks{t}
        length = tasksLength(t)
        for c=1:size(taskChannels,2)
            channel = taskChannels{c}
            cleanChannel = cleanChannels{c};
            
            data = NaN;
            if ~isempty(ASData(i).(task)) && isfield(ASData(i).(task), cleanChannel)
                data = ASData(i).(task).(cleanChannel)(1:length);
            elseif ~isempty(ASData(i).(task)) && isfield(ASData(i).(task), channel)
                data = ASData(i).(task).(channel)(1:length);
            end
            
            matrixes{1,t}{1,c}(ind,:)=data;
            
        end
    end
    negRating = NaN;
    if ~isempty(ASData(i).NegativeRating)
        negRating = ASData(i).NegativeRating(:,2);
    end
    matrixes{1,6}(ind,:)=negRating;
    posRating = NaN;
    if ~isempty(ASData(i).PositiveRating)
        posRating = ASData(i).PositiveRating(:,2);
    end
    matrixes{1,7}(ind,:)=posRating;
end


dirToSave = [GetASBasePath(),'\Matlab\data\ISCData\partialMatrixes'];
save(dirToSave, 'matrixes');

dirToSave = [GetASBasePath(),'\Matlab\data\ISCData\partialCouplesIds'];
save(dirToSave, 'couplesIds');

loadEditedPartialMatrixes();

