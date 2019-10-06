function plotSignals(data, channels, tasks, graphsDir)

for i=1:length(data)
    subjectId = data(i).SubjectID;
    for c=1:length(channels)
        channel = channels{c};
        for t=1:length(tasks)
            task = tasks{t};
            if ~isempty(data(i).(task)) && isfield(data(i).(task), channel)
                signal = data(i).(task).(channel);
            
                subplot(2,3,t);
                plot(signal);
                hold on;
                title([subjectId, '-', task, '-', channel], 'Interpreter', 'none');
            end
        end
        fig = gcf;
        figFileName = [graphsDir, '\', channel, '\', subjectId, '.fig'];
        pngFileName = [graphsDir, '\', channel, '\', subjectId, '.png'];
        savefig(figFileName);
        
        saveas(fig,pngFileName);
        clf;
    end
end
end