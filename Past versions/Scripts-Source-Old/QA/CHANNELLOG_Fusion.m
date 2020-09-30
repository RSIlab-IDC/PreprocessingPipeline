% INSTRUCTIONS: 
% 1) Load the CHANNELLOG structure to the environment.
% 2) Change its name to 'general'
% 3) Run the script

% returns file listing in pull folder
listingQA = dir;

% Getting a list of .mat files from RAW_PATH folder path
listingTableQA = struct2table(listingQA);

% Delete unnecessary first two lines
listingTableQA([1,2],:) = [];

clearvars -except ...
    general...
    listingTableQA...
    listingQA

for indOut=1:size(listingTableQA,1)

    load(listingTableQA.name{indOut});
    
%     if ~exist('loc4','var')
%         
%         clearvars -except ...
%             general...
%             indOut...
%             listingTableQA...
%             listingQA
%         
%         continue
% 
%     else
%         
    TEMP = min(size(general,1),size(CHANNELLOG,1));
    for indIn=1:TEMP

        if CHANNELLOG.flagCheckClean{indIn} == 2 || CHANNELLOG.flagCheckClean{indIn} == 3 || CHANNELLOG.flagCheckClean{indIn} == 999

            mes = strcat('We are in outer ', num2str(indOut),'and in inner ', num2str(indIn));
            disp(mes);
            general.cleaned{indIn} = CHANNELLOG.cleaned{indIn};
            general.cleanedCertificate{indIn} = CHANNELLOG.cleanedCertificate{indIn};
            general.flagCheckClean{indIn} = CHANNELLOG.flagCheckClean{indIn};

        end

    end

    clearvars -except ...
        general...
        indOut...
        listingTableQA...
        listingQA       
       
   %end
   
end