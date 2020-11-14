clear, clc, close all
%% Error Characterization
hs_char = readvars("high_speed_charecterize.txt");
ls_char = readvars("low_speed_charecterize.txt");

hs_mean = mean(hs_char);
ls_mean = mean(ls_char);

hs_std = std(hs_char);
ls_std = std(ls_char);

hs_dec = hs_std / hs_mean;
ls_dec = ls_std / ls_mean;

figure
hold on
plot(hs_char, 'b.')
plot(ls_char, 'r.')

yline(hs_mean, 'b');
yline(hs_std + hs_mean, 'b--');
yline(hs_mean - hs_std, 'b--', 'HandleVisibility','off');

yline(ls_mean, 'r');
yline(ls_std + ls_mean, 'r--');
yline(ls_mean - ls_std, 'r--', 'HandleVisibility','off');

legend('High Speed Data', 'Low Speed Data', 'Mean High Speed', 'High Speed 1-\sigma Error', 'Mean Low Speed', 'Low Speed 1-\sigma Error')

xlabel('Data index')
ylabel('Air speed (m/s)')
title('Constant Low and High Speed Propeller Rotation Error Characterization')

text(5, 17, sprintf('High Speed Mean = %.2g m/s', hs_mean))
text(5, 16.5, sprintf('High Speed 1-\\sigma Error = \\pm%.2g m/s', hs_std))
text(5, 16, sprintf('High Speed percent Error = \\pm%.2g%%', hs_dec * 100))

text(5, 11, sprintf('Low Speed Mean = %.2g m/s', ls_mean))
text(5, 10.5, sprintf('Low Speed 1-\\sigma Error = \\pm%.2g m/s', ls_std))
text(5, 10, sprintf('Low Speed percent Error = \\pm%.2g%%', ls_dec * 100))
hold off

%% Velocity data

[hs_vel_pos, hs_vel_1] = readvars("4.0_inches_high_speed.txt");
[~, hs_vel_2]          = readvars("7.325_inches_high_speed.txt");
[~, hs_vel_3]          = readvars("10.5_inches_high_speed.txt");

hs_err_1 = hs_vel_1 * (hs_dec * 3);
hs_err_2 = hs_vel_2 * (hs_dec * 3);
hs_err_3 = hs_vel_3 * (hs_dec * 3);

[ls_vel_pos, ls_vel_1] = readvars("4.0_inches_low_speed.txt");
[~, ls_vel_2]          = readvars("7.325_inches_low_speed.txt");
[~, ls_vel_3]          = readvars("10.5_inches_low_speed.txt");

ls_err_1 = ls_vel_1 * (ls_dec * 3);
ls_err_2 = ls_vel_2 * (ls_dec *3);
ls_err_3 = ls_vel_3 * (ls_dec * 3);

figure
hold on
errorbar(hs_vel_pos, hs_vel_1, hs_err_1, 'Marker', '*')
errorbar(ls_vel_pos, ls_vel_1, ls_err_1, 'Marker', '*')
xlabel('Radial Position (mm)')
ylabel('Airspeed (m/s)')
title('Airspeed at 4.0 inches from propellor at high and low rotation rates with 3-\sigma error bars')
legend('6600 RPM', '3800 RPM')
hold off

figure
hold on
errorbar(hs_vel_pos, hs_vel_2, hs_err_2, 'Marker', '*')
errorbar(ls_vel_pos, ls_vel_2, ls_err_2, 'Marker', '*')
xlabel('Radial Position (mm)')
ylabel('Airspeed (m/s)')
title('Airspeed at 7.325 inches from propellor at high and low rotation rates with 3-\sigma error bars')
legend('6600 RPM', '3800 RPM')
hold off

figure
hold on
errorbar(hs_vel_pos, hs_vel_3, hs_err_3, 'Marker', '*')
errorbar(ls_vel_pos, ls_vel_3, ls_err_3, 'Marker', '*')
xlabel('Radial Position (mm)')
ylabel('Airspeed (m/s)')
title('Airspeed at 10.5 inches from propellor at high and low rotation rates with 3-\sigma error bars')
legend('6600 RPM', '3800 RPM')
hold off

