clear all
close all

% col{1}=get_color_paper('Clean_zyg');
% col{2}=get_color_paper('Clean_corr');
% col{3}=get_color_paper('Clean_orb');
% col{4}=get_color_paper('Clean_HR');
% col{5}=get_color_paper('PhasicEDA');
% col{6}=[0.3, 0.3, 0.3];
% save([GetASBasePath(), '\Matlab\data\ISCData\col.mat'],'col');   

%DEFINE PARAMETERS AND LOAD DATA
condition = {'MainStory','Intro', 'FirstBaseline','SecondBaseline','RatingNegative', 'RatingPositive'};
save([GetASBasePath(), '\Matlab\data\ISCData\condition.mat'],'condition'); 
load([GetASBasePath(), '\Matlab\data\ISCData\condition.mat']);
load([GetASBasePath(), '\Matlab\data\ISCData\col.mat']);
% signals={'Clean_zyg','Clean_corr', 'Clean_orb', 'Clean_HR','PhasicEDA'};
% save([GetASBasePath(), '\Matlab\data\ISCData\signals.mat'],'signals');   

load([GetASBasePath(), '\Matlab\data\ISCData\signals.mat']);

load([GetASBasePath(), '\Matlab\data\workMatrixes.mat']);
load([GetASBasePath(), '\Matlab\data\ISCData\couplesIds.mat']);
load([GetASBasePath(), '\Matlab\data\ISCData\SM_matrix.mat']);

matrixes = workMatrixes;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COMPUTE CROSSCOV with SM mainstory signal
maxLag=0;
d=1;
corrMethod = 'XCov';
for d=1:1
    for sig=1:length(signals) %signals
        if sig==3
            continue;
        end
        [crossmatSM_ISC{d,sig},ISCs_SM{d,sig}, SM_ISC_lags{d,sig}]=singles_IntraSC_with_vector(matrixes{d,1}{1,sig}, SM_matrix{1,sig},maxLag, corrMethod);
        ISCs_SM{d,sig}=fisherz(ISCs_SM{d,sig}); %fisher transformation for statistics
    end
end
crosscovData_SM.mainStory_crosscov = crossmatSM_ISC;
crosscovData_SM.mainStory_ISCs = ISCs_SM;
crosscovData_SM.couplesIds = couplesIds;
clear crossmatSM_ISC ISCs_SM SM_ISC_lags
for d=1:1
    for sig=1:length(signals) %signals
        if sig==3
            continue;
        end
        [crossmatSM_ISC{d,sig},ISCs_SM{d,sig}, SM_ISC_lags{d,sig}]=singles_IntraSC_with_vector(matrixes{d,2}{1,sig}, SM_matrix{2,sig},maxLag, corrMethod);
        ISCs_SM{d,sig}=fisherz(ISCs_SM{d,sig}); %fisher transformation for statistics
    end
end
crosscovData_SM.intro_crosscov = crossmatSM_ISC;
crosscovData_SM.intro_ISCs = ISCs_SM;
save([GetASBasePath(),'\Matlab\data\ISCData\crosscovData_SM.mat'],'crosscovData_SM');


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT AVERAGE CROSSCORRELATION
xlimit=160;
load([GetASBasePath(),'\Matlab\data\ISCData\crosscovData_SM.mat']);
crossmatISC = crosscovData_SM.mainStory_crosscov;
plot_avg_crosscor(crossmatISC{1,1},col{1}, xlimit)
export_fig([GetASBasePath(),'\Matlab\results\figures\mean ISC\SM_ISC\mainStory-avg-crosscorr-Zyg.png'], '-m2.5');
plot_avg_crosscor(crossmatISC{1,2},col{2}, xlimit)
export_fig([GetASBasePath(),'\Matlab\results\figures\mean ISC\SM_ISC\mainStory-avg-crosscorr-Corr.png'], '-m2.5');

%ANS
plot_avg_crosscor(crossmatISC{1,4},col{4}, xlimit)
export_fig([GetASBasePath(),'\Matlab\results\figures\mean ISC\SM_ISC\mainStory-avg-crosscorr-HR.png'], '-m2.5');
plot_avg_crosscor(crossmatISC{1,5},col{5}, xlimit)
export_fig([GetASBasePath(),'\Matlab\results\figures\mean ISC\SM_ISC\mainStory-avg-crosscorr-EDA.png'], '-m2.5');

clear crossmatISC
crossmatISC = crosscovData_SM.intro_crosscov;
plot_avg_crosscor(crossmatISC{1,1},col{1}, xlimit)
export_fig([GetASBasePath(),'\Matlab\results\figures\mean ISC\SM_ISC\intro-avg-crosscorr-Zyg.png'], '-m2.5');
plot_avg_crosscor(crossmatISC{1,2},col{2}, xlimit)
export_fig([GetASBasePath(),'\Matlab\results\figures\mean ISC\SM_ISC\intro-avg-crosscorr-Corr.png'], '-m2.5');

