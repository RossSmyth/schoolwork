speed   = [3000, 4000, 5000, 6000, 7000];
data     = csvread('plot.csv', 1);
db_plot  = data(:, 2:6);
dba_plot = data(:, 8:end);

%%
figure
colormap('jet')
contour(speed, distance, db_plot, 'x', 'levels', 5)
hold on
title('Distance vs. Propeller Speed vs. SPL (dB)')
xlabel('Propeller Speed (RPM)')
ylabel('Distance from Receiver (m)')
set(gca, 'YScale', 'log')
c = colorbar;
c.Label.String = 'Sound Pressure Level (dB)';
hold off

%% 
figure
colormap('jet')
contour(speed, distance, dbA_plot, 'x', 'levels', 5)
hold on
title('Distance vs. Propeller Speed vs. SPL (dBA)')
xlabel('Propeller Speed (RPM)')
ylabel('Distance from Receiver (m)')
set(gca, 'YScale', 'log')
c = colorbar;
c.Label.String = 'Sound Pressure Level (dBA)';
hold off