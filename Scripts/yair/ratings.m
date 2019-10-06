fdir='C:\Users\intlab\Desktop\yulia';
list=dir(fdir)
ratings=NaN(600,34);
for i=1:length(list) 
    file_name=list(i).name;            
    FILE=[fdir  '\'  file_name ];
    test= xlsread(FILE);
    ratings(1:size(test,1),i)= test(:,2);
    clear test
end



neg=ratings(1:554,1:17);
pos=ratings(1:554,18:end);
ratio=nanmean(pos)./nanmean(neg);
ratio1=nanmean(pos(1:238,:))./nanmean(neg(1:238,:));

indpos=find(ratio1>1);
indneg=find(ratio1<1);


figure
plot(nanmean(pos(:,:)'),'g');hold on
plot(nanmean(neg(:,:)'),'r')
plot(Galia,'k')



figure
subplot(1,2,1)
plot(nanmean(pos(:,indpos)'),'g');hold on
plot(nanmean(neg(:,indpos)'),'r')
plot(Galia,'k')
subplot(1,2,2)
plot(nanmean(pos(:,indneg)'),'g');hold on
plot(nanmean(neg(:,indneg)'),'r')
plot(Galia,'k')



for i=1:17
    tmp=corrcoef(pos(:,i),Galia,'rows','complete');
    sync(i,1)=tmp(1,2);
    tmp=corrcoef(neg(:,i),Galia,'rows','complete');
    sync(i,2)=tmp(1,2);
%     figure(i)
%     plot(neg(:,i),'r');hold on
%     plot(pos(:,i),'g');hold on
%     plot(Galia,'k')

end
    

