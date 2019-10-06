function [outData] = loadSingleASTaskByTTL(datafileName, sampleRate, ttlChannel, dSample)


% load a single task with all the relevant channels into the data structure
% input:
%       datafileName - the file name of the raw data structure of a single couple
%       sampleRate - the data original sample rate
%       dSample - downsample factor
%       ttlChannel - channel number of the relevant TTL channel

outData = {};

%loading the raw data file
if exist(datafileName, 'file')
    load(datafileName,'-mat')
    if isempty(data)
        return;
    end
else
    return;
end


%mapping the data index by the relevant label index in the labels array
for ind=1:size(labels,1)
    if strcmp('EDA_1',deblank(labels(ind,:)))
        EDA_1=ind;
    elseif strcmp('EDA_2',deblank(labels(ind,:)))
        EDA_2=ind;
    elseif strcmp('EMG_Zyg_1',deblank(labels(ind,:)))
        EMG_ZYG_1=ind;
    elseif strcmp('EMG_orybcularis',deblank(labels(ind,:)))
        if ~isempty(strfind(datafileName,'_2_2_9.mat'))
            EMG_ZYG_1=ind;
        else
            EMG_Orb_1=ind;
        end
    elseif strcmp('EMG_orbyculairs_2',deblank(labels(ind,:)))
        EMG_Orb_1=ind;
    elseif strcmp('EMG_Corr_1',deblank(labels(ind,:)))
        EMG_Corr_1=ind;
    elseif strcmp('EMG_Corr_2',deblank(labels(ind,:)))
        EMG_Orb_1=ind;
    elseif strcmp('ECG_1',deblank(labels(ind,:)))
        ECG_1=ind;
    elseif strcmp('ECG_2',deblank(labels(ind,:)))
        ECG_2=ind;
    elseif strcmp('HR_1',deblank(labels(ind,:)))
        HR_1=ind;
    elseif strcmp('HR_2',deblank(labels(ind,:)))
        HR_2=ind;
    elseif strcmp('RSP_1',deblank(labels(ind,:)))
        RSP_1 =ind;
    elseif strcmp('RSP_2',deblank(labels(ind,:)))
        RSP_2=ind;
    elseif strcmp('EMG RMS Zyg 1',deblank(labels(ind,:)))
        RMS_Zyg_1=ind;
    elseif strcmp('EMG RMS Corr 1',deblank(labels(ind,:)))
        RMS_Corr_1=ind;
    elseif strcmp('EMG RMS Corr 2',deblank(labels(ind,:)))
        RMS_Orb_1=ind;
        
        
        
    end
end




%loading the data from the .mat files to a single data structure
RawDataStructure = data;
if ttlChannel>0
    ttlChannelData = RawDataStructure(:,ttlChannel);
    if ~isempty(strfind(datafileName, 'ASrn_1_1_4.mat')) %&& length(datafileName)==78 %% I added this condition b/c the function identified ASrn_1_1_40 also
        jj=find(ttlChannelData==0)
        endSig = jj(1);
        startSig = endSig-286300;
        ttlChannelData(1:startSig) = 0;
        ttlChannelData(startSig:endSig) = 5;
    elseif ~isempty(strfind(datafileName, 'AS_1_1_9.mat'))
        ttlChannelData(1:546300) = 5;
    elseif ~isempty(strfind(datafileName, 'AS_1_1_6.mat'))
        RawDataStructure = RawDataStructure(20000:end , :);
        ttlChannelData = ttlChannelData(20000:end);
    else
        ii=1;
        while (ttlChannelData(ii)>0)
            ttlChannelData(ii) = 0;
            ii = ii+1;
        end
    end
    if ~isempty(strfind(datafileName,'_2_2_9.mat'))
        outRawData = RawDataStructure(ttlChannelData>0,[EMG_ZYG_1, EMG_Corr_1, EDA_1, EDA_2, HR_1, RSP_1, ECG_1, RMS_Zyg_1, RMS_Corr_1, RMS_Orb_1]);
    else
        outRawData = RawDataStructure(ttlChannelData>0,[EMG_ZYG_1, EMG_Corr_1, EMG_Orb_1, EDA_1, EDA_2, HR_1, RSP_1, ECG_1, RMS_Zyg_1, RMS_Corr_1, RMS_Orb_1]);
    end
else
    if ~isempty(strfind(datafileName,'_2_2_9.mat'))
        outRawData = RawDataStructure(:,[EMG_ZYG_1, EMG_Corr_1, EDA_1, EDA_2, HR_1, RSP_1, ECG_1, RMS_Zyg_1, RMS_Corr_1, RMS_Orb_1]);
    else
        outRawData = RawDataStructure(:,[EMG_ZYG_1, EMG_Corr_1, EMG_Orb_1, EDA_1, EDA_2, HR_1, RSP_1, ECG_1, RMS_Zyg_1, RMS_Corr_1, RMS_Orb_1]);
    end
end
if ~isempty(strfind(datafileName,'_2_2_9.mat'))
    EMG_ZYG_1 = 1;
    EMG_Corr_1 = 2;
    EDA_1 = 3;
    EDA_2 = 4;
    HR_1 = 5;
    RSP_1 = 6;
    ECG_1 = 7;
    RMS_Zyg_1=8;
    RMS_Corr_1=9;
    RMS_Orb_1=10;
else
    EMG_ZYG_1 = 1;
    EMG_Corr_1 = 2;
    EMG_Orb_1 = 3;
    EDA_1 = 4;
    EDA_2 = 5;
    HR_1 = 6;
    RSP_1 = 7;
    ECG_1 = 8;
    RMS_Zyg_1=9;
    RMS_Corr_1=10;
    RMS_Orb_1=11;
end


if ~isempty(outRawData)
    outData.EMG_ZYG = outRawData(:,EMG_ZYG_1);
    outData.EMG_POWER_ZYG = EMG2PSD(outRawData(:,EMG_ZYG_1), sampleRate)';
    outData.EMG_Corr = outRawData(:,EMG_Corr_1);
    outData.EMG_POWER_Corr = EMG2PSD(outRawData(:,EMG_Corr_1), sampleRate)';
    if isempty(strfind(datafileName,'_2_2_9.mat'))
        outData.EMG_Orb = outRawData(:,EMG_Orb_1);
        outData.EMG_POWER_Orb = EMG2PSD(outRawData(:,EMG_Orb_1), sampleRate)';
    end
    outData.HR = downsample(outRawData(:,HR_1),dSample);
    outData.ECG = outRawData(:,ECG_1);
    outData.RSP = outRawData(:,RSP_1);
    outData.RMS_Zyg = downsample(outRawData(:,RMS_Zyg_1),dSample);
    outData.RMS_Corr = downsample(outRawData(:,RMS_Corr_1),dSample);
    outData.RMS_Orb = downsample(outRawData(:,RMS_Orb_1),dSample);
    
    edaData1 = outRawData(:,EDA_1);
    edaData2 = outRawData(:,EDA_2);
    if nanmean(abs(edaData1))>nanmean(abs(edaData2))
        edaData = edaData1;
    else
        edaData = edaData2;
    end
    outData.RAW_EDA = edaData;
    tmpEDA = downsample(edaData,dSample);
    
    % calculating phasic and tonic EDA and loading it to the data structure
    [phasicSignal, tonicSignal] = get_EDA_components(tmpEDA, sampleRate/dSample, 1);
    outData.PHASIC_EDA = phasicSignal';
    outData.TONIC_EDA = tonicSignal';
    
    
end
% end



end