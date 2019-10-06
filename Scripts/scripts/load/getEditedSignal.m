function [outMat] = getEditedSignal(mat,task)

mainStoryStart = 172;
mainStoryEnd = 516;
introStart = 39;
introEnd = 150;
mainIndexes = mainStoryStart:mainStoryEnd;
introIndexes = introStart:introEnd;
switch (task)
    case 'MainStory'
        outMat = mat(:, mainIndexes);
    case 'Intro'
        outMat = mat(:,introIndexes);
    otherwise
        outMat = mat;
        
end
end