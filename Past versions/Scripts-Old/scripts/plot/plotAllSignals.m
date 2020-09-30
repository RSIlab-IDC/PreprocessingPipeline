

% Plot SIGNALS graphs for each couple


% load the data structure
fileName = [GetASBasePath(),'\Matlab\data\ASData.mat'];
load(fileName,'-mat')

% folders for the graph files
graphsDir = [GetASBasePath(),'\Matlab\data\Figures'];


processedChannels = {};
processedChannels{1} = 'PHASIC_EDA';
processedChannels{2} = 'EMG_POWER_ZYG';
processedChannels{3} = 'EMG_POWER_Corr';
processedChannels{4} = 'EMG_POWER_Orb';


tasks = {};
tasks{1} = 'MainStory';
tasks{2} = 'FirstBaseline';
tasks{3} = 'SecondBaseline';
tasks{4} = 'RatingNegative';
tasks{5} = 'RatingPositive';

    
plotSignals(ASData, processedChannels, tasks, graphsDir);
    
    




