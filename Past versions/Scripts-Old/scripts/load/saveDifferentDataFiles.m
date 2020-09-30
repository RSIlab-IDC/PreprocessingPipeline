

numSubjects = length(ASRawData);

ASRawDataFemale = {};
ASRawDataMale = {};

tasks = {};
tasks{1} = 'MainStory';
tasks{2} = 'FirstBaseline';
tasks{3} = 'SecondBaseline';
tasks{4} = 'RatingNegative';
tasks{5} = 'RatingPositive';


for i=1:1:32
    for t=1:5
    ASRawDataFemale(i).SubjectID = ASRawData(i).SubjectID;
    ASRawDataFemale(i).(tasks{t}) = ASRawData(i).(tasks{t});
    end
end

for i=33:58
    
    ASRawDataMale(i-32).SubjectID = ASRawData(i).SubjectID;
    for t=1:5
    ASRawDataMale(i-32).SubjectID = ASRawData(i).SubjectID;
    ASRawDataMale(i-32).(tasks{t}) = ASRawData(i).(tasks{t});
    end
    
end

dirToSave = [GetASBasePath(),'\Matlab\data\ASRawDataFemale.mat'];
save(dirToSave, 'ASRawDataFemale', '-v7.3'); % in case of a big file use this addition to compress - , '-v7.3') ;
dirToSave = [GetASBasePath(),'\Matlab\data\ASRawDataMale.mat'];
save(dirToSave, 'ASRawDataMale', '-v7.3'); % in case of a big file use this addition to compress - , '-v7.3') ;