%% Thrust
thrust = @(pos, vel) 2 * pi * 1.225 * cumtrapz(pos, vel.^2 .* pos);

hs_thrust_1_nom = thrust(hs_vel_pos / 1000, hs_vel_1);
hs_thrust_2_nom = thrust(hs_vel_pos / 1000, hs_vel_2);
hs_thrust_3_nom = thrust(hs_vel_pos / 1000, hs_vel_3);

hs_thrust_1_up = thrust(hs_vel_pos / 1000, hs_vel_1 * (1 + 3*hs_dec)) - hs_thrust_1_nom;
hs_thrust_2_up = thrust(hs_vel_pos / 1000, hs_vel_2 * (1 + 3*hs_dec)) - hs_thrust_2_nom;
hs_thrust_3_up = thrust(hs_vel_pos / 1000, hs_vel_3 * (1 + 3*hs_dec)) - hs_thrust_3_nom;

hs_thrust_1_dn = hs_thrust_1_nom - thrust(hs_vel_pos / 1000, hs_vel_1 * (1 - 3*hs_dec));
hs_thrust_2_dn = hs_thrust_2_nom - thrust(hs_vel_pos / 1000, hs_vel_2 * (1 - 3*hs_dec));
hs_thrust_3_dn = hs_thrust_3_nom - thrust(hs_vel_pos / 1000, hs_vel_3 * (1 - 3*hs_dec));

figure
hold on
hs_thrust    = [hs_thrust_1_nom(end), hs_thrust_2_nom(end), hs_thrust_3_nom(end)];
hs_axial     = [4.0, 7.325, 10.5];
hs_thrust_up = [hs_thrust_1_up(end), hs_thrust_2_up(end), hs_thrust_3_up(end)];
hs_thrust_dn = [hs_thrust_1_dn(end), hs_thrust_2_dn(end), hs_thrust_3_dn(end)];

errorbar(hs_axial, hs_thrust, hs_thrust_dn, hs_thrust_up, 'Marker', '*')
xlabel('Axial position (inches)')
ylabel('Thrust (N)')
title('High rotational speed thrust at different axial positions with 3-\sigma error bars')
xlim([3 11])
ylim([8 12])
hold off

ls_thrust_1_nom = thrust(ls_vel_pos / 1000, ls_vel_1);
ls_thrust_2_nom = thrust(ls_vel_pos / 1000, ls_vel_2);
ls_thrust_3_nom = thrust(ls_vel_pos / 1000, ls_vel_3);

ls_thrust_1_up = thrust(ls_vel_pos / 1000, ls_vel_1 * (1 + 3*ls_dec)) - ls_thrust_1_nom;
ls_thrust_2_up = thrust(ls_vel_pos / 1000, ls_vel_2 * (1 + 3*ls_dec)) - ls_thrust_2_nom;
ls_thrust_3_up = thrust(ls_vel_pos / 1000, ls_vel_3 * (1 + 3*ls_dec)) - ls_thrust_3_nom;

ls_thrust_1_dn = ls_thrust_1_nom - thrust(ls_vel_pos / 1000, ls_vel_1 * (1 - 3*ls_dec));
ls_thrust_2_dn = ls_thrust_2_nom - thrust(ls_vel_pos / 1000, ls_vel_2 * (1 - 3*ls_dec));
ls_thrust_3_dn = ls_thrust_3_nom - thrust(ls_vel_pos / 1000, ls_vel_3 * (1 - 3*ls_dec));

figure
hold on
ls_thrust    = [ls_thrust_1_nom(end), ls_thrust_2_nom(end), ls_thrust_3_nom(end)];
ls_axial     = [4.0, 7.325, 10.5];
ls_thrust_up = [ls_thrust_1_up(end), ls_thrust_2_up(end), ls_thrust_3_up(end)];
ls_thrust_dn = [ls_thrust_1_dn(end), ls_thrust_2_dn(end), ls_thrust_3_dn(end)];

