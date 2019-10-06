
positiveMovieData = {};
homePath = 'C:\Users\intlab\Dropbox\Experiments\Compassion_VR';
homePath = 'C:\Users\eran.shor\Dropbox\Compassion_VR';
datafileName = [homePath, '\senders_signals\SM_01\positivemovie_01.mat'];
%loading the raw data file
load(datafileName,'-mat')
ttlChannel=12;
sampleRate = 1000;
dSample = 100;
%mapping the data index by the relevant label index in the labels array
for ind=1:size(labels,1)
    if strcmp('EDA_1',deblank(labels(ind,:)))
        EDA_1=ind;
    elseif strcmp('EMG_Zyg_1',deblank(labels(ind,:)))
        EMG_ZYG_1=ind;
    elseif strcmp('EMG_Corr_1',deblank(labels(ind,:)))
        EMG_Corr_1=ind;
    elseif strcmp('ECG_1',deblank(labels(ind,:)))
        ECG_1=ind;
    elseif strcmp('HR_1',deblank(labels(ind,:)))
        HR_1=ind;
    elseif strcmp('RSP_1',deblank(labels(ind,:)))
        RSP_1 =ind;
        
    end
end




%loading the data from the .mat files to a single data structure
RawDataStructure = data;

ttlChannelData = RawDataStructure(:,ttlChannel);
ii=1;
while (ttlChannelData(ii)>0)
    ttlChannelData(ii) = 0;
    ii = ii+1;
end
outRawData = RawDataStructure(ttlChannelData>0,[EMG_ZYG_1, EMG_Corr_1, EDA_1, HR_1, RSP_1, ECG_1]);
%remove first 10 seconds of recorsings
outRawData = outRawData(10*sampleRate:end,:);

EMG_ZYG_1 = 1;
EMG_Corr_1 = 2;
EDA_1 = 3;
HR_1 = 4;
RSP_1 = 5;
ECG_1 = 6;


if ~isempty(outRawData)
    positiveMovieData.EMG_ZYG = outRawData(:,EMG_ZYG_1);
    positiveMovieData.EMG_POWER_ZYG = EMG2PSD(outRawData(:,EMG_ZYG_1), sampleRate)';
    positiveMovieData.EMG_Corr = outRawData(:,EMG_Corr_1);
    positiveMovieData.EMG_POWER_Corr = EMG2PSD(outRawData(:,EMG_Corr_1), sampleRate)';
    positiveMovieData.HR = outRawData(:,HR_1);
    positiveMovieData.ECG = outRawData(:,ECG_1);
    positiveMovieData.RSP = outRawData(:,RSP_1);
    positiveMovieData.RAW_EDA = outRawData(:,EDA_1);
    tmpEDA = downsample(outRawData(:,EDA_1),dSample);
    
    % calculating phasic and tonic EDA and loading it to the data structure
    [phasicSignal, tonicSignal] = get_EDA_components(tmpEDA, sampleRate/dSample, 1);
    positiveMovieData.PHASIC_EDA = phasicSignal';
    positiveMovieData.TONIC_EDA = tonicSignal';
    
    
end
% end

save([homePath, '\Matlab\data\positiveMovie_01.mat'],'positiveMovieData','-v7.3');


