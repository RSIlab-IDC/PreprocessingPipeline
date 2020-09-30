% clear;

% load 2D
datafileName = [GetASBasePath(), '\Matlab\data\ASData.mat'];
load(datafileName,'-mat')


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
cleanChannels{4} = 'clean_HR';
cleanChannels{5} = 'PHASIC_EDA';

tasks = {};
tasks{1} = 'MainStory';
tasks{2} = 'FirstBaseline';
tasks{3} = 'SecondBaseline';
tasks{4} = 'RatingNegative';
tasks{5} = 'RatingPositive';

tasksLength = [516, 350, 250, 286, 286];


matrixes = {};
couplesIds = {};



for i=1:size(ASData,2)
    subjectID = ASData(i).SubjectID
    couplesIds{1,i} = subjectID;
    for t=1:size(tasks,2)
        task = tasks{t}
        length = tasksLength(t)
        for c=1:size(taskChannels,2)
            channel = taskChannels{c}
            cleanChannel = cleanChannels{c};
            
            data = NaN(1,length);
            if ~isempty(ASData(i).(task)) && isfield(ASData(i).(task), cleanChannel)
%                 if strcmp(subjectID, '2_2_9') && strcmp(task, 'RatingPositive')
%                     data = ASData(i).(task).(cleanChannel)(11:length);
%                 else
%                     data = ASData(i).(task).(cleanChannel)(1:length);
%                 end

                data = ASData(i).(task).(cleanChannel)(1:length);                
                
            elseif ~isempty(ASData(i).(task)) && isfield(ASData(i).(task), channel)
%                 data = ASData(i).(task).(channel)(1:length);
                data = NaN(1,length);
            end
            
            matrixes{1,t}{1,c}(i,:)=data;
            
        end
    end
    negRating = NaN;
    
    if ~isempty(ASData(i).RatingNegative)
        negRating = ASData(i).RatingNegative(:,1);
    end
    
    
%     if ~isempty(ASData(i).NegativeRating)
%         negRating = ASData(i).NegativeRating(:,2);
%     end

    matrixes{1,6}(i,:)=negRating;
    posRating = NaN;
    
    
    if ~isempty(ASData(i).RatingPositive)
        posRating = ASData(i).RatingPositive(:,1);
    end
    
%     if ~isempty(ASData(i).PositiveRating)
%         posRating = ASData(i).PositiveRating(:,2);
%     end
    
    matrixes{1,7}(i,:)=posRating;
end



% load 3D
datafileName = [GetASBasePath(), '\Matlab\data\ASData3D.mat'];
load(datafileName,'-mat')


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
cleanChannels{4} = 'clean_HR';
cleanChannels{5} = 'PHASIC_EDA';

tasks = {};
tasks{1} = 'MainStory';
tasks{2} = 'FirstBaseline';
tasks{3} = 'SecondBaseline';
tasks{4} = 'RatingNegative';
tasks{5} = 'RatingPositive';

tasksLength = [516, 350, 250, 286, 286];



for i=1:size(ASData,2)
    subjectID = ASData(i).SubjectID
    couplesIds{2,i} = subjectID;
    for t=1:size(tasks,2)
        task = tasks{t}
        length = tasksLength(t)
        for c=1:size(taskChannels,2)
            channel = taskChannels{c}
            cleanChannel = cleanChannels{c};
            
            data = NaN(1,length);
            if ~isempty(ASData(i).(task)) && isfield(ASData(i).(task), cleanChannel)
                data = ASData(i).(task).(cleanChannel)(1:length);
            elseif ~isempty(ASData(i).(task)) && isfield(ASData(i).(task), channel)
%                 data = ASData(i).(task).(channel)(1:length);
                data = NaN(1,length);
            end
            
            matrixes{2,t}{1,c}(i,:)=data;
            
        end
    end
    negRating = NaN;
    
    if ~isempty(ASData(i).RatingNegative)
        negRating = ASData(i).RatingNegative(:,1);
    end
    
%     if ~isempty(ASData(i).NegativeRating)
%         negRating = ASData(i).NegativeRating(:,2);
%     end
    
    matrixes{2,6}(i,:)=negRating;
    
    posRating = NaN;
    
    if ~isempty(ASData(i).RatingPositive)
        posRating = ASData(i).RatingPositive(:,1);
    end
    
%     if ~isempty(ASData(i).PositiveRating)
%         posRating = ASData(i).PositiveRating(:,2);
%     end
    
    matrixes{2,7}(i,:)=posRating;
    
end




dirToSave = [GetASBasePath(),'\Matlab\data\ISCData\matrixes'];
save(dirToSave, 'matrixes');

dirToSave = [GetASBasePath(),'\Matlab\data\ISCData\couplesIds'];
save(dirToSave, 'couplesIds');

loadEditedMatrixes();

% taskChannels = {};
% taskChannels{1} = 'clean_EMG_ZYG';
% taskChannels{2} = 'clean_EMG_Corr';
% taskChannels{3} = 'EMG_POWER_Orb';
% taskChannels{4} = 'clean_HR';
% taskChannels{5} = 'PHASIC_EDA';
% SM_matrix = {};
% load([GetASBasePath(), '\Matlab\data\SM_Data.mat']);
% 
% for t=1:size(taskChannels,2)
%     channel = taskChannels{t};
%     if t==3
%         SM_matrix{1,t} = NaN;
%         continue;
%     end
%     SM_matrix{1,t} = SM_Data.mainStoriesData.(channel);
% end
% SM_matrix{1,6} = SM_Data.ratingData;
% for t=1:size(taskChannels,2)
%     channel = taskChannels{t};
%     if t==3
%         SM_matrix{2,t} = NaN;
%         continue;
%     end
%     SM_matrix{2,t} = SM_Data.introData.(channel);
% end
% 
% 
% dirToSave = [GetASBasePath(),'\Matlab\data\ISCData\SM_matrix'];
% save(dirToSave, 'SM_matrix');

