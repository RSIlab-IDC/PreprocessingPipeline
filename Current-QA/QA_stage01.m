%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Details:
% Name:     Pipeline_Stage01.m
% Authors:  Matan Sheskin
% Date:     October 29th, 2019
% Function: MAKE THE WORLD BETTER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Clearing workspace, logging, setting paths, organizing folders
% clear;

% Name of person running the code
NAME = 'Matan';
% NAME = input('Please enter your name: ','s');

% Write experiment Name

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE: 01-10-20
% I want to start everything from the beginning
EXPERIMENT_NAME = 'SOF-QA';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXPERIMENT_NAME = input('Please enter your experiment: ','s');

% Main folder names, according to levels
FOLDER0NAME = 'RAWDATA_Inserted';
FOLDER1NAME = 'Participants_Tasks_Channels';
FOLDER2NAME = 'Measurement';

% eid structure will hold important logs about the experiment
try
    load('eid.mat')
catch
    eid = {};
    eid.name = EXPERIMENT_NAME;
    eid.created = nowFunction();
    eid.modified = nowFunction();
    eid.stage = 0;
    % Define channels
    eid.labels = {'EMG_Zyg_1',...
        'RSP_1',...
        'Analog input',...
        'RSP_2',...
        'EMG_Zyg_2',...
        'EMG_Corr_1',...
        'ECG_1',...
        'EDA_1',...
        'ECG_2',...
        'EDA_2',...
        'EMG_ORB',...
        'Digital input1',...
        'Digital input2',...
        'Digital input3',...
        'Digital input4',...
        'HR_1',...
        'HR_2',...
        'EMG RMS Zyg 1',...
        'EMG RMS Corr 1',...
        'EMG RMS Zyg 2',...
        'EMG RMS Corr 2'};
    % Define channels to be presented
    eid.channels = {'Digital input1',... 
                        'EMG_Zyg_1',...
                        'RSP_1',...
                        'EMG_Corr_1',...
                        'ECG_1',...
                        'EDA_1',...
                        'EMG_ORB'};
    % Define channels to be cleaned:
    % 1st cell: EMG
    % 2nd cell: ECG
    % 3rd cell: EDA
    eid.toClean = {{'EMG_Zyg_1',...
                    'EMG_Corr_1',...
                    'EMG_ORB'},...
                    {'ECG_1'},...
                    {'EDA_1'}};
    eid.mids = {'1'};
    eid.ParticipantsNum = 0;
    eid.ParticipantsMax = 100;
end

% experimentLog is a table for all the data transactions in the scripts
MEASUREMENTLOGINIT = {};
MEASUREMENTLOGINIT.eid = EXPERIMENT_NAME;
MEASUREMENTLOGINIT.mid = 'Init';
MEASUREMENTLOGINIT.pid = 'Init';
MEASUREMENTLOGINIT.pnum = 'Init';
MEASUREMENTLOGINIT.tid = 'Init';
MEASUREMENTLOGINIT.conditionid = 'Init';
MEASUREMENTLOGINIT.created = nowFunction();
MEASUREMENTLOGINIT.stage = 0;
MEASUREMENTLOGINIT.allchannels = {};
MEASUREMENTLOGINIT.channels = {};
MEASUREMENTLOGINIT.channelsConfirmed = {};
MEASUREMENTLOGINIT.midLocation = 'Init';
MEASUREMENTLOGINIT.RawMeasurementLocation = 'Init';
MEASUREMENTLOGINIT.ToCleanChannelLocation = 'Init';
MEASUREMENTLOGINIT.TrimmedChannelLocation = 'Init';
MEASUREMENTLOGINIT.modified = 0;
MEASUREMENTLOGINIT.preregistered = 0;
MEASUREMENTLOGINIT.registered = 0;
MEASUREMENTLOGINIT.downsampled = 0;
CURRMEASUREMENTLOG = struct2table(MEASUREMENTLOGINIT,'AsArray',true);

% CURRLOG will hold important information about changes to scripts
CURRLOG = {};
CURRLOG.name = NAME;
CURRLOG.experiment = EXPERIMENT_NAME;
CURRLOG.time = nowFunction();
CURRCHANGELOG = struct2table(CURRLOG);

% Setting paths

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE: 01-10-20
% temp settings
tempPath = ':\playingGround\EXP-QA';
usualPath = ':\Dropbox\Experiments\SelfOtherFocus_Yair';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE: 01-10-20
% This entire section relates to folders that need to be made ready
% manually and in advance. Also, there is a very crude way of handling path
% problems. This is not good at all.
dropboxPath = tempPath;
pathOptionD = strcat('D',dropboxPath);
pathOptionZ = strcat('Z',dropboxPath);
if ~exist(pathOptionZ,'dir')
    EXPERIMENTS_PATH = strcat(pathOptionD,'\Pipeline');
    RAW_PATH = strcat(pathOptionD,'\rawdata_start');
    RATINGS_PATH = strcat(pathOptionD,'\ratings_start');
else
    EXPERIMENTS_PATH = strcat(pathOptionZ,'\Pipeline');
    RAW_PATH = strcat(pathOptionZ,'\rawdata_start');
    RATINGS_PATH = strcat(pathOptionZ,'\ratings_start');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Checking folder situation in experiments path
