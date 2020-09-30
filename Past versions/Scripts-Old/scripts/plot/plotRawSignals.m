

% Plot SIGNALS graphs for each couple

% load the data structure
fileName = [GetASBasePath(),'\Matlab\data\ASRawData.mat'];
load(fileName,'-mat')


% folders for the graph files
graphsDir = [GetASBasePath(),'\Matlab\data\Figures'];

rawChannels = {};
rawChannels{1} = 'RAW_EDA';
rawChannels{2} = 'HR';
% rawChannels{3} = 'RMS_Zyg';
% rawChannels{4} = 'RMS_Corr';
% rawChannels{5} = 'RMS_Orb';
rawChannels{3} = 'EMG_ZYG';
rawChannels{4} = 'EMG_Corr';
rawChannels{5} = 'EMG_Orb';


tasks = {};
tasks{1} = 'MainStory';
tasks{2} = 'FirstBaseline';
tasks{3} = 'SecondBaseline';
tasks{4} = 'RatingNegative';
tasks{5} = 'RatingPositive';


numSubjects = size(ASRawData,2);

plotSignals(ASRawData, rawChannels, tasks, graphsDir);
    
    
    




