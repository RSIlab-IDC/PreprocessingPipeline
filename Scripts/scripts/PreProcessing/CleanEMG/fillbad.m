function  [dataout,pct_bad] = fillbad(datain,mask)
   %fillbad() - Fill Bad areas using interpolation
   %datain    - Corrupted data
   %mask      - Mask (0=>data bad, 1=>data good)
   %dataout   - Interpolated data
   %pct_bad   - Percentage of data that is bad
   
   mask    = mask(:);
   datain  = datain(:);
   dataout = datain;
   
   
   a = mask;
   %Shift right the mask by one sample
   b = [1;mask(1:end-1)];
   %Find the boundaries/locations of the marked segments
   c = xor(a,b);
   d = find(c);
   
   %If we have no bad segments then d is empty
   if isempty(d)
      %We have no bad segments
      %So percentage of data that is bad = 0
      pct_bad = 0;
      
   %If we have atleast one bad segment
   else
      %Start sample of the boundaries
      s = d(1:2:length(d));
      %If we have odd # of bdrs then the end boundary segment has not been detected
      if (mod(length(d),2) ~= 0)
         %End sample of the boundaries
         e = [d(2:2:length(d))-1;length(mask)];
      else
         %End sample of the boundaries
         e = d(2:2:length(d))-1;
      end
      
      %Percentage of data that is bad
      pct_bad = round(100*(sum(e-s)/length(mask)));
      
      %If the entire data is bad
      if ((s(1) == 1) && (e(1) == length(mask)))
         dataout = zeros(length(mask),1);
      else
         %If the first segment lies on the boundary
         if (s(1) == 1)
            dataout(s(1):e(1)) = datain(e(1));
            s = s(2:end);
            e = e(2:end);
         end
         %If we have atleast one bad segment other than the first boundary segment
         if (~isempty(s) && ~isempty(e))
            %If the last segment lies on the boundary
            if (e(end) == length(mask))
               dataout(s(end):e(end)) = datain(s(end));
               s = s(1:end-1);
               e = e(1:end-1);
            end
         end
         %If we have atleast one bad segment other than the first & last boundary segment
         if (~isempty(s) && ~isempty(e))
            %Length of each marked/bad (excluding the boundary) segment
            lseg = e-s+1;
            %Number of segments
            numseg = length(lseg);
            for i=1:numseg
               %Time axis of interpolation
               %Always assume that the start and the end points are 0,1 resp.
               t = linspace(0,1,lseg(i));
               %Interpolate (Linear) the samples in the bad areas i.e. b/w good region
               dataitp = interp1([0,1],[datain(s(i)),datain(e(i))],t);
               dataout(s(i):e(i)) = dataitp;
            end
         end
      end
   end
end