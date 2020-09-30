



% load the data structure
fileName = [GetASBasePath(),'\Matlab\data\ASRawData3D.mat'];
load(fileName,'-mat')
data = ASRawData;
% folders for the txt files
filesDir = [GetASBasePath(),'\Matlab\data\PreProcessedData\ECG_3D'];

xlsFilesDir = [GetASBasePath(),'\Matlab\data\PreProcessedData\ECG_3D\Excell\all'];

tasks = {};
tasks{1} = 'MainStory';
tasks{2} = 'FirstBaseline';
tasks{3} = 'SecondBaseline';
tasks{4} = 'RatingNegative';
tasks{5} = 'RatingPositive';

tasksNames = {};
tasksNames{1} = 'AS';
tasksNames{2} = 'ASb1';
tasksNames{3} = 'ASb2';
tasksNames{4} = 'ASrn';
tasksNames{5} = 'ASrp';



numSubjects = length(data);
for r=1:length(data)
    
    fprintf('Creating HR txt files for session %s...\n',data(r).SubjectID)
    
    
    for t=1:length(tasks)
        task = tasks{t}
        taskName = tasksNames{t};
        
        Mat = [];
        if isempty(data(r).(task))
            continue;
        end
        Mat(:,1)=data(r).(task).ECG;
        Mat(:,2)=data(r).(task).RSP;
        Mat(:,3)=data(r).(task).RAW_EDA;
        fileName = [taskName, '_',data(r).SubjectID, '_ECG.txt'];
        fileFullName = [filesDir '\', fileName];
        fileName = [taskName, '_',data(r).SubjectID, '_ECG.xlsx'];
        processedFullName = [xlsFilesDir '\', fileName];
        
        if ~exist(fileFullName, 'file') && ~exist(processedFullName, 'file') %Create file only if new
            dlmwrite(fileFullName,Mat);
        end
        
    end
    
    
end

