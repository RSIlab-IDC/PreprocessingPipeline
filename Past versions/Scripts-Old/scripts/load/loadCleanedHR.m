% function loadCleanedHR

cleanChannel = 'clean_HR';
origChannel = 'HR';
tasks = {'MainStory', 'FirstBaseline', 'SecondBaseline', 'RatingNegative', 'RatingPositive'};

% load the data structure
fileName = [GetASBasePath(),'\Matlab\data\ASData.mat'];
load(fileName,'-mat')
cleanedFileName = [GetASBasePath(),'\Matlab\data\ProcessedData\HR\HRdata.mat'];
load(cleanedFileName,'-mat')

numSubjects = length(ASData);

for i=1:1:length(HRdata)
    sessionId = HRdata(i).sessionId;
    task = HRdata(i).task;
    switch task
        case 'AS'
            taskStr = 'MainStory';
        case 'ASb1'
            taskStr = 'FirstBaseline';
        case 'ASb2'
            taskStr = 'SecondBaseline';
        case 'ASrn'
            taskStr = 'RatingNegative';
        case 'ASrp'
            taskStr = 'RatingPositive';
        otherwise
            continue;
    end        
    mainId = 0;
    for jj=1:length(ASData)
        subjectID =  ASData(jj).SubjectID;
        if strcmp(subjectID, sessionId)
            mainId = jj;
            break;
        end
        
    end
    if mainId == 0
        continue;
    end
    cleanedSignal = HRdata(i).HR;
    if isfield(ASData(mainId).(taskStr), origChannel) && ~isempty(ASData(mainId).(taskStr).(origChannel))
        ASData(mainId).(taskStr).(cleanChannel) = downsample(cleanedSignal,10);
    end
    
end
    
    

% saving the data structure to a file
dirToSave = [GetASBasePath(),'\Matlab\data\ASData'];
save(dirToSave, 'ASData');

% end