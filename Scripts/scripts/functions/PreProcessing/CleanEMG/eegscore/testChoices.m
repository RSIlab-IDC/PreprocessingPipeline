	header = 'Fixed channels line color';
	labels = str2mat('Green','Blue ','Black');
	callbacks = str2mat('eval(''fixLineColor = [0 0.5 0]'')', ...
			'eval(''fixLineColor = [0 0 0.5]'')', ...
				'eval(''fixLineColor = [0 0 0]'')');
	choices('CHANL',header,labels,callbacks);
