
% loading all data from mat files to a single dataset mat file

clear all;
badListExist = 0;
SAMPLE_RATE = 1000;
DOWNSAMPLE_RATE=1000;
RAW_DOWNSAMPLE_RATE=1000;
% the data structure with all the experiment data
ASRawData = {};
expFilesFolder = [GetASBasePath(), '\rawdata\acq_2D'];


files=dir(expFilesFolder);
% a loop over all files to collect subjects IDs
Subjects_Id =[];
run = 0;
%a loop over all files to gather all sessions ids. 
% based on the assumption that the file name begins with the session ID :
% 'SessionID_Task_Desc1' / 'SessionID_Task_Desc2'
for i=3:length(files)
    
    file_Name = files(i).name; 
    if ~isempty(strfind(file_Name, 'AS_'))
        ind=4;
    elseif ~isempty(strfind(file_Name, 'ASb1_'))
        ind=6;
    elseif ~isempty(strfind(file_Name, 'ASb2_'))
        ind=6;
    elseif ~isempty(strfind(file_Name, 'ASrn_'))
        ind=6;    
    elseif ~isempty(strfind(file_Name, 'ASrp_'))
        ind=6;
    else
        continue;
    end
    run=run+1;
    Subjects_Id{run} = files(i).name(ind:end-4);

end
Subjects_Id = unique(Subjects_Id);




for i=3:length(files)
    file_Name = files(i).name
    if ~isempty(strfind(file_Name, 'AS_'))
        Subject_Id = file_Name(4:end-4)
        taskName = 'MainStory';
    elseif ~isempty(strfind(file_Name, 'ASb1_'))
        Subject_Id = file_Name(6:end-4)
        taskName = 'FirstBaseline';
    elseif ~isempty(strfind(file_Name, 'ASb2_'))
        Subject_Id = file_Name(6:end-4)
        taskName = 'SecondBaseline';
    elseif ~isempty(strfind(file_Name, 'ASrn_'))
        Subject_Id = file_Name(6:end-4)
        taskName = 'RatingNegative';
    elseif ~isempty(strfind(file_Name, 'ASrp_'))
        Subject_Id = file_Name(6:end-4)
        taskName = 'RatingPositive';
    else
        continue;
    end
    subject_ind = 0;
    for j=1:length(Subjects_Id)
        if strcmp(Subjects_Id{j}, Subject_Id)
            subject_ind = j;
            break;
        end
    end
    
    
    %adding the ID to the experiments data structure
    ASRawData(subject_ind).SubjectID = Subject_Id;
    % adding the Baseline solo Data to the experiments data structure
    DatafileName = [expFilesFolder, '\', file_Name];
    
    
    switch taskName
        case 'MainStory'
            ttlChannel = 12;
        case 'RatingNegative'
            ttlChannel = 12;
        case 'RatingPositive'
            ttlChannel = 12;
        otherwise
            ttlChannel = 0;
    end
    
    [taskData] = loadSingleASTaskByTTL(DatafileName, SAMPLE_RATE, ttlChannel, RAW_DOWNSAMPLE_RATE);
    ASRawData(subject_ind).(taskName) = taskData;
    
    
end    

if badListExist
    badSignals = loadBadDataList(ASRawData);
else
    badSignals = {};
end
taskChannels = {};
taskChannels{1} = 'EMG_POWER_ZYG';
taskChannels{2} = 'EMG_POWER_Corr';
taskChannels{3} = 'EMG_POWER_Orb';
taskChannels{4} = 'HR';
taskChannels{5} = 'PHASIC_EDA';
% taskChannels{6} = 'RSP';
tasks = {};
tasks{1} = 'MainStory';
tasks{2} = 'FirstBaseline';
tasks{3} = 'SecondBaseline';
tasks{4} = 'RatingNegative';
tasks{5} = 'RatingPositive';

ASRawData = loadRatingFiles (ASRawData);
% ASRawData = removeProcesedSignals(ASRawData, tasks);
% saving the data structure to a file
dirToSave = [GetASBasePath(),'\Matlab\data\ASRawData.mat'];
save(dirToSave, 'ASRawData', '-v7.3'); % in case of a big file use this addition to compress - , '-v7.3') ;



