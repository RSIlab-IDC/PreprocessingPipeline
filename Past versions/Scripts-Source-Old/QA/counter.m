cnt = 0;
for i=1:size(general,1)
    if general.flagCheckClean{i} == 2 || general.flagCheckClean{i} == 3 || general.flagCheckClean{i} == 999
        cnt = cnt + 1;
    end
end