%ANS
plot_avg_crosscor(crossmatISC{1,4},col{4}, xlimit)
export_fig([GetASBasePath(),'\Matlab\results\figures\mean ISC\SM_ISC\intro-avg-crosscorr-HR.png'], '-m2.5');
plot_avg_crosscor(crossmatISC{1,5},col{5}, xlimit)
export_fig([GetASBasePath(),'\Matlab\results\figures\mean ISC\SM_ISC\intro-avg-crosscorr-EDA.png'], '-m2.5');





%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COMPUTE MW CROSSCORR with SM mainstory signal
maxLag=0;
d=1;
corrMethod = 'XCor';
for d=1:1
    for sig=1:length(signals) %signals
        if sig==3
            continue;
        end
        [crossmatSM_ISC{d,sig},ISCs_SM{d,sig}, SM_ISC_lags{d,sig}]=singles_mw_IntraSC_with_vector(matrixes{d,1}{1,sig}, SM_matrix{1,sig},maxLag, corrMethod);
        ISCs_SM{d,sig}=fisherz(ISCs_SM{d,sig}); %fisher transformation for statistics
    end
end
mw_crosscovData_SM.mainStory_crosscov = crossmatSM_ISC;
mw_crosscovData_SM.mainStory_ISCs = ISCs_SM;
mw_crosscovData_SM.couplesIds = couplesIds;
clear crossmatSM_ISC ISCs_SM SM_ISC_lags
for d=1:1
    for sig=1:length(signals) %signals
        if sig==3
            continue;
        end
        [crossmatSM_ISC{d,sig},ISCs_SM{d,sig}, SM_ISC_lags{d,sig}]=singles_mw_IntraSC_with_vector(matrixes{d,2}{1,sig}, SM_matrix{2,sig},maxLag, corrMethod);
        ISCs_SM{d,sig}=fisherz(ISCs_SM{d,sig}); %fisher transformation for statistics
    end
end
mw_crosscovData_SM.intro_crosscov = crossmatSM_ISC;
mw_crosscovData_SM.intro_ISCs = ISCs_SM;

save([GetASBasePath(),'\Matlab\data\ISCData\mw_crosscovData_SM.mat'],'mw_crosscovData_SM');


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT AVERAGE MW CROSSCORRELATION with SM

xlimit=60;
load([GetASBasePath(),'\Matlab\data\ISCData\mw_crosscovData_SM.mat']);
crossmatISC = mw_crosscovData_SM.mainStory_crosscov;
plot_avg_crosscor(crossmatISC{1,1},col{1}, xlimit)
export_fig([GetASBasePath(),'\Matlab\results\figures\mean ISC\SM_MW_ISC\mainStory-mw-avg-crosscorr-Zyg.png'], '-m2.5');
plot_avg_crosscor(crossmatISC{1,2},col{2}, xlimit)
export_fig([GetASBasePath(),'\Matlab\results\figures\mean ISC\SM_MW_ISC\mainStory-mw-avg-crosscorr-Corr.png'], '-m2.5');

%ANS
plot_avg_crosscor(crossmatISC{1,4},col{4}, xlimit)
export_fig([GetASBasePath(),'\Matlab\results\figures\mean ISC\SM_MW_ISC\mainStory-mw-avg-crosscorr-HR.png'], '-m2.5');
plot_avg_crosscor(crossmatISC{1,5},col{5}, xlimit)
export_fig([GetASBasePath(),'\Matlab\results\figures\mean ISC\SM_MW_ISC\mainStory-mw-avg-crosscorr-EDA.png'], '-m2.5');

crossmatISC = mw_crosscovData_SM.intro_crosscov;
plot_avg_crosscor(crossmatISC{1,1},col{1}, xlimit)
export_fig([GetASBasePath(),'\Matlab\results\figures\mean ISC\SM_MW_ISC\intro-mw-avg-crosscorr-Zyg.png'], '-m2.5');
plot_avg_crosscor(crossmatISC{1,2},col{2}, xlimit)
export_fig([GetASBasePath(),'\Matlab\results\figures\mean ISC\SM_MW_ISC\intro-mw-avg-crosscorr-Corr.png'], '-m2.5');

%ANS
plot_avg_crosscor(crossmatISC{1,4},col{4}, xlimit)
export_fig([GetASBasePath(),'\Matlab\results\figures\mean ISC\SM_MW_ISC\intro-mw-avg-crosscorr-HR.png'], '-m2.5');
plot_avg_crosscor(crossmatISC{1,5},col{5}, xlimit)
export_fig([GetASBasePath(),'\Matlab\results\figures\mean ISC\SM_MW_ISC\intro-mw-avg-crosscorr-EDA.png'], '-m2.5');




%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COMPUTE CROSSCORR between participants and mean signal
clear crossmatISC ISCs crosscovData

