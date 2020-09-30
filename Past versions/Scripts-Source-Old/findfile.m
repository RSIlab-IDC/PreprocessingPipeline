h = findfile2("D","CHANNELLOG.mat");

function filefolder = findfile2(root, filename)
   dircontent = dir(fullfile(root, '*'));
   if any(strcmpi({dircontent(~[dircontent.isdir]).name}, filename))  %case insensitive comparison. Works for Windows only. 
        %file is found in directory
        filefolder = root;
   else
        %look in subdirectories
        for subdir = dircontent([dircontent.isdir] & ~ismember({dircontent.name}, {'.', '..'}))'
            filefolder = findfile(fullfile(root, subdir.name), filename);
            if ~isempty(filefolder)
                %found in a directory, all done
                return;
            end
        end
        %looked in all subdirectories and not found
        filefolder = ''; %return empty
   end
end