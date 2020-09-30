function cbkeypress;
	k = abs(get(get(0, 'CurrentFigure'), 'CurrentCharacter'));
	disp(k);
