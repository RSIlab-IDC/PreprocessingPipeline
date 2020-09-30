function ASBadSignals = loadBadDataList(sampleRawData)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% creates a structure with all the bad signals from a matching excel file
% input:
%       sampleRawData - the raw signals data structure
%  Output: outData – data structure of a single task 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ASBadSignals={};
BadDataFileName = [GetASBasePath(), '\rawdata\Bad_Signals_rawdata.xlsx'];
for i=1:length(sampleRawData)
    ASBadSignals(i).sessionId = sampleRawData(i).SubjectID;
end



% Read from Excel file with the problematic files data
[num,txt,raw] = xlsread(BadDataFileName, 'BadSignals2d');
%reading the data column
subjectId = raw(2:end,1);
tasks = raw(2:end,2);

cols={};
cols{3}.channel='EDA';
cols{4}.channel='HR';
cols{5}.channel='EMG_ZYG';
cols{6}.channel='EMG_Corr';
cols{7}.channel='EMG_Orb';
cols{8}.channel='rating';




for i=1:length(subjectId)
    a=subjectId(i);
    if ~isnan(a{1,1})
        sessionId=subjectId(i);
    end
    for j=1:length(sampleRawData)
        found=0;
        if strcmp(sessionId{1,1}, sampleRawData(j).SubjectID)
            sessInd=j;
            found=1;
            break;
        end
    end
    if found
        for c=3:length(cols)
            colVal = raw(1+i,c);
            task = tasks(i);
            channel = cols{c}.channel;
            switch(task{1,1})
                case 1
                    currTask = 'MainStory';
                case 2
                    currTask = 'FirstBaseline';
                case 3
                    currTask = 'SecondBaseline';
                case 4
                    currTask = 'RatingNegative';
                case 5
                    currTask = 'RatingPositive';
            end
            
            
            if colVal{1,1}==1
                ASBadSignals(sessInd).(currTask).(channel) = 1;
            else
                ASBadSignals(sessInd).(currTask).(channel) = 0;
            end
        end
    end
end
% saving the data structure to a file
dirToSave = [GetASBasePath(),'\Matlab\data\ASBadSignals'];
save(dirToSave, 'ASBadSignals');
end