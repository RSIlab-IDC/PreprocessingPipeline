
task{1}='RatingNegative';
task{2}='RatingPositive';
SM=SM_Data.ratingData(22:2:end,2);
for i=1:55
    for t=1:2
    if ~isempty(ASData(i).(task{t})) && isfield(ASData(i).(task{t}), 'PHASIC_EDA')
        eda{t}(i,:)=ASData(i).(task{t}).PHASIC_EDA(11:end)';
    else
        eda{t}(i,:)=NaN;
    end
    end
end
    
figure
plot(nanmean(eda{1}),'r');hold on
plot(nanmean(eda{2}),'b');hold on
