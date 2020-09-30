function convertHR()
%%% load IBI files, convert them to HR and arange in a data set. 
homeDir = GetASBasePath();

data_dir = [homeDir, '\Matlab\data\PreProcessedData\ECG\Excell\all\'];
output_dir = [homeDir, '\Matlab\data\ProcessedData\HR\'];
SR=10; ind=0; updated=0;

SM_HRdata = {};

%upload the data and convert ibi series to ibi timeseries

    %extract IBI and create continuous time series vector
    fprintf('Analyzing file: %s\n','mainStoryFullData_SM_ECG');
    ibi_cum=[];ibi_mat=[];IBISeries=[];

    IBIFILE=[data_dir 'mainStoryFullData_SM_ECG.xlsx'];
    IBISeries= xlsread(IBIFILE,'IBI Series');
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
    SM_HRdata.ibi=RR;
    SM_HRdata.HR=HR(:);

    
 
  
    
    
fprintf('Saving SM_HRdata...\n');
save([output_dir, 'SM_HRdata.mat'],'SM_HRdata');


