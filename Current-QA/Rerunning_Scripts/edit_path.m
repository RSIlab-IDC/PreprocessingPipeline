load('04_CleaningFolderCreation.mat');

strToSearch = {'SOF'};
buffer = {'D:\playingGround\SOF'};

EXPERIMENTS_PATH = char(pathChange(EXPERIMENTS_PATH,strToSearch,buffer));
FIGURES_FOLDER = char(pathChange(FIGURES_FOLDER,strToSearch,buffer));
FOLDEREXPMAIN = char(pathChange(FOLDEREXPMAIN,strToSearch,buffer));
MAINFOLDERPATH = char(pathChange(MAINFOLDERPATH,strToSearch,buffer));
MEASUREMENTFOLDERPATH = char(pathChange(MEASUREMENTFOLDERPATH,strToSearch,buffer));
PARTICIPANTFOLDERPATH = char(pathChange(PARTICIPANTFOLDERPATH,strToSearch,buffer));
PULL_FOLDER_ECG_EMG = char(pathChange(PULL_FOLDER_ECG_EMG,strToSearch,buffer));
PUSH_FOLDER_ECG_EMG = char(pathChange(PUSH_FOLDER_ECG_EMG,strToSearch,buffer));
RATINGS_PATH = char(pathChange(RATINGS_PATH,strToSearch,buffer));
RAW_PATH = char(pathChange(RAW_PATH,strToSearch,buffer));

save('05_makingTable.mat');


function [changeName] = pathChange(vari,str1,str2)
    strToEdit = vari;
    changeName = strcat(str2,extractAfter(strToEdit, str1));
end