cd(EXPERIMENTS_PATH);
[~, msg1, ~] = mkdir(EXPERIMENT_NAME);
MAINFOLDERPATH = strcat(EXPERIMENTS_PATH,'\',EXPERIMENT_NAME);
cd(MAINFOLDERPATH);
if isempty(msg1)
    mkdir(FOLDER0NAME);
    mkdir(FOLDER1NAME);
    mkdir(FOLDER2NAME);
    CHANGELOG = CURRCHANGELOG;
    MEASUREMENTLOG = CURRMEASUREMENTLOG;
    save('CHANGELOG','CHANGELOG');
    save('MEASUREMENTLOG','MEASUREMENTLOG');
    save('eid','eid');
else
    load('eid');
    eid.modified = nowFunction();
    load('CHANGELOG');
    CHANGELOG = [CHANGELOG;CURRCHANGELOG];
    save('CHANGELOG','CHANGELOG');
    load('MEASUREMENTLOG');
end

% Remember you have eid, CHANGELOG, and EXPERIMENTLOG loaded here.

% Setting folder path for future references
FOLDEREXPMAIN = strcat(EXPERIMENTS_PATH,'\',EXPERIMENT_NAME);
PARTICIPANTFOLDERPATH = strcat(EXPERIMENTS_PATH,'\',EXPERIMENT_NAME,'\',FOLDER1NAME);
MEASUREMENTFOLDERPATH = strcat(EXPERIMENTS_PATH,'\',EXPERIMENT_NAME,'\',FOLDER2NAME);
ANALYSISRAWFOLDERPATH = strcat(EXPERIMENTS_PATH,'\',EXPERIMENT_NAME,'\',FOLDER0NAME);

%% Recognizing .mat files in RAW_PATH
cd(RAW_PATH); 

% returns file listing in main folder
listing = dir;

% Getting a list of .mat files from RAW_PATH folder path
listingTable = struct2table(listing);
listingTable.mat = zeros(size(listingTable,1),1);

% Here we are searching for the .mat files
for i = 1:size(listingTable,1)
    if endsWith(listingTable.name(i),'.mat')                               
        listingTable.mat(i) = 1;
    end
end

matFiles = listingTable(listingTable.mat == 1,:);

% Sanity check
PARAM = size(matFiles);
if PARAM(1) == 0 
    error('No matlab files.');
end

%% Looping over matFiles and adding suitable folders for measurement files
flagLoadMEASUREMENTLOG = 0;
flagMEASURELOGDef = 0;

% Creating a temp elog struct
VARIABLENUMS1 = 20;
MEASUREMENTLOGINIT = cell2table(cell(1,VARIABLENUMS1), ...
    'VariableNames', ...
    {'eid',...
    'pid',...
    'mid',...
    'pnum',...
    'tid',...
    'conditionid',...
    'created',...
    'stage',...
    'allchannels',...
    'channels',...
    'channelsConfirmed',...
    'triggers',...
    'midLocation',...
    'RawMeasurementLocation',...
    'ToCleanChannelLocation',...
    'TrimmedChannelLocation',...
    'modified',...
    'preregistered',...
    'registered',...
    'downsampled'});

FIRSTPROCESSEDFILEFLAG = 1;

% Setting flag for breaking
FLAGBREAK = 0;
    
for i=1:size(matFiles,1)

    if FLAGBREAK
        break
    end
    
    % Setting flag for trigger problems
    NOTRIGGERSFLAG = 0;
    
    MEASUREMENTLOGTEMP = MEASUREMENTLOGINIT;

    % This Flag will be used to check whether all files were handled
    Flag = 0;
    
    cd(RAW_PATH);
    filename = char(matFiles.name(i));
    pathToCopyRaw = strcat(RAW_PATH,'\',filename);
        
    load(filename);
    
    cd(ANALYSISRAWFOLDERPATH);
    if isfile(filename)
        disp(filename);
        disp("File version already exists in analysis folder")
        continue
    else
        Flag=1;
    end
    
    
    % Deleting the file signature '.mat'
    FILEHEADER = '.mat';
    measurementName = filename(1:end-length(FILEHEADER));
    [sectionEndIdx1,debut,fin] = regexp(measurementName, '_', 'match','start','end');
    index1 = debut(1)-1;
    index2 = debut(1)+1;
    index3 = debut(2)-1;
    index4 = debut(2)+1;
    STARTINDEX = 1;
    ENDINDEX = length(measurementName);
    taskName = extractBetween(measurementName,STARTINDEX,index1);
    conditionCell = extractBetween(measurementName,index2,index3);
    conditionName = conditionCell{1};
    participantNumCell = extractBetween(measurementName,index4,ENDINDEX);
    participantNum = participantNumCell{1};
    participantNameCell = extractBetween(measurementName,index2,ENDINDEX);
    participantName = participantNameCell{1};
    
    cd(MEASUREMENTFOLDERPATH);

    % Creating levels in measurement level folder
    [~, msg2, ~] = mkdir(measurementName);
    if ~isempty(msg2)
        disp("File version already exists in Measurement folder")
    end
    
    measurementFolder = strcat(MEASUREMENTFOLDERPATH,'\',measurementName);

    % Creating mid
    mid = {};
    mid.eid = EXPERIMENT_NAME;
    mid.id = measurementName;
    mid.created = nowFunction();
    mid.modified = nowFunction();
    mid.stage = 1;  
    mid.midLocation = measurementFolder;
    mid.rowMEASUREMENTLOG = i;
    mid.triggers = [];
    mid.channelsOrig = {};
    mid.channelsExp = eid.labels;
    mid.channelsSelected = eid.channels;
    mid.channelsRegis = {};
    mid.channelsCert = {};

    % Going up one level in folders
    cd(measurementFolder)
    save('mid','mid');
    
    mkdir('DataRaw');
    rawFolder = strcat(measurementFolder,'\','DataRaw');
    cd(rawFolder);
    
    % Organizing labels;
    labelsCell = cellstr(labels);
    VARIABLENUMS1 = size(labelsCell,1);
   
    MAINTRIGGER1 = -1;
    m=1; 
    % There is one channel that returns more than once as a label.
    % Its name is: 'Digital input'.
    % Also, we fix the ORB channel
    triggerChannelsIndices = [];
    for j=1:VARIABLENUMS1
        pad = int2str(m);
        if strcmp(labelsCell(j),'Digital input')
            labelsCell(j) = cellstr(strcat('Digital input',pad));
            
            if m==1
                MAINTRIGGER1 = j;
            end
                 
            triggerChannelsIndices = [triggerChannelsIndices j];
            m = m+1;
        elseif contains(labelsCell(j),'orb') || contains(labelsCell(j),'oryb')
            labelsCell(j) = cellstr('EMG_ORB');
        end
    end
    labelsCell = transpose(labelsCell);
    
    mid.channelsOrig = labelsCell;
    
    % Spotting and saving the relevent channels, via taking their indices
    labelsCellIndices = zeros(size(eid.channels,2),1);
    for l2=1:size(eid.channels,2)
        for l1=1:size(labelsCell,2)
            %disp(eid.channels{l2});
            %disp(labelsCell{l1});
            if strcmp(eid.channels{l2},labelsCell{l1})
                labelsCellIndices(l2) = l1;
                break
            end
        end
    end
    VARIABLENUMS2 = length(labelsCellIndices);
    
%     Finding triggers in each of the trigger channels

%     triggerData = data(:,triggerChannelsIndices);
%     [uniqueTriggerValues,ia1] = unique(triggerData);
%     Y = diff(triggerData,1,1);
%     [uniqueDiffValues,ia2] = unique(Y);
%     ia2 = ia2 + 1;
%     iaFinished = [];
%     for val=1:length(ia2)
%         if ia2(val) ~= 2
%             iaFinished = [iaFinished ia2(val)];
%         end
%     end
%     triggerSpots = iaFinished;
%     if length(triggerSpots) ~= 2
%         disp('Trigger channels: 2 triggers not found. Error unless baseline');
%         triggerSpots = [-1 -1];
%     end

%     Finding triggers in the trigger channel

    triggerData = data(:,MAINTRIGGER1);
    [uniqueTriggerValues,ia1] = unique(triggerData);
    Y = diff(triggerData,1,1);
    [uniqueDiffValues,ia2] = unique(Y);
    ia2 = ia2 + 1;
    iaFinished = [];
    for val=1:length(ia2)
        if ia2(val) ~= 2
            iaFinished = [iaFinished ia2(val)];
        end
    end
    triggerSpots = iaFinished;
    if length(triggerSpots) ~= 2
        disp('Trigger channels: 2 triggers not found. Error unless baseline');
        triggerSpots = [-1 -1];
    end
    
    mid.triggers = sort(triggerSpots);
    
    % Changing columns name in array via translation to table
    dataTableRaw = array2table(data,'VariableNames',eid.labels);
    
    % Saving the data to dataRawNotTrimmed
    dataRawNotTrimmed = {};
    dataRawNotTrimmed.triggerIndices = triggerChannelsIndices;
    dataRawNotTrimmed.triggerSpots = mid.triggers;
    dataRawNotTrimmed.downsampled = 0;
    dataRawNotTrimmed.mid = measurementName;
    dataRawNotTrimmed.table = dataTableRaw;
    dataRawNotTrimmed.rankingChannels = dataTableRaw(:,labelsCellIndices);
    dataRawNotTrimmed.tableRank1 = dataTableRaw(:,1:floor((size(dataTableRaw,2)/2)));
    dataRawNotTrimmed.tableRank2 = dataTableRaw(:,((floor(size(dataTableRaw,2)/2)+1):(size(dataTableRaw,2))));
    dataRawNotTrimmed.created = nowFunction();
    dataRawNotTrimmed.isi = isi;
    dataRawNotTrimmed.unitsBeforeDS = units;
    dataRawNotTrimmed.isi_units = isi_units;
    save('dataRawNotTrimmed','dataRawNotTrimmed');
        
    % Updating exprimentLogTemp; via mid
    MEASUREMENTLOGTEMP.eid{1} = mid.eid;
    MEASUREMENTLOGTEMP.pid{1} = participantName;
    MEASUREMENTLOGTEMP.mid{1} = measurementName;
    MEASUREMENTLOGTEMP.pnum{1} = participantNum;
    MEASUREMENTLOGTEMP.tid{1} = taskName{1};
    MEASUREMENTLOGTEMP.conditionid{1} = conditionName;
    MEASUREMENTLOGTEMP.created{1} = mid.created;
    MEASUREMENTLOGTEMP.stage{1} = 1;
    MEASUREMENTLOGTEMP.allchannels{1} = eid.labels; 
    MEASUREMENTLOGTEMP.channels{1} = eid.channels;
    MEASUREMENTLOGTEMP.channelsConfirmed{1} = {}; 
    MEASUREMENTLOGTEMP.triggers{1} = mid.triggers;
    MEASUREMENTLOGTEMP.midLocation{1} = mid.midLocation;
    MEASUREMENTLOGTEMP.RawMeasurementLocation{1} = rawFolder;
    MEASUREMENTLOGTEMP.TrimmedChannelLocation{1} = 'Init';
    MEASUREMENTLOGTEMP.modified{1} = mid.modified;
    MEASUREMENTLOGTEMP.preregistered{1} = mid.modified;
    MEASUREMENTLOGTEMP.registered{1} = 0;
    MEASUREMENTLOGTEMP.downsampled{1} = 0;
    
    cd(measurementFolder)
    
    CURRENTSTAGE = 1;
    THRESHSCORE = 1;
    
    channelLabels = [{'mid'} eid.channels];
    CERTIFICATIONCHANNELSINIT = cell2table(cell(1,VARIABLENUMS2+1), ...
        'VariableNames', channelLabels);
    CURRCERTIFICATECHANNELS = CERTIFICATIONCHANNELSINIT; 
    
    CURRCERTIFICATECHANNELS.mid{1} = mid.id;
    
    % Showing which measurement we are in
    disp(mid.id)

    % Creating stackedfigure
    close all
    figureTable = stackedplot(figure, dataRawNotTrimmed.rankingChannels);
    mkdir('CertificateChannels');
    cd CertificateChannels
    savefig('figure rank');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % For developement:
    % If we have a lot to rank, seperate to two figures
    % figureTable1 = stackedplot(figure, dataRawNotTrimmed.tableRank1);
    % savefig('figure rank 1');  
    % figureTable2 = stackedplot(figure, dataRawNotTrimmed.tableRank2);
    % savefig('figure rank 2');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Getting input on stacked figure
    % First dividing the input into segments, so it'll fit the dialogue
    packs1 = floor(VARIABLENUMS1 / 5)+1;
    packs2 = VARIABLENUMS2;
    limit = VARIABLENUMS2;
    % Choosing the packs value, for the prompt
    packs = packs2;
    % Should be changed if we seperate to packs
    loopish = 1;
    
    % Setting flag for last case
    Flag2 = 0;
    
    while 1
        
        for j=1:loopish
            if Flag2 == 1
                break
            end
            if j==1
                prompt = mid.channelsSelected(1,j:packs);
            else
                limitIndex1 = j*packs;
                if limitIndex1 > limit
                    limitIndex1 = limit;
                    Flag2 = 1;
                end
                prompt = mid.channelsSelected(1,(j-1)*packs+1:limitIndex1);
            end
            prompt(1,j*packs+1) = cellstr('Stop_After_This');
            while 1
                dlgtitle = 'Enter grade for channel';
                definput = cell(1,packs+1);
                definput(1,:) = {'0'};
                opts.Resize = 'on';
                opts.WindowStyle = 'normal';
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % NORMAL
%                 testScores = inputdlg(prompt,dlgtitle,[1 40],definput,opts);
%                 testScores = transpose(testScores);
                % / NORMAL
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % SPECIAL FIXING
                if i==1
                    bigPATH = pwd;
                    smallPATH = "D:\playingGround\SOF2\";
                    cd(smallPATH);
                    load("INPUTS.mat");
                    cd(bigPATH);
                end
                %testScores = cell2mat(table2cell(INPUTS(i,[2,6,7,8,9,10,11])));
                testScores = cell2mat(table2cell(INPUTS(i,[2,3,4,5,6,7,8])));
                testScores = [testScores -1];
                testScores = num2cell(testScores);
                for mark=1:length(testScores)
                    testScores{mark} = num2str(testScores{mark});
                end
                %user = table2cell(INPUTS(i,15));
                user = table2cell(INPUTS(i,12));
                % / SPECIAL FIXING
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                % Making sure we get answers
                if ~isempty(testScores)
                    break;
                end
            end

            % Trnascribing the answers
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Should be different in case we want to sepearte to packs
            % due to the 'Stop_After_This' registery
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            for k=1:packs
                limitIndex2 = (j-1)*packs+k+1;
                if limitIndex2 > size(CURRCERTIFICATECHANNELS,2)
                    break
                else
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % NORMAL
                    % CURRCERTIFICATECHANNELS(1,(j-1)*packs+k+1) = testScores(k);
                    % / NORMAL
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % FIXING
                    CURRCERTIFICATECHANNELS(1,(j-1)*packs+k+1) = num2cell(testScores(k));
                    % / FIXING
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                end
            end 
            
            if strcmp(testScores(1,j*packs+1),'-999')
                FLAGBREAK = 1;
            end
            
            if max(str2double(testScores(1:4))) == -1
               NOTRIGGERSFLAG = 1;
            end
            
        end 

        % Transform text to nums
        for l=2:size(CURRCERTIFICATECHANNELS,2)
            CURRCERTIFICATECHANNELS.(l) = str2double(CURRCERTIFICATECHANNELS{:,l});
        end

        % Checking answer and signing sheet:
        % Not necessary if we have a small amount of channels to rank
        % figureTable3 = stackedplot(figure, CURRCERTIFICATECHANNELS);
         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NORMAL
%         if FIRSTPROCESSEDFILEFLAG
%             while 1
%                 prompt = {'Name','Are You Sure?'};
%                 dlgtitle = 'Signature';
%                 definput = cell(1,2);
%                 definput(1,:) = {'0'};
%                 opts.Resize = 'on';
%                 opts.WindowStyle = 'normal';
%                 confirmationPrompt = inputdlg(prompt,dlgtitle,[1 40],definput,opts);
%                 if ~isempty(confirmationPrompt)
%                     break
%                 end
%             end
%         end
% / NORMAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % FIXING
        confirmationPrompt = {string(user) "Yes"};
        % / FIXING
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if strcmp(confirmationPrompt{1},'-1')
            close all;
            error('Cats overload');
        end

        % Exiting if user is sure of his answer
        checkPrompt = lower(confirmationPrompt{2});
        checkString = lower('Yes');
        if strcmp(checkPrompt,checkString)
            FIRSTPROCESSEDFILEFLAG = 0;
            break
        else
            Flag2 = 0;
            CURRCERTIFICATECHANNELS = CERTIFICATIONCHANNELSINIT; 
            CURRCERTIFICATECHANNELS.mid{1} = mid.id;
        end     
    end
    
    res = mean(CURRCERTIFICATECHANNELS{1,2:1+VARIABLENUMS2},2);
    PASSMARK = 1;
    countPass = 0;
    indexPass = [];
    for j=2:size(CURRCERTIFICATECHANNELS,2)
        if CURRCERTIFICATECHANNELS{1,j} == PASSMARK
            countPass = countPass+1;
            indexPass = [indexPass j];
        end
    end
    CURRCERTIFICATECHANNELS.indexPass = {indexPass};
    CURRCERTIFICATECHANNELS.countPass = countPass;
    CURRCERTIFICATECHANNELS.generalScore = res;

    % Signing the report
    CURRCERTIFICATECHANNELS.user = confirmationPrompt(1);
    
    % Moving the raw file
    movefile(pathToCopyRaw,ANALYSISRAWFOLDERPATH);
    
    % Setting the correct stage for mid
    cd(MEASUREMENTLOGTEMP.midLocation{1});
    if countPass > 0
        mid.stage = CURRENTSTAGE+1;
        mid.channelsCert = 1;
    else
        mid.stage = -1;
    end
    mid.modified = nowFunction();
    
    % Taking into consideration triggers problem,
    % only in case it's not baseline
    BASELINEMARK = 'b';
    if ~contains(mid.id,BASELINEMARK)
        if min(mid.triggers) < 0 || NOTRIGGERSFLAG == 1
            mid.stage = -1;
        end
    end
    
    save('mid','mid');
    
    cd(MAINFOLDERPATH);
    
    MEASUREMENTLOGTEMP.stage{1} = mid.stage;
    MEASUREMENTLOGTEMP.modified{1} = mid.modified;
    MEASUREMENTLOGTEMP.channelsConfirmed{1} = channelLabels(indexPass);
    
    if i==1
        try
            load('MEASUREMENTLOG');
            if size(MEASUREMENTLOG,1) == 1
                flagMEASURELOGDef = 1;
            end
            MEASUREMENTLOG = [MEASUREMENTLOG; MEASUREMENTLOGTEMP];
            if flagMEASURELOGDef
                MEASUREMENTLOG(1,:) = [];
            end
        catch
            MEASUREMENTLOG = MEASUREMENTLOGTEMP;
        end
    else
        MEASUREMENTLOG = [MEASUREMENTLOG; MEASUREMENTLOGTEMP];
    end
    save('MEASUREMENTLOG','MEASUREMENTLOG');

    if i==1
        try
            load('CERTIFICATECHANNELS');
            CERTIFICATECHANNELS = [CERTIFICATECHANNELS; CURRCERTIFICATECHANNELS];
            flagLoadMEASUREMENTLOG = 1;
        catch
            CERTIFICATECHANNELS = CURRCERTIFICATECHANNELS;
        end
    else
        if flagLoadMEASUREMENTLOG == 0
            load('CERTIFICATECHANNELS');
            flagLoadMEASUREMENTLOG = 1;
        end
        CERTIFICATECHANNELS = [CERTIFICATECHANNELS; CURRCERTIFICATECHANNELS];     
    end
    save('CERTIFICATECHANNELS','CERTIFICATECHANNELS'); 

end

close all;

if Flag == 0
    error('All files were already handled');
end

% Changing eid fields
cd(MAINFOLDERPATH);
eid.modified = nowFunction();
eid.ParticipantsNum = eid.ParticipantsNum + size(matFiles,1);
eid.mids = MEASUREMENTLOG.mid;
save('eid','eid');

% Clearing all variables but important ones
clearvars -except ...
    MAINFOLDERPATH...
    RAW_PATH ...
    CHANGELOG ...
    eid ...
    EXPERIMENT_NAME ...
    EXPERIMENTS_PATH ...
    FOLDEREXPMAIN ...
    PARTICIPANTFOLDERPATH ...
    MEASUREMENTFOLDERPATH ...
    RATINGS_PATH ...
    MEASUREMENTLOG ...
    CERTIFICATECHANNELS...
    
save('01_BeforeRegistration.mat');


%% Registration: Trimming triggers
VARIABLENUMS1 = 29;
CHANNELLOGINIT = cell2table(cell(1,VARIABLENUMS1), ...
    'VariableNames', ...
    {'eid',...
    'pid',...
    'mid',...
    'pnum',...
    'tid',...
    'conditionid',...
    'channelid',...
    'cleaningID',...
    'channelindxRaw',...
    'passedManual',...
    'created',...
    'stage',...
    'channels',...
    'filterParam',...
    'cleaningAttempts',...
    'flagCheckClean',...
    'channelsConfirmed',...
    'midLocation',...
    'RawMeasurementLocation',...
    'TrimmedChannelLocation',...
    'ToCleanChannelLocation',...
    'modified',...
    'preregistered',...
    'registered'...
    'filtered'...
    'sentToClean'...
    'cleaned'...
    'cleanedCertificate',...
    'readyForAnalysis'});

CURRCHANNELLOG = CHANNELLOGINIT;
SEPERATOR = '___';

idxMEASURE = -1;
STARTPOINT = -1;
STARTMEASUREMENTLOG = 1;
for k=STARTMEASUREMENTLOG:size(MEASUREMENTLOG,1)
    if MEASUREMENTLOG.registered{k} == 0
        STARTPOINT = k;
        idxMEASURE = STARTPOINT;
        break
    end
end

for i=STARTPOINT:size(MEASUREMENTLOG,1)
    
    % Log message
    iText = num2str(i);
    mlText = num2str(size(MEASUREMENTLOG,1));
    LOGMESSAGE = strcat("Getting ready to trim triggers:, ",iText," of ",mlText);
    disp(LOGMESSAGE);
    
    if MEASUREMENTLOG.stage{i} < 0
        continue;
    elseif length(MEASUREMENTLOG.registered{i}) ~= 1
        continue;
    end
    
    CHANNELSNUM = size(MEASUREMENTLOG.channels{i},2);
    for t=1:CHANNELSNUM
        CHANNELLOGTEMP = CHANNELLOGINIT;
        CHANNELLOGTEMP.eid{1} = MEASUREMENTLOG.eid{i};
        CHANNELLOGTEMP.pid{1} = MEASUREMENTLOG.pid{i};
        CHANNELLOGTEMP.mid{1} = MEASUREMENTLOG.mid{i};
        CHANNELLOGTEMP.pnum{1} = MEASUREMENTLOG.pnum{i};
        CHANNELLOGTEMP.tid{1} = MEASUREMENTLOG.tid{i};
        CHANNELLOGTEMP.conditionid{1} = MEASUREMENTLOG.conditionid{i};
        CHANNELLOGTEMP.created{1} = nowFunction();
        CHANNELLOGTEMP.stage{1} = MEASUREMENTLOG.stage{i};
        CHANNELLOGTEMP.channels{1} = MEASUREMENTLOG.channels{i};
        CHANNELLOGTEMP.channelsConfirmed{1} = MEASUREMENTLOG.channelsConfirmed{i};
        CHANNELLOGTEMP.midLocation{1} = MEASUREMENTLOG.midLocation{i};
        CHANNELLOGTEMP.RawMeasurementLocation{1} = MEASUREMENTLOG.RawMeasurementLocation{i};
        CHANNELLOGTEMP.TrimmedChannelLocation{1} = MEASUREMENTLOG.TrimmedChannelLocation{i};
        CHANNELLOGTEMP.ToCleanChannelLocation{1} = MEASUREMENTLOG.ToCleanChannelLocation{i};
        CHANNELLOGTEMP.modified{1} = MEASUREMENTLOG.modified{i};
        CHANNELLOGTEMP.preregistered{1} = MEASUREMENTLOG.preregistered{i};
        CHANNELLOGTEMP.flagCheckClean = 0;
        CHANNELLOGTEMP.registered{1} = 0;
        CHANNELLOGTEMP.sentToClean{1} = 0;
        CHANNELLOGTEMP.filtered{1} = 0;
        CHANNELLOGTEMP.cleaningAttempts{1} = -1;
        CHANNELLOGTEMP.cleaned{1} = 0;
        CHANNELLOGTEMP.cleanedCertificate{1} = 0;
        CHANNELLOGTEMP.readyForAnalysis{1} = 0;
        CHANNELLOGTEMP.channelid{1} = MEASUREMENTLOG.channels{i}{t};  
        CHANNELLOGTEMP.cleaningID = strcat(CHANNELLOGTEMP.mid{1},SEPERATOR,CHANNELLOGTEMP.channelid{1});
        if any(strcmp(MEASUREMENTLOG.channelsConfirmed{i},MEASUREMENTLOG.channels{i}{t}))
            CHANNELLOGTEMP.passedManual{1} = 1;
        else
            CHANNELLOGTEMP.passedManual{1} = 0;
        end
        if any(strcmp(CHANNELLOGTEMP.channelid{1},eid.toClean{1}))
            CHANNELLOGTEMP.filterParam{1} = 1;
        elseif any(strcmp(CHANNELLOGTEMP.channelid{1},eid.toClean{2}))
            CHANNELLOGTEMP.filterParam{1} = 2;
        elseif any(strcmp(CHANNELLOGTEMP.channelid{1},eid.toClean{3}))
            CHANNELLOGTEMP.filterParam{1} = 3;
        else
            CHANNELLOGTEMP.filterParam{1} = -1;
        end  
        CHANNELLOGTEMP.channelindxRaw{1} = find(contains(MEASUREMENTLOG.allchannels{i},CHANNELLOGTEMP.channelid{1}));  
        CURRCHANNELLOG = [CURRCHANNELLOG; CHANNELLOGTEMP];
        idxEmpty=all(cellfun(@isempty,CURRCHANNELLOG{:,:}),2);
        CURRCHANNELLOG(idxEmpty,:)=[];
        
    end
end

cd(MAINFOLDERPATH);

try
    load('CHANNELLOG');
    CHANNELLOG = [CHANNELLOG; CURRCHANNELLOG];
catch
    CHANNELLOG = CURRCHANNELLOG;
end
save('CHANNELLOG','CHANNELLOG');

% Clearing all variables but important ones
clearvars -except ...
    MAINFOLDERPATH...
    RAW_PATH ...
    CHANGELOG ...
    eid ...
    EXPERIMENT_NAME ...
    EXPERIMENTS_PATH ...
    FOLDEREXPMAIN ...
    PARTICIPANTFOLDERPATH ...
    MEASUREMENTFOLDERPATH ...
    RATINGS_PATH ...
    MEASUREMENTLOG ...
    CERTIFICATECHANNELS...
    CHANNELLOG...
    idxMEASURE...
    SEPERATOR
    
save('02_AfterRegistration.mat');

%% Getting ready to trim

STARTPOINT = -1;
STARTLINECHANNELLOG = 1;
for k=STARTLINECHANNELLOG:size(CHANNELLOG,1)
    if CHANNELLOG.registered{k} == 0
        STARTPOINT = k;
        break
    end
end

for i=STARTPOINT:size(CHANNELLOG,1)
    
    % Log message
    iText = num2str(i);
    clText = num2str(size(CHANNELLOG,1));
    LOGMESSAGE = strcat("Trimming triggers:, ",iText," of ",clText);
    disp(LOGMESSAGE);
    
    if length(CHANNELLOG.registered{i}) ~= 1
        continue;
    end
    
    flagToClean = 0;
    if CHANNELLOG.filterParam{i} ~= -1
        flagToClean = 1;
    end
    flagRowChangeMeasurementLog = 0;
    if mod(i-STARTPOINT+1,size(eid.channels,2)) == 1
        flagRowChangeMeasurementLog = 1;
    end
    cd(PARTICIPANTFOLDERPATH);
    folderParticipant = CHANNELLOG.pid{i};
    folderTask = CHANNELLOG.tid{i};
    folderCondition = CHANNELLOG.conditionid{i};
    folderChannel = CHANNELLOG.channelid{i};
    pathFrom = CHANNELLOG.RawMeasurementLocation{i};
    if ~exist(folderParticipant, 'dir')
        mkdir(folderParticipant);
    end
    cd(folderParticipant);
    if ~exist(folderTask, 'dir')
        mkdir(folderTask);
    end
    cd(folderTask);
    mkdir(folderChannel);
    cd(folderChannel);
    if flagToClean == 1
        mkdir('Cleaned');
        mkdir('Cleaning_Attempts');
        mkdir('Comparison');
        mkdir('To_Clean');
        cd 'To_Clean' ;
        CHANNELLOG.ToCleanChannelLocation{i} = pwd;
        cd ..
    else
        CHANNELLOG.ToCleanChannelLocation{i} = 'DNC';
    end
    filenameToSave = strcat(CHANNELLOG.mid{i},'_',CHANNELLOG.channelid{i});
    CURRPATH = pwd;
    cd(CHANNELLOG.RawMeasurementLocation{i});
    load('dataRawNotTrimmed');
    cd(CURRPATH);
    dataRawChannel = {};
    dataRawChannel.mid = dataRawNotTrimmed.mid;
    
    % Here we cut the data according to the indices
    triggerIndices = dataRawNotTrimmed.triggerSpots;
    try
        dataRawChannel.ndsdata = dataRawNotTrimmed.table(triggerIndices(1):triggerIndices(2),CHANNELLOG.channelindxRaw{i});
    catch
        %disp('No valid triggers');
        dataRawChannel.ndsdata = dataRawNotTrimmed.table(:,CHANNELLOG.channelindxRaw{i});
    end
    dataRawChannel.passedManual = CHANNELLOG.passedManual{i};
    dataRawChannel.trimmed = 1;
    dataRawChannel.downsampled = 0;
    dataRawChannel.toClean = flagToClean;
    dataRawChannel.unitsBeforeDS = dataRawNotTrimmed.unitsBeforeDS;
    dataRawChannel.created = nowFunction();
    dataRawChannel.channelid = CHANNELLOG.channelid{i};
    
    % dataRawChannel.tableData = array2table(dataRawChannel.ndsdata,'VariableNames',{dataRawChannel.channelid});
    dataRawChannel.MatrixData = table2array(dataRawChannel.ndsdata);
    
    CHANNELLOG.registered{i} = nowFunction();
    CHANNELLOG.modified{i} = nowFunction();
    CHANNELLOG.TrimmedChannelLocation{i} = pwd;
    
    cd(MAINFOLDERPATH);
    save('CHANNELLOG','CHANNELLOG');
    
    if flagRowChangeMeasurementLog == 1
        while MEASUREMENTLOG.stage{idxMEASURE}==-1 || length(MEASUREMENTLOG.registered{idxMEASURE})>1
            idxMEASURE = idxMEASURE+1;
        end
        MEASUREMENTLOG.registered{idxMEASURE} = nowFunction();
        MEASUREMENTLOG.TrimmedChannelLocation{idxMEASURE} = pwd;
        idxMEASURE = idxMEASURE+1;
    end
    save('MEASUREMENTLOG','MEASUREMENTLOG');

    cd(CHANNELLOG.TrimmedChannelLocation{i});
    save(filenameToSave,'dataRawChannel');

end

%% Getting ready to clean: First filtering

idxMEASUREFilt = -1;
STARTPOINTFILT = -1;
STARTCHANNELLOG = 1;
for k=STARTCHANNELLOG:size(CHANNELLOG,1)
    if CHANNELLOG.filterParam{k} ~= -1
        STARTPOINTFILT = k;
        idxMEASUREFilt = STARTPOINTFILT;
        break
    end
end

for i=STARTPOINTFILT:size(CHANNELLOG,1)
    
    % Log message
    iText = num2str(i);
    clText = num2str(size(CHANNELLOG,1));
    LOGMESSAGE = strcat("Filtering:, ",iText," of ",clText);
    disp(LOGMESSAGE);
    
    if CHANNELLOG.filterParam{i}==-1 
        continue
    elseif length(CHANNELLOG.filtered{i}) ~= 1
        continue

    else
        cd(CHANNELLOG.TrimmedChannelLocation{i});
        filenameShort = strcat(CHANNELLOG.mid{i},'_',CHANNELLOG.channelid{i});
        filenameToLoad = strcat(filenameShort,'.mat');
        load(filenameToLoad);
        
        % In case we handle EMG files
        if CHANNELLOG.filterParam{i}==1
            dataRawChannel.emgSig = filt50(dataRawChannel.MatrixData);
            dataRawChannel.emgSig = 1000*dataRawChannel.emgSig;
            dataRawChannel.ns = length(dataRawChannel.emgSig);
            save(filenameToLoad,'dataRawChannel');
            
            cd(CHANNELLOG.ToCleanChannelLocation{i});
            
            allChannelData = dataRawChannel.emgSig;
            save('DATAFILE.DAT','allChannelData','-mat');

            allChannelMask = ones(dataRawChannel.ns,1);
            save('DATAFILE.MASK','allChannelMask','-mat');
            
            fileNameToSave = strcat(filenameShort, '_CFG');
            NChan = 1;
            NSamp = size(allChannelData,1);
            NEvent = 0;
            rawVersion = [];
            timeStamp = [];
            EventCodes = [];
            Samp_Rate = 1000;
            gain = [];
            bits = [];
            range = [];
            scale = [];
            msg='rawVersion,timeStamp,EventCodes,Samp_Rate,NChan,gain,bits,range,scale,NSamp,NEvent,thisMsg';
            fprintf('Saving config data in Matlab-format %s ...\n',fileNameToSave);
            asave('DATAFILE_CFG',rawVersion,timeStamp,EventCodes,Samp_Rate,NChan,gain,bits,range,scale,NSamp,NEvent,msg);
            fclose('all');
            
        % In case we handle HR files
        elseif CHANNELLOG.filterParam{i}==2
            cd(CHANNELLOG.ToCleanChannelLocation{i});
            writematrix(dataRawChannel.MatrixData,strcat('DATAFILE','.txt'));
            writematrix(dataRawChannel.MatrixData,strcat('DATAFILE','.xlsx'));
        
        % In case we handle EDA files
        else
            cd(CHANNELLOG.ToCleanChannelLocation{i});
            toSaveEDA = dataRawChannel.MatrixData;
            save('DATAFILE.mat','toSaveEDA','-mat');
            
        end
        
        CHANNELLOG.filtered{i}=nowFunction();
        % CHANNELLOG.sentToClean{i}=1;
        CHANNELLOG.cleaningAttempts{i} = 0;
        
        cd(MAINFOLDERPATH);
        save('CHANNELLOG','CHANNELLOG');
    end
end

% Clearing all variables but important ones
clearvars -except ...
    MAINFOLDERPATH...
    RAW_PATH ...
    CHANGELOG ...
    eid ...
    EXPERIMENT_NAME ...
    EXPERIMENTS_PATH ...
    FOLDEREXPMAIN ...
    PARTICIPANTFOLDERPATH ...
    MEASUREMENTFOLDERPATH ...
    RATINGS_PATH ...
    MEASUREMENTLOG ...
    CERTIFICATECHANNELS...
    CHANNELLOG...
    SEPERATOR

cd(MAINFOLDERPATH);
save('03_BeforeCleaning.mat');

%% Preparing Cleaning Folder

mkdir('Cleaning');
cd('Cleaning');

mkdir('PULL_ECG_EMG');
mkdir('PUSH_ECG_EMG');
mkdir('PULL_EDA');
mkdir('PUSH_EDA');
mkdir('Figures');

PULL_FOLDER_ECG_EMG = strcat(MAINFOLDERPATH,'\Cleaning','\PULL_ECG_EMG');
PUSH_FOLDER_ECG_EMG = strcat(MAINFOLDERPATH,'\Cleaning','\PUSH_ECG_EMG');
PULL_FOLDER_EDA = strcat(MAINFOLDERPATH,'\Cleaning','\PULL_EDA');
PUSH_FOLDER_EDA = strcat(MAINFOLDERPATH,'\Cleaning','\PUSH_EDA');
FIGURES_FOLDER = strcat(MAINFOLDERPATH,'\Cleaning','\Figures');

idxMEASUREtoClean = -1;
STARTPOINTTOCLEAN = -1;
STARTCHANNELLOG = 1;
for k=STARTCHANNELLOG:size(CHANNELLOG,1)
    if CHANNELLOG.filtered{k} ~= 0
        STARTPOINTTOCLEAN = k;
        idxMEASUREtoClean = STARTPOINTTOCLEAN;
        break
    end
end

for i=STARTPOINTTOCLEAN:size(CHANNELLOG,1)
    
    % Log message
    iText = num2str(i);
    clText = num2str(size(CHANNELLOG,1));
    LOGMESSAGE = strcat("To-Cleaning Folder:, ",iText," of ",clText);
    disp(LOGMESSAGE);
    
    if CHANNELLOG.filterParam{i}==-1 || length(CHANNELLOG.filtered{i}) == 1 
        continue
    elseif length(CHANNELLOG.sentToClean{i}) ~= 1
        continue
    elseif CHANNELLOG.flagCheckClean{i} == 2 || CHANNELLOG.flagCheckClean{i} == 1
        continue
    else
        newFolderName = strcat(CHANNELLOG.mid{i},SEPERATOR,CHANNELLOG.channelid{i});
        cd(CHANNELLOG.ToCleanChannelLocation{i});
        cd ..
        loc = pwd;
        copyfile('To_Clean',newFolderName);
        if CHANNELLOG.filterParam{i}==3 %EDA CHANNEL
            cd(PULL_FOLDER_EDA);
            folder2 = strcat(PULL_FOLDER_EDA,'\',newFolderName);
        else
            cd(PULL_FOLDER_ECG_EMG);
            folder2 = strcat(PULL_FOLDER_ECG_EMG,'\',newFolderName);
        end
        folder1 = strcat(loc,'\',newFolderName);
        movefile(folder1,folder2);
        CHANNELLOG.sentToClean{i} = nowFunction();
        CHANNELLOG.flagCheckClean{i} = 1;
        
        cd(MAINFOLDERPATH);
        save('CHANNELLOG','CHANNELLOG');
    end
end
        
% Clearing all variables but important ones
clearvars -except ...
    MAINFOLDERPATH...
    RAW_PATH ...
    CHANGELOG ...
    eid ...
    EXPERIMENT_NAME ...
    EXPERIMENTS_PATH ...
    FOLDEREXPMAIN ...
    PARTICIPANTFOLDERPATH ...
    MEASUREMENTFOLDERPATH ...
    RATINGS_PATH ...
    MEASUREMENTLOG ...
    CERTIFICATECHANNELS...
    CHANNELLOG...
    PUSH_FOLDER_ECG_EMG...
    PULL_FOLDER_ECG_EMG...
    PUSH_EDA...
    PULL_EDA...
    SEPERATOR...
    FIGURES_FOLDER

cd(MAINFOLDERPATH);
save('04_CleaningFolderCreation.mat');
%% Functions

function Signal=filt50(input)
Fs=1000;
d=designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',49,'HalfPowerFrequency2',51, ...
               'DesignMethod','butter','SampleRate',Fs);
%Visualize Filter's effect
%fvtool(d,'Fs',Fs)
Signal = filtfilt(d,input);
end

function err = asave(fileName, varargin)

% function err = asave(fileName, varargin)
%
% This function saves multiple variables in an ASCII (human editable)
% file that can be read by 'aload()'. It is useful for cases where
% the built-in Matlab functions 'load' and 'save' need to be used to
% save multiple variables within a single text file.
%
% fileName is the name of a text file to open for write.
% varargin is the variable-length list of variables to be saved.
%
% Example:
%
% err = asave('asciiDataFile', a2DArray, aString, aScalar);
% ...
% [other2DArray, otherString, otherScalar] = aload('asciiDataFile');
%
% NOTE: The actual filename used is "fileName.m"

err = 0;

fid = fopen([fileName '.m'], 'w');
if fid > 1
	for i = 1:nargin-1
		err = asave1(fid, i, varargin{i});
	end
	fclose(fid);
else
	err = 1;
end

end

function err = asave1(fid, varNum, varValue)

% function err = asave1(fid, varNum, varValue)
%
% This function saves a single variable in an ASCII (human editable)
% file that can be read by 'aload1()'. It is useful for cases where
% the built-in Matlab functions 'load' and 'save' need to be used to
% save multiple variables within a single text file.
%
% fid is the file id of a text file already open for write.
% varNum is the number of the variable within the file.
% varValue is the actual matrix (or string) to be saved.
%
% modified 25-Jan-2006 to write all values to greater precision
% long Biopac corrugator files have seven digit NSamp so that
% default g format results in round off error
% changed to '%0.15g\t'

err = 0;

% Set up a string with a single quote in it.
sq = '''';

fprintf(fid, 'v%d = [\n', varNum);

% First, get the dimensions of the matrix.

[nRows, nCols] = size(varValue);

% Next, find out if varValue is a string or numeric matrix.
if ischar(varValue) == 1
    cmd = sprintf('%s%%%d.%ds%s\\n', sq, nCols, nCols, sq);
    for k = 1:nRows
        fprintf(fid, cmd, varValue(k,:));
    end
else
    for k = 1:nRows
        fprintf(fid, '%0.15g\t', varValue(k,:));
        fprintf(fid, '\n');
    end
end
fprintf(fid, '];\n');
end

function time = nowFunction()
d = datetime('now');
time = datestr(d);
end

% function run_EDA(vec)
% % Remark: Does not work on post MATLAB 2014!
% samplerate=1000;
% %Create Data Struct
% data.conductance=transpose(vec);
% data.time=(1:length(vec))/samplerate;
% data.timeoff=0;
% data.event=[];
% %Save
% filename=sprintf('EDAResults.mat');
% % Trying different saving format, but nothing works with the
% % new MATLAB versions
% save(filename, 'data','-ascii','-double');
% %Run Ledalab Software
% pathname=pwd;
% Ledalab(pathname,'open','text','analyze','CDA')
% end