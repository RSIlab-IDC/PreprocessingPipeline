function s = dirFromFile(filename)

[s,n,e]=fileparts(filename);
if length(s) < 1
	s = '.';
end
