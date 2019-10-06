load([GetASBasePath(),'\Matlab\data\ISCData\partialMatrixes.mat']);

partialWorkMatrixes = matrixes;

taskChannels = {};
taskChannels{1} = 'EMG_POWER_ZYG';
taskChannels{2} = 'EMG_POWER_Corr';
taskChannels{3} = 'EMG_POWER_Orb';
taskChannels{4} = 'HR';
taskChannels{5} = 'PHASIC_EDA';



for t=size(matrixes,2):-1:2
    partialWorkMatrixes{1,t+1}=matrixes{1,t};
end
for c=1:size(taskChannels,2)
    partialWorkMatrixes{1,1}{1,c}= getEditedSignal(matrixes{1,1}{1,c},'MainStory');
    partialWorkMatrixes{1,2}{1,c}= getEditedSignal(matrixes{1,1}{1,c}, 'Intro');
end


dirToSave = [GetASBasePath(),'\Matlab\data\ISCData\partialWorkMatrixes'];
save(dirToSave, 'partialWorkMatrixes');