errorbar(ls_axial, ls_thrust, ls_thrust_dn, ls_thrust_up, 'Marker', '*', 'Color', 'r')
xlabel('Axial position (inches)')
ylabel('Thrust (N)')
title('Low rotational speed thrust at different axial positions with 3-\sigma error bars')
xlim([3 11])
ylim([2 4])
hold off

%% Power
power = @(pos, vel) pi * 1.225 * trapz(pos, vel.^3 .* pos);

hs_power_1_nom = power(hs_vel_pos / 1000, hs_vel_1);
hs_power_2_nom = power(hs_vel_pos / 1000, hs_vel_2);
hs_power_3_nom = power(hs_vel_pos / 1000, hs_vel_3);

hs_power_1_up = power(hs_vel_pos / 1000, hs_vel_1 * (1 + 3*hs_dec)) - hs_power_1_nom;
hs_power_2_up = power(hs_vel_pos / 1000, hs_vel_2 * (1 + 3*hs_dec)) - hs_power_2_nom;
hs_power_3_up = power(hs_vel_pos / 1000, hs_vel_3 * (1 + 3*hs_dec)) - hs_power_3_nom;

hs_power_1_dn = hs_power_1_nom - power(hs_vel_pos / 1000, hs_vel_1 * (1 - 3*hs_dec));
hs_power_2_dn = hs_power_2_nom - power(hs_vel_pos / 1000, hs_vel_2 * (1 - 3*hs_dec));
hs_power_3_dn = hs_power_3_nom - power(hs_vel_pos / 1000, hs_vel_3 * (1 - 3*hs_dec));

figure
hold on
hs_power    = [hs_power_1_nom, hs_power_2_nom, hs_power_3_nom];
hs_power_up = [hs_power_1_up, hs_power_2_up, hs_power_3_up];
hs_power_dn = [hs_power_1_dn, hs_power_2_dn, hs_power_3_dn];

errorbar(hs_axial, hs_power, hs_power_dn, hs_power_up, 'Marker', '*')
xlabel('Axial position (inches)')
ylabel('Power (W)')
title('High rotational speed power at different axial positions with 3-\sigma error bars')
xlim([3 11])
hold off

ls_power_1_nom = power(ls_vel_pos / 1000, ls_vel_1);
ls_power_2_nom = power(ls_vel_pos / 1000, ls_vel_2);
ls_power_3_nom = power(ls_vel_pos / 1000, ls_vel_3);

ls_power_1_up = power(ls_vel_pos / 1000, ls_vel_1 * (1 + 3*ls_dec)) - ls_power_1_nom;
ls_power_2_up = power(ls_vel_pos / 1000, ls_vel_2 * (1 + 3*ls_dec)) - ls_power_2_nom;
ls_power_3_up = power(ls_vel_pos / 1000, ls_vel_3 * (1 + 3*ls_dec)) - ls_power_3_nom;

ls_power_1_dn = ls_power_1_nom - power(ls_vel_pos / 1000, ls_vel_1 * (1 - 3*ls_dec));
ls_power_2_dn = ls_power_2_nom - power(ls_vel_pos / 1000, ls_vel_2 * (1 - 3*ls_dec));
ls_power_3_dn = ls_power_3_nom - power(ls_vel_pos / 1000, ls_vel_3 * (1 - 3*ls_dec));

figure
hold on
ls_power    = [ls_power_1_nom, ls_power_2_nom, ls_power_3_nom];
ls_power_up = [ls_power_1_up, ls_power_2_up, ls_power_3_up];
ls_power_dn = [ls_power_1_dn, ls_power_2_dn, ls_power_3_dn];

errorbar(ls_axial, ls_power, ls_power_dn, ls_power_up, 'Marker', '*', 'Color', 'r')
xlabel('Axial position (inches)')
ylabel('Power (W)')
title('Low rotational speed power at different axial positions with 3-\sigma error bars')
xlim([3 11])
hold off