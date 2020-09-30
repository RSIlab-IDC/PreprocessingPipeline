function fixedRanking = loadSingleASRatingFromFile(DatafileName, maxLen)

[numData, txtData, rawData] = xlsread(DatafileName);

ranking = numData(:, 1:2);
time = ranking(:,1);
rateVal = ranking(:,2);

if ~isempty(strfind(DatafileName, '2_2_9_m_'))
    a=[1:2:length(time)];
    time = ranking(a,1);
    rateVal = ranking(a,2);
end

fixedTime = [0.5:0.5:maxLen];

% Matan Edit
[time, indexTime] = unique(time);
fixedRating = interp1(time, rateVal(indexTime), fixedTime, 'linear');

% Original version:
% fixedRating = interp1(time, rateVal, fixedTime, 'linear');

fixedRanking=[fixedTime(2:end)', fixedRating(2:end)'];
% clf;
% plot(ranking(:,2));
% hold on;
% plot(fixedRanking(:,2));
% legend('orig', 'interp');
% hold off;
% a=fixedRating;
end