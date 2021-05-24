clc, clear, close all

[time6, veloc6, voltage6] = readvars("high_freq_6v.txt");
[time1, veloc1, voltage1] = readvars("high_freq_1v.txt");
[time3, veloc3, voltage3] = readvars("high_freq_3v.txt");

% Convert to microseconds and ensure the epoch is zero 
time6 = (time6 - time6(1)) / 1000 / 1000;
time6 = time2num(time6);

time1 = (time1 - time1(1)) / 1000 / 1000;
time1 = time2num(time1);

time3 = (time3 - time3(1)) / 1000 / 1000;
time3 = time2num(time3);

% non-uniformly sampled so linearly interpolate to uniform. Since they are 
% fairly high frequency it should be a good approximation.
newTime1 = 0 : mean(diff(time1)) : time1(end);
newTime1 = newTime1';
veloc1   = interp1( time1, veloc1, newTime1 ); 
voltage1 = interp1( time1, voltage1, newTime1 ); 

newTime3 = 0 : mean(diff(time3)) : time3(end);
newTime3 = newTime3';
veloc3   = interp1( time3, veloc3, newTime3 ); 
voltage3 = interp1( time3, voltage3, newTime3 ); 

newTime6 = 0 : mean(diff(time1)) : time6(end);
newTime6 = newTime6';
veloc6   = interp1( time6, veloc6, newTime6 ); 
voltage6 = interp1( time6, voltage6, newTime6 ); 

% Put to datasets
data6Volt = iddata(veloc6, voltage6, [], 'SamplingInstants', newTime6);
data1Volt = iddata(veloc1, voltage1, [], 'SamplingInstants', newTime1);
data3Volt = iddata(veloc3, voltage3, [], 'SamplingInstants', newTime3);