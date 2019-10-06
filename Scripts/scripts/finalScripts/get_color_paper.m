function color=get_color_paper(signal)

switch signal
    case 'Clean_zyg'
        color=[237 126 49]./ 255; %zyg (orange)
        %color=[217 95 2]./ 255; % brewcolor

        %color=[228 26 28]./ 255; %zyg (greenish)
        
    case 'Clean_orb'
%         color=[237 126 49]./ 255; %zyg (orange)
        %color=[217 95 2]./ 255; % brewcolor

        color=[228 26 28]./ 255; %zyg (greenish)

    case 'Clean_corr'
        color=[91 155 213]./ 255; %corr (purple)
        %color=[31 120 180]./ 255;  %(greenish)
        %color=[117 112 179]./ 255; %zyg (greenish)

        %color=[55 126 184]./ 255; %zyg (greenish)
    case 'Clean_HR'
        color=[255 0 0]./ 255; %HR (red)
        %color=[228 26 28]./ 255; %HR (red)
        %%color=[231 41 138]./ 255; %HR (red)
        %color=[77 175 74]./ 255; %HR (red)
        %color=[27 158 119]./ 255; %HR (green)

    case 'PhasicEDA'
        color=[0 0 255]./ 255; %EDA (softblue)
        %color=[152 78 163]./ 255; %EDA (softblue)

        %color=[231 41 138]./ 255; %EDA (softblue)

end