
function outfilename = pervertfile(infilename, extension)

% function outFileName = pervertfile(infilename, extension)
%
% infilename is stripped of its extension (".XXX"), then the
% provided extension is added to it. If this file exists, then
% outfilename is set to it. Otherwise, infilename sans extension
% is stripped of its appendage ("_XXX") and that filename is tried.
% The appendage-stripping is repeated until a real filename is found
% or no more appendages remain.
%
% If a real file is found, its name is returned; otherwise 0 is returned.

baseFileName = dropext(infilename);
%     baseFileName = regexprep(infilename, '\.\w*','') %modified DL 12/6/06


outfilename = [baseFileName extension];
bfn = baseFileName;
while (fileExists(outfilename) == 0)
% while (fopen(outfilename) > 0) %modified DL 12/6/06 
	if (strcmp(bfn, dropAppend(bfn)) == 1)
		outfilename = 0;
		break;
	end
	bfn = dropAppend(bfn);
	outfilename = [bfn extension];
end
