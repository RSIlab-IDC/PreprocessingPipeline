function createDATMASK_Pic()
% function createDATMASK%
% INPUT: Complete Data Structure from "Create_PicData"
%
% this function reads in the the data structure, concatenates them,
% extracts EMG Channels and TTLs and organizes them into a DAT and MASK
% files for further analysis.
%

%Adjust Current Folder


homeDir = GetASBasePath();
% load the data structure
fileName = [GetASBasePath(),'\Matlab\data\ASRawData3D.mat'];
load(fileName,'-mat')
data = ASRawData;

origDestDir=[homeDir, '\Matlab\data\PreProcessedData\EMG_3D\Sorted'];
% origDestDir = 'C:\Users\eran.shor\Desktop\EMG-PCP';
cleanedDestDir=[homeDir, '\Matlab\data\PreProcessedData\EMG_3D\Cleaned'];

taskChannels = {};
taskChannels{1} = 'EMG_ZYG';
taskChannels{2} = 'EMG_Corr';
taskChannels{3} = 'EMG_Orb';
taskChannelsNames = {};
taskChannelsNames{1} = 'ZYG';
taskChannelsNames{2} = 'Corr';
taskChannelsNames{3} = 'Orb';

tasks = {};
tasks{1} = 'MainStory';
tasks{2} = 'FirstBaseline';
tasks{3} = 'SecondBaseline';
tasks{4} = 'RatingNegative';
tasks{5} = 'RatingPositive';

tasksNames = {};
tasksNames{1} = 'AS';
tasksNames{2} = 'ASb1';
tasksNames{3} = 'ASb2';
tasksNames{4} = 'ASrn';
tasksNames{5} = 'ASrp';

