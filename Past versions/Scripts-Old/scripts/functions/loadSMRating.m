

function ratingData = loadSMRating ()
% loading all data from mat files to a single dataset mat file



movieLength = 285;
homeDir = GetASBasePath();

rankingFile = [homeDir, '\rawdata\rating_2D\GALIA\0001_f_negative - GALIA.csv'];


ratingData = loadSingleASRatingFromFile(rankingFile, movieLength);


end



