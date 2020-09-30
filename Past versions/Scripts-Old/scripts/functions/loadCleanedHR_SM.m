% function loadCleanedHR


% load the data structure
fileName = [GetASBasePath(),'\Matlab\data\SM_Data.mat'];
load(fileName,'-mat')
cleanedFileName = [GetASBasePath(),'\Matlab\data\ProcessedData\HR\SM_HRdata.mat'];
load(cleanedFileName,'-mat')


cleanedSignal = SM_HRdata.HR;
SM_Data.mainStoryFullData.clean_HR = downsample(cleanedSignal,10);
SM_Data.mainStoriesData.clean_HR = SM_Data.mainStoryFullData.clean_HR(169:513);   
SM_Data.introData.clean_HR = SM_Data.mainStoryFullData.clean_HR(12:123);   
    





cleanedFileName = [GetASBasePath(),'\Matlab\data\ProcessedData\EMG\Sorted\SMCleanedEMG.mat'];
load(cleanedFileName,'-mat')

cleanedSignal = SMCleanedEMG.mainStoryFull.EMG_ZYG;
SM_Data.mainStoryFullData.clean_EMG_ZYG = cleanedSignal;
cleanedSignal = SMCleanedEMG.mainStoryFull.EMG_Corr;
SM_Data.mainStoryFullData.clean_EMG_Corr = cleanedSignal;

cleanedSignal = SMCleanedEMG.MainStory.EMG_ZYG;
SM_Data.mainStoriesData.clean_EMG_ZYG = cleanedSignal;
cleanedSignal = SMCleanedEMG.MainStory.EMG_Corr;
SM_Data.mainStoriesData.clean_EMG_Corr = cleanedSignal;

cleanedSignal = SMCleanedEMG.Intro.EMG_ZYG;
SM_Data.introData.clean_EMG_ZYG = cleanedSignal;
cleanedSignal = SMCleanedEMG.Intro.EMG_Corr;
SM_Data.introData.clean_EMG_Corr = cleanedSignal;


% saving the data structure to a file
dirToSave = [GetASBasePath(),'\Matlab\data\SM_Data'];
save(dirToSave, 'SM_Data');
