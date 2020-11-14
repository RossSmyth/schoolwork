%Ross Smyth
clear, clc

data = load('Hurricane_Data.txt');

pressure   = data(:, 1); %mB (millibar?)
windSpeeds = data(:, 2); %MPH

[cat1, cat2, cat3, cat4, cat5] = sortWind(windSpeeds);

minQ  = min(pressure);
maxQ  = max(pressure);
meanQ = mean(pressure);

fprintf('Category 1 Speeds (MPH):\n')
disp(cat1)
fprintf('Category 2 Speeds (MPH):\n')
disp(cat2)
fprintf('Category 3 Speeds (MPH):\n')
disp(cat3)
fprintf('Category 4 Speeds (MPH):\n')
disp(cat4)
fprintf('Category 5 Speeds (MPH):\n')
disp(cat5)

fprintf('The max pressure is %g (mB)\nThe min pressure is %g (mB)\nThe average pressure is %g (mB)\n', maxQ, minQ, meanQ)

figure('Name', 'Wind Stuff')
plot(pressure, windSpeeds, 'ob')
title('Air Pressure Compared with Wind Speed')
xlabel('Pressure (mB)')
ylabel('Wind Speed (MPH)')