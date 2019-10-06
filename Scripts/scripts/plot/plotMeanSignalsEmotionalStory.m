function plotMeanSignals

% load the data structure
fileName = [GetASBasePath(),'\Matlab\data\ISCData\workMatrixes.mat'];
load(fileName,'-mat')
matrixes = workMatrixes;

fileName = [GetASBasePath(),'\Matlab\data\SM_Data.mat'];
load(fileName,'-mat');



% folders for the graph files
graphsDir = [GetASBasePath(),'\Matlab\results\figures\mean signals'];


taskChannels = {};
taskChannels{1} = 'EMG_POWER_ZYG';
taskChannels{2} = 'EMG_POWER_Corr';
% taskChannels{3} = 'EMG_POWER_Orb';
taskChannels{3} = 'HR';
taskChannels{4} = 'PHASIC_EDA';


tasks = {};
tasks{1} = 'EmotionalStory';
tasks{2} = 'Intro';

SMTasks = {};
SMTasks{1} = 'mainStoriesData';
SMTasks{2} = 'introData';
for d=1:2
    for c=1:length(taskChannels)
        channel = taskChannels{c};
        for t=1:length(tasks)
            task = tasks{t};
            sm_Task = SMTasks{t};
            signalMat = matrixes{d,t}{1,c};
            meaSignal = zscore(nanmean(signalMat));
            SM_signal = zscore(SM_Data.(sm_Task).(channel));
            plot(meaSignal, 'r');
            hold on;
            plot(SM_signal, 'b');
            title([task, '-', channel, '_', num2str(d+1), 'D mean signal'], 'Interpreter', 'none');
            legend('MeanSignal', 'SM_signal');
            fig = gcf;
            figFileName = [graphsDir, '\', task, '_', channel, '_', num2str(d+1), 'D.fig'];
            pngFileName = [graphsDir, '\', task, '_', channel, '_', num2str(d+1), 'D.png'];
            savefig(figFileName);
            saveas(fig,pngFileName);
            clf;
        end
        
        
    end
    
end
