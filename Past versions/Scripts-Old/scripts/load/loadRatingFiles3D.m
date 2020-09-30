

function ASData = loadRatingFiles3D (ASData, badSignals)
% loading all data from mat files to a single dataset mat file


% the data structure with all the ranking data
ASRankingData = {};
cutSignalBegining=0.5; %in seconds
cutSignalEnd=0; %in seconds
movieLength = 285;
homeDir = GetASBasePath();
% homeDir = 'D:\Dropbox\personal folders\Tali Aloni\rating';

rankingFilesFolder = [homeDir, '\rawdata\rating_3D'];


files=dir(rankingFilesFolder);
% a loop over all files to collect subjects IDs
subjects_Id =[];
subjectsNum=0;
for i=3:length(files)
    file_Name = files(i).name; 
    ind=strfind(file_Name, '_negative');
    if ind>0
        subjectsNum = subjectsNum+1;
        subjects_Id{subjectsNum} = files(i).name(1:ind-3);
    
    else
        ind=strfind(file_Name, '_positive');
        if ind>0
            subjectsNum = subjectsNum+1;
            subjects_Id{subjectsNum} = files(i).name(1:ind-3);
        end
    end
end
subjects_Id = unique(subjects_Id);
moviesRankingMat={};

for i=3:length(files)
    file_Name = files(i).name; 
    if ~isempty(strfind(file_Name, '_negative'))
        ind=strfind(file_Name, '_negative');
        subject_Id = file_Name(1:ind-3);
        taskName = 'NegativeRating';
        rateTask = 'RatingNegative';
    elseif ~isempty(strfind(file_Name, '_positive'))
        ind=strfind(file_Name, '_positive');
        subject_Id = file_Name(1:ind-3);
        taskName = 'PositiveRating';
        rateTask = 'RatingPositive';
    else
        continue;
    end
    
    flag = 1;
    for j=1:length(ASData)
        if ~isempty(strfind(ASData(j).SubjectID, subject_Id))
            subject_ind = j;
            flag = 0;
            break;
        end
    end
    
    if flag == 0
        if ~isempty(badSignals) && isfield(badSignals(subject_ind), rateTask) && ~isempty(badSignals(subject_ind).(rateTask)) && badSignals(subject_ind).(rateTask).rating
            ASData(subject_ind).(taskName) = [];
            continue;
        end
    end
    % adding the Baseline solo Data to the experiments data structure
    DatafileName = [rankingFilesFolder, '\', file_Name]
     
    ranking = loadSingleASRatingFromFile(DatafileName, movieLength);
%     ranking(:,2)=zscore(ranking(:,2));
%     signalEnd = length(ranking)-cutSignalEnd*2;
%     ranking  = ranking(cutSignalBegining*2:signalEnd,:);
    if flag == 0
        ASData(subject_ind).(taskName) = ranking;
    end
end



