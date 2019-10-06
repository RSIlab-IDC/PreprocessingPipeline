
function run_TBT_AS()


homeDir = GetASBasePath();

%% CORR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
outDir=[homeDir, '\Matlab\data\ProcessedData\EMG\Sorted\'];
% outDir=[homeDir, '\Matlab\ProcessedData\EMG\Cleaned\'];

inDir=[homeDir, '\Matlab\data\PreProcessedData\EMG\Cleaned\'];

%% Load DAT and MASK files
emgFiles=dir(inDir);
emgFiles(1:2)=[];

for i=1:length(emgFiles)
    if emgFiles(i).name(end-2:end)=='DAT'
        emgDATs{i}=emgFiles(i).name;
    elseif emgFiles(i).name(end-3:end)=='MASK'
        emgMASKs{i}=emgFiles(i).name;
    end
end

emgDATs=emgDATs(~cellfun('isempty',emgDATs));
emgMASKs=emgMASKs(~cellfun('isempty',emgMASKs));

%% Check for Proccessed Sessions
updateflag=0;
NoNewFlag=0;
% if exist([outDir 'AllEMGResults.mat'],'file')
%    updateflag=1;
%    OldAllEMGResults=load([outDir 'AllEMGResults.mat']);
%    OldEMGResults=load([outDir 'emgResults.mat']);
%    logindice=zeros(1,length(emgDATs));
%    for i=1:length(OldEMGResults.emgResults)
%        logcheck=~cellfun('isempty',strfind(emgDATs,OldEMGResults.emgResults(i).Session));
%        logindice=logindice+logcheck;
%    end
%    emgDATs(logical(logindice))=[];
%    emgMASKs(logical(logindice))=[];
%    if isempty(emgDATs)
%        NoNewFlag=1;
%        fprintf('No new EMG files!\n')
%    end
% end
           
           
%% Calculate PSD for all sessions
AllEMGResults=[];
emgResults=[];
sessCount = 0;
for i=1:length(emgDATs)
%     for i=1:20
    inDatFile=[inDir emgDATs{i}];
    inMaskFile=[inDatFile(1:end-3) 'MASK'];
    [~, name,ext]=fileparts(inMaskFile);
    if ~ismember([name ext],emgMASKs)
        fprintf('No matching MASK file for DAT file: %s\n',name); 
        continue
    end
    
    indx = strfind(name, '_');
    if length(indx)<3
        continue
    end
    sessionId = name(indx(1)+1:indx(4)-1);
    task = name(1:indx(1)-1);
    channel = name(indx(4)+1:end);
    
    [Results]=TBT_EMG(sessionId, inMaskFile,inDatFile,outDir);
    %Normalize and delete first and last
%     if ~strcmp(cond,'Countdown1') && ~strcmp(cond,'Countdown2')
%         Results(1:2)=[];Results(end)=[];
% %         Results=Results-mean(Results(1:8));
%     end
    %Save into Variable
    found = 0;
    for j=1:length(emgResults)
        if strcmp(emgResults(j).sessionId, sessionId)
            sessInd=j;
            found=1;
            break;
        end
    end
    if ~found
        sessCount = sessCount+1;
        sessInd = sessCount;
    end
    emgResults(sessInd).sessionId = sessionId;

    switch(task)
        case 'AS'
            taskName = 'MainStory';
        case 'ASb1'
            taskName = 'FirstBaseline';
            
        case 'ASb2'
            taskName = 'SecondBaseline';
            
        case 'ASrn'
            taskName = 'RatingNegative';
            
        case 'ASrp'
            taskName = 'RatingPositive';
    end
    
    switch(channel)
        case 'ZYG'
            channelName = 'EMG_ZYG';
            
        case 'Corr'
            channelName = 'EMG_Corr';
            
        case 'Orb'
            channelName = 'EMG_Orb';
            
    end
    
    emgResults(sessInd).(taskName).(channelName) = Results;
end

%% Save
if updateflag && ~NoNewFlag
%     AllEMGResults.(cond)=[OldAllEMGResults.AllEMGResults.(cond) ; AllEMGResults.(cond)];
    emgResults=[OldEMGResults.emgResults emgResults];
end
if ~NoNewFlag %Save only if there are new sessions to add
    fprintf('Saving results to %s... \n',outDir);
    save([outDir 'emgResults'],'emgResults');
%     save([outDir 'AllEMGResults'],'AllEMGResults');
end

% the same procedure on Galia's data

% SMCleanedEMG=[];
% SM_files_names = {'introData_SM_', 'mainStoriesData_SM_', 'mainStoryFullData_SM_'}
% tasks = {'Intro', 'MainStory', 'mainStoryFull'}
% channelSuff={'ZYG', 'Corr'};
% channels = {'EMG_ZYG', 'EMG_Corr'};
% 
% for j=1:length(SM_files_names)
%     filePref = SM_files_names{j};
%     task = tasks{j};
%     for c=1:length(channels)
%         channel = channels{c};
%         suffix = channelSuff{c};
%         SMDATFileName =  [inDir filePref suffix '.DAT'];
%         SMMaskFileName =  [inDir filePref suffix '.MASK'];
%         [Results]=TBT_EMG('SM', SMMaskFileName,SMDATFileName,outDir);
%         SMCleanedEMG.(task).(channel) = Results;
%     end
% end
% 
% save([outDir 'SMCleanedEMG'],'SMCleanedEMG');    
    
