
for c=1:2
    for sig=1:5
    mdata{c,1}{1,sig}=matrixes{c,2}{1,sig};
    mdata{c,2}{1,sig}=matrixes{c,1}{1,sig};
    mdata{c,3}{1,sig}=bsxfun(@minus,mdata{c,2}{1,sig}(:,10:end),mean(mdata{c,1}{1,sig}')');
    mdata{c,4}{1,sig}=bsxfun(@minus,mdata{c,2}{1,sig}(:,41:end),mean(mdata{c,1}{1,sig}(:,30:40)')');
    mdata{c,5}{1,sig}=bsxfun(@minus,mdata{c,2}{1,sig}(:,161:end),mean(mdata{c,1}{1,sig}(:,150:160)')');
   
    end
end





for sig=1:5
    figure
    plot(nanmean(mdata{1,3}{1,sig}),'b'); hold on
    plot(nanmean(mdata{2,3}{1,sig}),'r'); hold on
end

for sig=1:5
    figure
    subplot(1,2,1)
    plot(nanmean(mdata{1,4}{1,sig}),'b'); hold on
    plot(nanmean(mdata{2,4}{1,sig}),'r'); hold on
    subplot(1,2,2)
    plot(nanmean(mdata{1,5}{1,sig}),'b'); hold on
    plot(nanmean(mdata{2,5}{1,sig}),'r'); hold on
end