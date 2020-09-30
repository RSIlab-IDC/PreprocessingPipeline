function Signal=filt50(input)

Fs=1000;

d=designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',49,'HalfPowerFrequency2',51, ...
               'DesignMethod','butter','SampleRate',Fs);

%Visualize Filter's effect
%fvtool(d,'Fs',Fs)

Signal = filtfilt(d,input);

end