for r=1:length(data)
    
    %     fprintf('Creating Zyg DAT & MASK files for session %s...\n',data(r).SubjectID)
    
    for t=1:length(tasks)
        task = tasks{t};
        taskName = tasksNames{t};
        for c=1:length(taskChannels)
            channel = taskChannels{c};
            
            channelName = taskChannelsNames{c};
            
            if isempty(data(r).(task))
                continue;
            end
            event_time=[];
            
            emgSig=data(r).(task).(channel)*1000;
            
            
            %Remove 50hz Noise
            emgSig=filt50(emgSig);
            
            ns=length(emgSig);
            
            %% emgSig
            
            % initialize DAT and MASK
            allChannelData = zeros(ns,1);
            allChannelData(:,1) = emgSig';
            
            
            % Save
            fileName = [taskName, '_',data(r).SubjectID, '_', channelName '.DAT'];
            
            fileFullName = [origDestDir '\', fileName];
            cleanedFileFullName = [cleanedDestDir '\', fileName];
            if ~logical(exist(fileFullName,'file')) && ~logical(exist(cleanedFileFullName,'file'))
                fprintf('Creating file: %s\n',fileName);
                cmd = ['save ' fileFullName  ' allChannelData -mat'];
                eval(cmd);
            end
            
            allChannelMask = ones(size(allChannelData));
            fileName = [taskName, '_',data(r).SubjectID, '_', channelName '.MASK'];
            fileFullName = [origDestDir '\', fileName];
            cleanedFileFullName = [cleanedDestDir '\', fileName];
            if ~logical(exist(fileFullName,'file')) && ~logical(exist(cleanedFileFullName,'file'))
                fprintf('Creating file: %s\n',fileName);
                cmd = ['save ' fileFullName ' allChannelMask -mat'];
                eval(cmd);
            end
            
            
            
            cd(origDestDir);
            %% create and save _CFG file
            fileName = [taskName, '_',data(r).SubjectID, '_', channelName '_CFG'];
            fileFullName = [origDestDir '\', fileName];
            cleanedFileFullName = [cleanedDestDir '\', fileName '.m'];
            NChan = 1;
            NSamp = fix(size(allChannelData,1));
            NEvent = 0;
            rawVersion = [];
            timeStamp = [];
            EventCodes = [68 73 78 49;
                68 73 78 50;
                68 73 78 51];
            Samp_Rate = 1000;
            gain = [];
            bits = [];
            range = [];
            scale = [];
            msg='rawVersion,timeStamp,EventCodes,Samp_Rate,NChan,gain,bits,range,scale,NSamp,NEvent,thisMsg';
            
            if ~logical(exist(fileName,'file'))  && ~logical(exist(cleanedFileFullName,'file'))
                fprintf('Saving config data in Matlab-format %s ...\n',fileName);
                asave(fileName,rawVersion,timeStamp,EventCodes,Samp_Rate,NChan,gain,bits,range,scale,NSamp,NEvent,msg);
            end
            
        end
    end
    
end

fileName = [GetASBasePath(),'\Matlab\data\SM_Data.mat'];
load(fileName,'-mat')

taskChannels = {};
taskChannels{1} = 'EMG_ZYG';
taskChannels{2} = 'EMG_Corr';

taskChannelsNames = {};
taskChannelsNames{1} = 'ZYG';
taskChannelsNames{2} = 'Corr';

tasks = {};
tasks{1} = 'mainStoriesData';
tasks{2} = 'introData';
tasks{3} = 'mainStoryFullData';

for t=1:length(tasks)
    task = tasks{t};
    taskName = tasks{t};
    for c=1:length(taskChannels)
        channel = taskChannels{c};
        channelName = taskChannelsNames{c};
        
        event_time=[];
        
        emgSig=SM_Data.(task).(channel)*1000;
        
        
        %Remove 50hz Noise
        emgSig=filt50(emgSig);
        
        ns=length(emgSig);
        
        %% emgSig
        
        % initialize DAT and MASK
        allChannelData = zeros(ns,1);
        allChannelData(:,1) = emgSig';
        
        
        % Save
        fileName = [taskName, '_SM_', channelName '.DAT'];
        
        fileFullName = [origDestDir '\', fileName];
        cleanedFileFullName = [cleanedDestDir '\', fileName];
        if ~logical(exist(fileFullName,'file')) && ~logical(exist(cleanedFileFullName,'file'))
            fprintf('Creating file: %s\n',fileName);
            cmd = ['save ' fileFullName  ' allChannelData -mat'];
            eval(cmd);
        end
        
        allChannelMask = ones(size(allChannelData));
        fileName = [taskName, '_SM_', channelName '.MASK'];
        fileFullName = [origDestDir '\', fileName];
        cleanedFileFullName = [cleanedDestDir '\', fileName];
        if ~logical(exist(fileFullName,'file')) && ~logical(exist(cleanedFileFullName,'file'))
            fprintf('Creating file: %s\n',fileName);
            cmd = ['save ' fileFullName ' allChannelMask -mat'];
            eval(cmd);
        end
        
        
        
        cd(origDestDir);
        %% create and save _CFG file
        fileName = [taskName, '_SM_', channelName '_CFG'];
        fileFullName = [origDestDir '\', fileName];
        cleanedFileFullName = [cleanedDestDir '\', fileName '.m'];
        NChan = 1;
        NSamp = fix(size(allChannelData,1));
        NEvent = 0;
        rawVersion = [];
        timeStamp = [];
        EventCodes = [68 73 78 49;
            68 73 78 50;
            68 73 78 51];
        Samp_Rate = 1000;
        gain = [];
        bits = [];
        range = [];
        scale = [];
        msg='rawVersion,timeStamp,EventCodes,Samp_Rate,NChan,gain,bits,range,scale,NSamp,NEvent,thisMsg';
        
        if ~logical(exist(fileName,'file'))  && ~logical(exist(cleanedFileFullName,'file'))
            fprintf('Saving config data in Matlab-format %s ...\n',fileName);
            asave(fileName,rawVersion,timeStamp,EventCodes,Samp_Rate,NChan,gain,bits,range,scale,NSamp,NEvent,msg);
        end
        
    end
end

end