maxlag=0;
corrMethod = 'XCov';
step=10;
for d=1:1
    for c=1:length(condition) % conditions
        for sig=1:length(signals) %signals
            cond=condition{c};
             [crossmatISC{d,c}{1,sig},ISCs{d,c}(:,sig)]=singles_ISC(matrixes{d,c}{1,sig}(:,step:end),maxlag, corrMethod);
             ISCs{d,c}(:,sig)=fisherz(ISCs{d,c}(:,sig)); %fisher transformation for statistics
        end        
    end
end

crosscovData.crosscov = crossmatISC;
crosscovData.ISCs = ISCs;
crosscovData.couplesIds = couplesIds;
save([GetASBasePath(),'\Matlab\data\ISCData\crosscovData.mat'],'crosscovData');

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT AVERAGE CROSSCORR between participants and mean signal
xlimit=160;
load([GetASBasePath(),'\Matlab\data\ISCData\crosscovData.mat']);
crossmatISC = crosscovData.crosscov;
for d=1:1
    for c=1:length(condition) % conditions
        cond = condition{c};
        for sig=1:length(signals) %signals
            signal = signals{sig};
            cond=condition{c};
            plot_avg_crosscor(crossmatISC{d,c}{1,sig},col{sig}, xlimit)
            export_fig([GetASBasePath(),'\Matlab\results\figures\mean ISC\ISC_with_mean\', cond, '-avg-crosscov-', signal, '.png'], '-m2.5');
        end        
    end
end



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COMPUTE MW CROSSCORR between participants and mean signal
clear mw_crossmatISC mw_ISCs mw_crosscorrData

maxlag=0;
corrMethod = 'XCor';
step=10;
for d=1:1
    for c=1:length(condition) % conditions
        for sig=1:length(signals) %signals
            cond=condition{c};
            [a,b] = singles_mw_ISC(matrixes{d,c}{1,sig}(:,step:end),maxlag, corrMethod);
            [mw_crossmatISC{d,c}{1,sig},mw_ISCs{d,c}{1,sig}]=singles_mw_ISC(matrixes{d,c}{1,sig}(:,step:end),maxlag, corrMethod);
            mw_ISCs{d,c}{1,sig}=fisherz(mw_ISCs{d,c}{1,sig}); %fisher transformation for statistics
        end        
    end
end

mw_crosscorrData.crosscov = mw_crossmatISC;
mw_crosscorrData.ISCs = mw_ISCs;
mw_crosscorrData.couplesIds = couplesIds;
save([GetASBasePath(),'\Matlab\data\ISCData\mw_crosscorrData.mat'],'mw_crosscorrData');

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT AVERAGE CROSSCORR between participants and mean signal
xlimit=60;
load([GetASBasePath(),'\Matlab\data\ISCData\mw_crosscorrData.mat']);
crossmatISC = mw_crosscorrData.crosscov;
for d=1:1
    for c=1:length(condition) % conditions
        cond = condition{c};
        for sig=1:length(signals) %signals
            signal = signals{sig};
            cond=condition{c};
            plot_avg_crosscor(crossmatISC{d,c}{1,sig},col{sig}, xlimit)
            export_fig([GetASBasePath(),'\Matlab\results\figures\mean ISC\MW_ISC_with_mean\', cond, '-avg-mw-crosscov-', signal, '.png'], '-m2.5');
        end        
    end
end




%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COMPUTE CROSSCORR between participants rating and rating mean signal
clear rating_crossmatISC rating_ISCs rating_crosscovData

maxlag=0;
corrMethod = 'XCov';
step=2;
for d=1:1
    for c=6:7 % conditions
        [rating_crossmatISC{d,c-5},rating_ISCs{d,c-5}]=singles_ISC(matrixes{d,c}(:,step:end),maxlag, corrMethod);
        %              rating_ISCs{d,c}(:,sig)=rating_fisherz(ISCs{d,c}(:,sig)); %fisher transformation for statistics
    end
end

rating_crosscovData.crosscov = rating_crossmatISC;
rating_crosscovData.ISCs = rating_ISCs;
rating_crosscovData.couplesIds = couplesIds;
save([GetASBasePath(),'\Matlab\data\ISCData\rating_crosscovData.mat'],'rating_crosscovData');

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT AVERAGE CROSSCORR between participants and mean signal
xlimit=160;
load([GetASBasePath(),'\Matlab\data\ISCData\rating_crosscovData.mat']);
crossmatISC = rating_crosscovData.crosscov;
ratingConds = {'NegativeRating', 'PositiveRating'};
for d=1:1
    for c=1:length(ratingConds) % conditions
        cond = ratingConds{c};
            plot_avg_crosscor(crossmatISC{d,c},col{c}, xlimit)
            export_fig([GetASBasePath(),'\Matlab\results\figures\mean ISC\Rating_ISC\', cond, '-avg-crosscov.png'], '-m2.5');
    end
end


