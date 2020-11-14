function [ cat1, cat2, cat3, cat4, cat5 ] = sortWind( windSpeeds )
%sortWindSpeeds(windSpeeds)
%
%   Inputs:
%       windSpeeds = Vector of all the wind speeds (MPH)
%
%   Outputs:
%       cat1 = Vector of wind speed between 75 and 95 mph
%       cat2 = Vector of wind speed between 96 and 110 mph
%       cat3 = Vector of wind speed between 111 and 130 mph
%       cat4 = Vector of wind speed between 131 and 155 mph
%       cat5 = Vector of wind speed greater than 156

cat1 = windSpeeds(75 <= windSpeeds & windSpeeds < 96);
cat2 = windSpeeds(96 <= windSpeeds & windSpeeds < 111);
cat3 = windSpeeds(111 <= windSpeeds & windSpeeds < 131);
cat4 = windSpeeds(131 <= windSpeeds & windSpeeds < 156);
cat5 = windSpeeds(windSpeeds >= 156);

end

