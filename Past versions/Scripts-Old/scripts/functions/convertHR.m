function convertHR()
%%% load IBI files, convert them to HR and arange in a data set. 
homeDir = GetASBasePath();

SHOW_FIGURES=0;
data_dir=[homeDir, '\Matlab\data\PreProcessedData\ECG\Excell\all\'];
% output_dir=[homeDir, '\Matlab\data'];
output_dir=[homeDir, '\Matlab\data\ProcessedData\HR\'];

files=dir(data_dir);
files(1:2)=[]; SR=10; ind=0; updated=0;

if exist([output_dir '\HRdata.mat'],'file')
    load([output_dir '\HRdata.mat']);
    for k=1:length(HRdata)
        Oldfiles{k}=HRdata(k).name;
        ind=length(HRdata);
    end
end

%upload the data and convert ibi series to ibi timeseries
for i=1:length(files)

    if isempty(strfind(lower(files(i).name),'_ecg')) 
        continue %Skip if not a proper file
    end
    
%     if exist('Oldfiles','var')
%         if ismember(files(i).name,Oldfiles)
%             continue %Skip if file already in HRdata
%         end
%     end
    %extract IBI and create continuous time series vector
    fprintf('Analyzing file: %s\n',files(i).name);
    ibi_cum=[];ibi_mat=[];IBISeries=[];

    IBIFILE=[data_dir files(i).name];
    IBISeries= xlsread(IBIFILE,'IBI Series');
    ibi_mat=IBISeries(2:end)/1000; 
    ibi_mat(end)=ibi_mat(end-1);% correcing for last partial value
    ibi_cum=cumsum([0 ; ibi_mat]);
    xx = (1:ibi_cum(end)*SR)/SR; % this create time series (X-axis) for interpolation of IBI to time
    rw_loc1=(ibi_cum(1:end-1)+ibi_cum(2:end))/2;
    if ~isempty(strfind(IBIFILE, 'ASb1_2_1_16_ECG'))
        ss=66;
    end
    cs = spline(rw_loc1, ibi_mat);
    RR=ppval(cs,xx);
    % correcting for first IBI which is not true, partial time only
    aa=find(RR>ibi_mat(2),1,'first');RR(1:aa-1)=RR(aa);
    ind=ind+1; updated=1;
    HR=1./RR*60;   %***********************HR*********************
    
    
    name = files(i).name;
    indx = strfind(name, '_');
    sessionId = name(indx(1)+1:indx(4)-1);
    task = name(1:indx(1)-1);
    
    HRdata(ind).name=files(i).name;
    HRdata(ind).sessionId = sessionId;
    HRdata(ind).task = task;
    HRdata(ind).ibi=RR;
    HRdata(ind).HR=HR(:);
        if SHOW_FIGURES,
            figure(i)
            %plot([1/SR:1/SR:length(HRdata(i).ibi)/SR], 1./HRdata(i).ibi*60)
            plot(IBISeries(3:end-1))
            plot(HRdata(ind).HR);
            title(files(i).name)
            savepath=[homeDir '\Matlab\data\PreProcessedData\ECG\figures\'];
            savename=[sessionId, '-', task];
            saveas(gcf,[savepath savename],'bmp')
        end    
end

if updated
    fprintf('Saving HRdata...\n');
    save([output_dir, '\HRdata.mat'],'HRdata');
else
    fprintf('No new files to add!\n');
end

