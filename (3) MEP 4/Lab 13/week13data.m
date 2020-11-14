clear, clc, close all

%% Sensor Variation

lidar  = readtable("Lidar_Noise_Sample.txt");

figure
hold on
histfit(lidar.Measured)
title('Variation of Measured LIDAR Data')
xlabel('Measured Height (m)')
ylabel('Samples')

mes_m = mean(lidar.Measured)
mes_var = var(lidar.Measured)
mes_std = std(lidar.Measured)

xline(mes_m)
xline(mes_m + mes_std, '--')
xline(mes_m - mes_std, '--')

legend('Data Bins', 'Fit Gaussian Curve', 'Mean', 'STD')

%% "By-hand" Kalman fitler

data    = lidar.Measured(1:200);

vel_mean = mean(diff(lidar.Measured)./diff(lidar.Time));
vel_var  = var(diff(lidar.Measured)./diff(lidar.Time));

x   = 0.9; % Initial state, assumed demand (zero)
err = 0.1;

% Process and sensor error
sen_err  = mes_std; % Measured sensor error
proc_err = 0.0001; % idk

gain     = @(est_err) est_err / (est_err + sen_err);
estimate = @(est, gain, meas) est + gain * (meas - est);
error    = @(gain, est_err) (1 - gain) * (est_err + proc_err);

est      = [];
kg_hist  = [];
err_hist = []

for i=1:length(data)
    est(i)      = x;
    err_hist(i) = err;
    
    kalman_gain = gain(err);
    x           = estimate(x, kalman_gain, data(i));
    err         = error(kalman_gain, err);
    
    kg_hist(i) = kalman_gain;
end
est(end + 1) = x;

figure
hold on
plot(lidar.Time(1:201), est, lidar.Time(1:201), lidar.Measured(1:201))

title('Kalman Filtered LIDAR Data')
xlabel('Time (s)')
ylabel('Altitude (m)')
legend('Filtered Data', 'Unfiltered Data')

hold off

figure
hold on
plot(lidar.Time(1:200), kg_hist, lidar.Time(1:200), err_hist)

title('Kalman Filtered LIDAR Data')
xlabel('Time (s)')
ylabel('')
legend('Kalman Gain', 'Estimate Error')

hold off