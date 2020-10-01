%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Details:
% Name:     Pipeline_Stage02.m
% Authors:  Matan Sheskin
% Date:     January 2nd, 2020
% Function: MAKE THE WORLD BETTER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% First, load the necessary files
load('041_makingTable.mat');
load('CHANNELLOG.mat');

%% Check cleaning attempts with EDA folder

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO: Add care with the PUSH_FOLDER_EDA folder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Then, check cleaning attempts with ECG_EMG folder

disp("Creating MatFiles table");

cd(PUSH_FOLDER_ECG_EMG);

% returns file listing in pull folder
listing = dir;

% Getting a list of .mat files from RAW_PATH folder path
listingTable = struct2table(listing);

% Delete unnecessary first two lines
listingTable([1,2],:) = [];

% Here we are searching for non empty folders
listingTable.notEmpty = zeros(size(listingTable,1),1);
loc = pwd;
for t = 1:size(listingTable,1)
    cd([loc '\' listingTable.name{t}]);
    if length(dir) > 2
        listingTable.notEmpty(t) = 0;
    else
        listingTable.notEmpty(t) = 1;
    end
end

% Extract only table rows that represent not-empty folders
CLEANINGATTEMPTS = listingTable(listingTable.notEmpty == 0,:);

% Extract mid and channelid
CLEANINGATTEMPTS.mid = cell(size(CLEANINGATTEMPTS,1),1);
CLEANINGATTEMPTS.channelid = cell(size(CLEANINGATTEMPTS,1),1);
for j=1:size(CLEANINGATTEMPTS,1)
    nameToSplit = CLEANINGATTEMPTS.name{j};
    match = strsplit(nameToSplit,SEPERATOR);
    CLEANINGATTEMPTS.mid{j} = match(1);
    CLEANINGATTEMPTS.channelid{j} = match(2);
end

CLEANINGATTEMPTS.channellogid = cell(size(CLEANINGATTEMPTS,1),1);
for t=1:size(CLEANINGATTEMPTS,1)
    for j=1:size(CHANNELLOG,1)
        if strcmp(CLEANINGATTEMPTS.name{t},CHANNELLOG.cleaningID{j})
            CLEANINGATTEMPTS.channellogid{t} = j;
        end
    end
end

% Sanity Check
if size(CLEANINGATTEMPTS,1) == 0
    error('No Cleaning Files')
end

d = datetime('now');
DateString = datestr(d);
envSave = ['05_Cleaning' SEPERATOR 'save1of3_' DateString '.mat'];
envSave = strrep(envSave,':','_');
cd(MAINFOLDERPATH);
save(envSave);

%% Matching tables

disp("Matching Tables of MatFiles and CHANNELLOG");

% Match CLEANINGATTEMPTS table with CHANNELLOG
for k=1:size(CLEANINGATTEMPTS,1)
   for l=1:size(CHANNELLOG,1)
      if strcmp(CHANNELLOG.cleaningID{l},CLEANINGATTEMPTS.name{k})
          CHANNELLOG.cleaningAttempts{l} = CHANNELLOG.cleaningAttempts{l}+1;
          cd(CHANNELLOG.ToCleanChannelLocation{l});
          cd ..
          loc1 = pwd;
          
          PUSHTOLOC = [loc1 '\Cleaning_Attempts'];
          
          oldFolderLOC = [PUSH_FOLDER_ECG_EMG '\' CHANNELLOG.cleaningID{l}];
          
          tempFolderName = 'FolderToCopy';
          cd(oldFolderLOC);
          cd ..
          loc2 = pwd;
          copyfile(oldFolderLOC,tempFolderName);
          cd(PUSHTOLOC);
          newFolderName2 = num2str(CHANNELLOG.cleaningAttempts{l});

          folder1 = [loc2 '\' tempFolderName];
          folder2 = [PUSHTOLOC '\' newFolderName2];
          movefile(folder1,folder2);
          
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          % MISTAKE ?
          
%           cd(oldFolderLOC);
%           cd ..
%           
%           try
%                 rmdir(CHANNELLOG.cleaningID{l},'s');
%           catch
%                 pathFrom = strcat(PUSH_FOLDER_ECG_EMG,'\',CHANNELLOG.cleaningID{l});
%                 cd ..
%                 cd('RecyclePush');
%                 movefile(pathFrom,pwd);
%           end
%           
%           mkdir(CHANNELLOG.cleaningID{l});
%           cd(CHANNELLOG.cleaningID{l});
%           writematrix([1 1], 'SentToClean.txt');
%           CHANNELLOG.flagCheckClean{l} = 1;

           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           % Maybe this ?
           CHANNELLOG.flagCheckClean{l} = 1;
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

      end
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
    FOLDEREXPMAIN...
    CHANNELLOG...
    PUSH_FOLDER_ECG_EMG...
    PULL_FOLDER_ECG_EMG...
    SEPERATOR...
    CLEANINGATTEMPTS

d = datetime('now');
DateString = datestr(d);
envSave = ['05_Cleaning' SEPERATOR 'save2of3_' DateString '.mat'];
envSave = strrep(envSave,':','_');
cd(MAINFOLDERPATH);
save(envSave);

%% Now check if the cleaning attempt was alright

disp("Checking cleaning attempt");

MARKS = {-1,2,3};

for t=1:size(CLEANINGATTEMPTS,1)
    transitionInd = CLEANINGATTEMPTS.channellogid{t};
    if CHANNELLOG.flagCheckClean{transitionInd} == 0
        continue
    elseif CHANNELLOG.flagCheckClean{transitionInd} == 2
        continue
    else
        cd(CHANNELLOG.ToCleanChannelLocation{transitionInd});
        cd ..
        loc3 = pwd;
        cd('Comparison');
        foldername = num2str(CHANNELLOG.cleaningAttempts{transitionInd});
        mkdir(foldername);
        loc4 = pwd;
        TOCOPYBEFOREFILELOC = CHANNELLOG.ToCleanChannelLocation{transitionInd};
        TOCOPYAFTERFILELOC = [loc3 '\Cleaning_Attempts\' num2str(CHANNELLOG.cleaningAttempts{transitionInd})];   
        cd(TOCOPYBEFOREFILELOC);
        
        givenCase = -1;
        if isfile('DATAFILE.DAT')
            givenCase = 1;
        elseif isfile('DATAFILE.xlsx')
            givenCase = 2;
        else
            % EDA went to another folder so maybe cancel this?
            disp('Did you get here?');
            error('You should not get here');
        end
        
        if givenCase == -1
            error('Cleaning case does not match the three cases');
        end
        
        cd([loc4 '\' foldername]);
        
        if givenCase == 1
            CHANNELNAME = 'EMG';
            copyfile([TOCOPYBEFOREFILELOC '\DATAFILE.DAT'],pwd);
            movefile('DATAFILE.DAT','Before_DATAFILE.mat');
            copyfile([TOCOPYBEFOREFILELOC '\DATAFILE.MASK'],pwd);
            movefile('DATAFILE.MASK','Before_MASKFILE.mat');
            dataBefore = TBT_EMG('Before_MASKFILE.mat','Before_DATAFILE.mat');
            dataBefore = transpose(dataBefore);
            
            copyfile([TOCOPYAFTERFILELOC '\DATAFILE.DAT'],pwd);
            movefile('DATAFILE.DAT','After_DATAFILE.mat');
            copyfile([TOCOPYAFTERFILELOC '\DATAFILE.MASK'],pwd);
            movefile('DATAFILE.MASK','After_MASKFILE.mat');
            dataAfter = TBT_EMG('After_MASKFILE.mat','After_DATAFILE.mat');
            dataAfter = transpose(dataAfter);
            
            headBefore = [CHANNELNAME 'BeforeClean'];
            headAfter = [CHANNELNAME 'AfterClean'];
            
            if size(dataAfter,1)==size(dataBefore,2)
                data = [dataBefore dataAfter];
            elseif size(dataAfter,1)<size(dataBefore,2)
                padFactor = size(dataBefore,1)-size(dataAfter,1);
                biggerData = [zeros(padFactor,1);dataAfter];
                data = [dataBefore biggerData];
            else
                padFactor = size(dataAfter,1)-size(dataBefore,1);
                biggerData = [zeros(padFactor,1);dataBefore];
                data = [biggerData dataAfter];
            end
            
            CompareCleaningTable = array2table(data,'VariableNames',{headBefore,headAfter});
            prompt = 'Grade Cleaning';

        elseif givenCase == 2
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % NOTE: 01-10-20
            % You should not get here. We only care about EMG.
            % Make sure you filtered cases in PUSH
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            CHANNELNAME = 'ECG';
            %copyfile([TOCOPYBEFOREFILELOC '\DATAFILE.xlsx'],pwd);
            %movefile('DATAFILE.xlsx','DATAFILEBEFORE.xlsx');
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % FIXME: 01-10-20
            % 'cd' after 'cd'? Where to? Why? What is the idea here?
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            cd(TOCOPYAFTERFILELOC);
            cd('output data');
            
            % returns file listing in output data folder
            listingHROuter = dir;
            listingTableHROuter = struct2table(listingHROuter);
            % Delete unnecessary first two lines
            listingTableHROuter([1,2],:) = [];
            % Here we are searching for non empty folders
            listingTableHROuter.notEmpty = zeros(size(listingTableHROuter,1),1);
            loc = pwd;
            for indHR = 1:size(listingTableHROuter,1)
                cd([loc '\' listingTableHROuter.name{indHR}]);
                if length(dir) > 2
                    listingTableHROuter.notEmpty(indHR) = 0;
                else
                    listingTableHROuter.notEmpty(indHR) = 1;
                end
            end
            % Extract only table rows that represent not-empty folders
            CLEANNINGHROuter = listingTableHROuter(listingTableHROuter.notEmpty == 0,:);        
            % Get into the main folder of output HR
            nameOfFolderHRBeforeCreation = CLEANNINGHROuter.name{1};
            
            % Not necessary because it already happenned inside the loop
            %cd(nameOfFolderHRBeforeCreation);
            
             % returns file listing inside folder inside output data folder
            listingHRInner = dir;
            listingTableHRInner = struct2table(listingHRInner);
            % Delete unnecessary first two lines
            listingTableHRInner([1,2],:) = [];
            CLEANNINGHRInner = listingTableHRInner;        
            % Get HR cleaning file name
            nameOfFileHR = CLEANNINGHRInner.name{1};
            nameOfFolderHR = CLEANNINGHRInner.folder{1};
                  
            cd([loc4 '\' foldername]);
            copyfile([nameOfFolderHR '\' nameOfFileHR],pwd);
            movefile(nameOfFileHR,'DATAFILEAFTER.xlsx');
            
            % We are now in Comparison folder
            pathComparison = pwd;
            copyfile([pathComparison '\DATAFILEAFTER.xlsx'], TOCOPYAFTERFILELOC);
                
            %copyfile([TOCOPYAFTERFILELOC '\DATAFILE2.xlsx'],pwd);
            %movefile('DATAFILE2.xlsx','DATAFILEAFTER.xlsx');
            [dataAfter,~,~] = xlsread('DATAFILEAFTER.xlsx','IBI SERIES');
            %[dataBefore,~,~] = xlsread('DATAFILEBEFORE.xlsx');
            
            head1 = [CHANNELNAME '_HeartRate'];
            head2 = [CHANNELNAME '_zeros'];
            
            dataHR = ECG_Analysis(dataAfter);
            IBINODE = dataHR.ibi;
            HRNODE = dataHR.HR;
            
            data = [HRNODE zeros(size(HRNODE,1),1)];

            CompareCleaningTable = array2table(data,'VariableNames',{head1,head2});
            prompt = 'Grade After';

        else
            % TODO: Fill in case EDA is present
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % NOTE:
        % Making sure we bypass the check
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
%         close all;
%         figureTable = stackedplot(figure, CompareCleaningTable);
%         
%         while 1
%             dlgtitle = 'Cleaning Grade';
%             definput = {};
%             definput(1,:) = {'0'};
%             opts.Resize = 'on';
%             opts.WindowStyle = 'normal';
%             compareScore = inputdlg(prompt,dlgtitle,[1 40],definput,opts);
% 
%             % Making sure we get answers
%             if str2double(compareScore{1})==MARKS{1} || str2double(compareScore{1})==MARKS{2} || str2double(compareScore{1})==MARKS{3}
%                 break;
%             end
%         end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % NOTE: 01-10-20
        % This is crucial for QA. Not suitable for live.
        % It makes sure we bypass the check
        compareScore = {3};
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        cd(TOCOPYAFTERFILELOC)
        mkdir('ComparingFigures');
        cd ComparingFigures
        savefig('Comparing_Figure');
        writematrix(compareScore{1}, 'CleanScoreOf100.txt');
        close all;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % NOTE: 01-08-2020
        % There was a mistake here with the use of "str2double" function.
        % It was not needed.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if compareScore{1}==MARKS{3}
            
            CHANNELLOG.flagCheckClean{transitionInd} = 2;
            
            cd(PUSH_FOLDER_ECG_EMG);
            try
                rmdir(CHANNELLOG.cleaningID{transitionInd},'s');
            catch
                pathFrom = strcat(PUSH_FOLDER_ECG_EMG,'\',CHANNELLOG.cleaningID{transitionInd});
                cd ..
                cd('RecyclePush');
                movefile(pathFrom,pwd);
            end
            
            cd(PULL_FOLDER_ECG_EMG);
            try
                rmdir(CHANNELLOG.cleaningID{transitionInd},'s');
            catch
                pathFrom = strcat(PULL_FOLDER_ECG_EMG,'\',CHANNELLOG.cleaningID{transitionInd});
                cd ..
                cd('RecyclePull');
                movefile(pathFrom,pwd);
            end
            
            cd([loc3 '\Cleaned']);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % NOTE 01-10-20:
            % There was a mistake here with checking equality between
            % 'givenCase' and the integer 2, instead of the integer 1.
            % 1 signifies EMG.
            % 2 signifies HR.
            % Otherwise the channel is EDA, which I still did not prepare
            % processing for.
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if givenCase == 1
                copyfile([TOCOPYAFTERFILELOC '\*'],pwd);
            end
            
            CHANNELLOG.cleaned{transitionInd} = datestr(datetime('now'));
            
            CHANNELLOG.cleanedCertificate{transitionInd} = str2double(compareScore{1});
            
        elseif compareScore{1}==MARKS{2}
            % To signify that the flag was 1 before;
            CHANNELLOG.flagCheckClean{transitionInd} = 3;
            cd(PUSH_FOLDER_ECG_EMG);
            cd(CHANNELLOG.cleaningID{transitionInd})
            delete('SentToClean.txt');
            
            cd(PUSH_FOLDER_ECG_EMG);
            try
                rmdir(CHANNELLOG.cleaningID{transitionInd},'s');
            catch
                pathFrom = strcat(PUSH_FOLDER_ECG_EMG,'\',CHANNELLOG.cleaningID{transitionInd});
                cd ..
                cd('RecyclePush');
                movefile(pathFrom,pwd);
            end
            
            %cd(PUSH_FOLDER_ECG_EMG);
            %rmdir(CHANNELLOG.cleaningID{transitionInd},'s');
            
            mkdir(CHANNELLOG.cleaningID{transitionInd});
            if givenCase == 2
                cd ..
                cd('PROBLEMATIC_HR');
                mkdir(CHANNELLOG.cleaningID{transitionInd});
                cd(CHANNELLOG.cleaningID{transitionInd});
                copyfile([TOCOPYAFTERFILELOC '\*'],pwd);
                delete('DATAFILEAFTER.xlsx');
            end
            
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % NOTE 01-10-20:
        % I never get here. It is important becuase only in live, do I want
        % to delete all the files in the PULL folder.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
        else
            CHANNELLOG.flagCheckClean{transitionInd} = 999;
            
            cd(PUSH_FOLDER_ECG_EMG);
            cd(CHANNELLOG.cleaningID{transitionInd})            
            delete('SentToClean.txt');
              
            cd(PUSH_FOLDER_ECG_EMG);
            try
                rmdir(CHANNELLOG.cleaningID{transitionInd},'s');
            catch
                pathFrom = strcat(PUSH_FOLDER_ECG_EMG,'\',CHANNELLOG.cleaningID{transitionInd});
                cd ..
                cd('RecyclePush');
                movefile(pathFrom,pwd);
            end
            
            %cd(PUSH_FOLDER_ECG_EMG);
            %rmdir(CHANNELLOG.cleaningID{transitionInd},'s');
            % mkdir(CHANNELLOG.cleaningID{transitionInd});
            
            cd(PULL_FOLDER_ECG_EMG);
            try
                rmdir(CHANNELLOG.cleaningID{transitionInd},'s');
            catch
                pathFrom = strcat(PULL_FOLDER_ECG_EMG,'\',CHANNELLOG.cleaningID{transitionInd});
                cd ..
                cd('RecyclePull');
                movefile(pathFrom,pwd);
            end
            
            %cd(PULL_FOLDER_ECG_EMG);
            %rmdir(CHANNELLOG.cleaningID{transitionInd},'s');
            
        end
        
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
    FOLDEREXPMAIN...
    CHANNELLOG...
    PUSH_FOLDER_ECG_EMG...
    PULL_FOLDER_ECG_EMG...
    SEPERATOR...
    CLEANINGATTEMPTS...
    MAKRS

d = datetime('now');
DateString = datestr(d);
envSave = ['05_Cleaning' SEPERATOR 'save3of3_' DateString '.mat'];
envSave = strrep(envSave,':','_');
cd(MAINFOLDERPATH);
save(envSave);

%% Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Results=TBT_EMG(inMaskFile,inDatFile)

%function Results=TBT_EMG(session_name, inMaskFile,inDatFile,OutDir)


% The sampling frequency of the emg data.
samp_freq = 1000;
 
% allChannelData contains (raw/unprocessed) emg data and markers
% indicating the locations of the 3 kinds of events, neg, neu, pos.
load(inDatFile,'-mat');
% allChannelMask - 0(bad)/1(good).
load(inMaskFile,'-mat');


% Interpolate the bad segments of the data.
[allChannelData(:,1),pct_bad] = fillbad(allChannelData(:,1),allChannelMask(:,1));
    
dat = allChannelData';
mask = allChannelMask(:,1)';
clear allChannelData allChannelMask;

% Index of the signal channel
sigChanIdx = 1;
 
% Over sub_seg_size, the 2nd order statistics are assume to remain constant
% This should be chosen such that the statistical  properties of the signal
% within the segment should not change. This means that we cannot group
% data before and after the event takes place
sub_seg_size = 1000*1e-3*samp_freq;

% Consequences of reducing size window
% Advantages - Variance is lowered
% Disadvantages - Spectral resolution is lowered 
%               - This doesn't matter in EMG because the PSD in the 45-200
%                 Hz range is quite flat or in the worst case it is smooth
win_size = 50*1e-3*samp_freq;

% Consequences of changing the size of overlap (unclear at the moment so we
% just take 50% overlap)
num_overlap = win_size/2;%25e-3*samp_freq;

% The upper and lower cut-off frequencies for the power spectrum computation
f_lo = 45;
f_hi = 200;

%Discrete Fourier transform.
signal = dat(sigChanIdx,:)/1000;
SIGNAL=fft(signal);

%Entire Movie clip
% seg_size = (10000)*1e-3*samp_freq;
seg_size=length(signal);

N = length(signal);
if mod(N,2) == 0
  uplim = N/2;
else
  uplim = (N+1)/2;
end

% Filter out power signal and harmonics
%around each harmonic, the number of bad samples in Hz (converted to
%samples)
% 1Hz around each harmonic filtered out
numbad = round(1*N/samp_freq);
% 50 hz and 10 harmonics
pwrfreqindx = 50*[1:10]*N/samp_freq;
pwrfreqindx = round(pwrfreqindx(pwrfreqindx < uplim ));
vld = ones(1,N);
for i=1:length(pwrfreqindx)
    if max(pwrfreqindx(i) - numbad,1) == 1
        right = pwrfreqindx(i) + numbad;
        left = 1;
        rightval = SIGNAL(right);
        leftval = rightval;
    elseif min(pwrfreqindx(i) + numbad,uplim) == uplim
        left = pwrfreqindx(i) - numbad;
        right = uplim;
        leftval = SIGNAL(left);
        rightval = leftval;
    else
        left = pwrfreqindx(i) - numbad;
        right = pwrfreqindx(i) + numbad;
        leftval = SIGNAL(left);
        rightval = SIGNAL(right);
    end
    SIGNAL(left:right) = interp1([left, right], [leftval, rightval],left:right);
end

    
% For a real signal, Fourier transform is conjugate symmetric 
% X(k) = X*(N-k) k = 0... N-1
% X(k) = X*(N-(k-2)) k = 1... N
if mod(N,2) == 0
   SIGNAL = [SIGNAL(1) SIGNAL(2:N/2) SIGNAL(N/2+1) conj(fliplr(SIGNAL(2:N/2)))];
else
   SIGNAL = [SIGNAL(1) SIGNAL(2:(N+1)/2) conj(fliplr(SIGNAL(2:(N+1)/2)))];
end

%Inverse discrete Fourier transform.
signal = (ifft(SIGNAL));
if ~isreal(signal)
   error('IFFT of data is not real')
end

[pathstr,name,ext] = fileparts(inDatFile);
fprintf('Calculating PSD for session %s... \n',name);
% output = [eventTimes, cor_emg];
% fid = fopen([OutDir 'emg_pwr_' name '.txt'],'w');
% for i = 1:numEvents
%     fprintf(fid,'%s %02d ',session_name,i);
%     fprintf(fid,'%s %6.2f',eventVals_text(i,:), eventTimes(i));
%     fprintf(fid,'%6.2f ', round(1000*cor_emg(i,:))/1000);
%     fprintf(fid,'%6.2f ', mask_evt(i,:));
%     fprintf(fid,'%6.2f ', num_good_win_evt(i,:));
%     fprintf(fid,'\n');
% end
% fclose(fid);

% Compute the power spectrum
signal_PSD=[];
cntr= 1;
for j= 1:sub_seg_size:(seg_size-sub_seg_size)
    startSampSeg = j;
    endSampSeg= j+sub_seg_size;
    [pxx,f] = pwelch(signal(startSampSeg:endSampSeg),win_size,[],win_size,samp_freq);
    %Third argument should be num_overlap, not empty
    signal_PSD(cntr) = mean(log10(pxx((f>=f_lo) & (f<=f_hi))));
    mask_evt(cntr) = mean(mask(startSampSeg:endSampSeg));
    mask_seg = mask(startSampSeg:endSampSeg);
    sub_seg_edge = 1:win_size:(endSampSeg-startSampSeg+1);
    tmp = 0;
    for k = 1:length(sub_seg_edge)-1
        tmp(k) = all(mask_seg(sub_seg_edge(k):sub_seg_edge(k+1)));
    end
    num_good_win_evt(cntr) = sum(tmp);
    cntr = cntr+1;
end

% Results=signal_PSD;
%Interpolate PSD
DSMask=ones(length(signal_PSD),1);
inds=unique(floor(find(~mask)/1000));
inds(inds==0)=2;inds(inds==1)=2;
DSMask([inds inds-1 inds+1])=0;
[InterpResults ab]=fillbad(signal_PSD,DSMask);
Results=InterpResults';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function HRdata = ECG_Analysis(ECGCHANNEL)

SR=10; ind=0; updated=0;

%extract IBI and create continuous time series vector
fprintf('Analyzing file: %s\n',"ECG");
ibi_cum=[];ibi_mat=[];IBISeries=[];

IBISeries= ECGCHANNEL;
ibi_mat=IBISeries(2:end)/1000; 
ibi_mat(end)=ibi_mat(end-1);% correcing for last partial value
ibi_cum=cumsum([0 ; ibi_mat]);
xx = (1:ibi_cum(end)*SR)/SR; % this create time series (X-axis) for interpolation of IBI to time
rw_loc1=(ibi_cum(1:end-1)+ibi_cum(2:end))/2;
cs = spline(rw_loc1, ibi_mat);
RR=ppval(cs,xx);
% correcting for first IBI which is not true, partial time only
aa=find(RR>ibi_mat(2),1,'first');RR(1:aa-1)=RR(aa);
ind=ind+1; updated=1;
HR=1./RR*60;   %***********************HR*********************

% Preparing output
HRdata(ind).ibi=RR;
HRdata(ind).HR=HR(:);
end