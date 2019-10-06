load([GetASBasePath(),'\Matlab\data\ISCData\matrixes.mat']);

workMatrixes = matrixes;

taskChannels = {};
taskChannels{1} = 'EMG_POWER_ZYG';
taskChannels{2} = 'EMG_POWER_Corr';
taskChannels{3} = 'EMG_POWER_Orb';
taskChannels{4} = 'HR';
taskChannels{5} = 'PHASIC_EDA';



for t=size(matrixes,2):-1:2
    workMatrixes{1,t+1}=matrixes{1,t};
end
for c=1:size(taskChannels,2)
    workMatrixes{1,1}{1,c}= getEditedSignal(matrixes{1,1}{1,c},'MainStory');
    workMatrixes{1,2}{1,c}= getEditedSignal(matrixes{1,1}{1,c}, 'Intro');
end

for t=size(matrixes,2):-1:2
    workMatrixes{2,t+1}=matrixes{2,t};
end
for c=1:size(taskChannels,2)
    workMatrixes{2,1}{1,c}= getEditedSignal(matrixes{2,1}{1,c},'MainStory');
    workMatrixes{2,2}{1,c}= getEditedSignal(matrixes{2,1}{1,c}, 'Intro');
end

dirToSave = [GetASBasePath(),'\Matlab\data\ISCData\workMatrixes'];
save(dirToSave, 'workMatrixes');