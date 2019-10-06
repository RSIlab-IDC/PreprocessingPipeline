function plotMeanSignals

% load the data structure
fileName = [GetASBasePath(),'\Matlab\data\ISCData\matrixes.mat'];
load(fileName,'-mat')


% folders for the graph files
graphsDir = [GetASBasePath(),'\Matlab\results\figures\mean signals'];


taskChannels = {};
taskChannels{1} = 'EMG_POWER_ZYG';
taskChannels{2} = 'EMG_POWER_Corr';
taskChannels{3} = 'EMG_POWER_Orb';
taskChannels{4} = 'HR';
taskChannels{5} = 'PHASIC_EDA';


tasks = {};
tasks{1} = 'MainStory';
% tasks{2} = 'FirstBaseline';
% tasks{3} = 'SecondBaseline';
% tasks{4} = 'RatingNegative';
% tasks{5} = 'RatingPositive';

for d=1:2
for c=1:length(taskChannels)
    channel = taskChannels{c};
    for t=1:length(tasks)
        task = tasks{t};
        
        signalMat = matrixes{1,t}{1,c};
        meaSignal = nanmean(signalMat);
        plot(meaSignal);
        hold on;
        title([task, '-', channel, '-', num2str(d+1), 'D mean signal'], 'Interpreter', 'none');
        if strcmp(task, 'MainStory')
            text(0,meaSignal(1),'\downarrow Empty Chair','HorizontalAlignment','left');
            t= text(31,meaSignal(31),'\downarrow First Slide','HorizontalAlignment','left');
            set(t,'Color','red');
            text(41,meaSignal(41),'\downarrow Galia Appears','HorizontalAlignment','left');
%             text(63,meaSignal(41),'\downarrow Galia Smiles','HorizontalAlignment','left');
            text(81,meaSignal(81),'\downarrow Galia Start Talking','HorizontalAlignment','left');
            text(150,meaSignal(150),'\downarrow Second Slide','HorizontalAlignment','left');
            text(160,meaSignal(160),'\downarrow Galia Tells Story','HorizontalAlignment','left');
            text(516,meaSignal(516),'\downarrow Empty Chair','HorizontalAlignment','left');
        end
        fig = gcf;
        hold off;
        figFileName = [graphsDir, '\', task, '_', channel, '_', num2str(d+1), 'D.fig'];
        pngFileName = [graphsDir, '\', task, '_', channel, '_', num2str(d+1), 'D.png'];
        savefig(figFileName);
        saveas(fig,pngFileName);
        clf;
    end
    
    
end
end
for d=1:2
    negMat = matrixes{d,6};
    meaSignal = nanmean(negMat);
    plot(meaSignal);
    title(['Negative rating mean signal ', num2str(d+1), 'D'], 'Interpreter', 'none');
    fig = gcf;
    figFileName = [graphsDir, '\negative_rating_', num2str(d+1), 'D.fig'];
    pngFileName = [graphsDir, '\negative_rating_', num2str(d+1), 'D.png'];
    savefig(figFileName);
    saveas(fig,pngFileName);
    clf;
end

for d=1:2
    posMat = matrixes{d,7};
    meaSignal = nanmean(posMat);
    plot(meaSignal);
    title(['Positive rating mean signal ', num2str(d+1), 'D'], 'Interpreter', 'none');
    fig = gcf;
    figFileName = [graphsDir, '\positive_rating_', num2str(d+1), 'D.fig'];
    pngFileName = [graphsDir, '\positive_rating_', num2str(d+1), 'D.png'];
    savefig(figFileName);
    saveas(fig,pngFileName);
clf;
end