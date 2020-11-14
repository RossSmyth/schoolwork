clear, clc, close all

%% Stand Calibration

[thrust_calV, thrust_calF] = readvars('thrust calibration.txt');
[torque_calV, torque_calF] = readvars('torque_calibration_2in_moment_arm.txt');

torque_calM = torque_calF * 2 * 2.54 * 10;

thrust_cal = polyfit(thrust_calV, thrust_calF, 1);
torque_cal = polyfit(torque_calV, torque_calM, 1);

thrust = fitlm(thrust_calV, thrust_calF, 'linear');
torque = fitlm(torque_calV, torque_calM, 'linear');

figure
plot(thrust)
xlabel('Measured Voltage (mV)')
ylabel('Force on Thrust Stand (N)')
title('Thrust Stand Calibration')
legend('Measured Data', 'Linear Regression', '95% Confidence Bounds')
text(0.36, 9, sprintf('F = %2.1f * V + %2.3g', thrust.Coefficients.Estimate(2), thrust.Coefficients.Estimate(1)))
text(0.36, 8, sprintf('R^2 = %.3g', thrust.Rsquared.Adjusted))

figure
plot(torque)
xlabel('Measured Voltage (mV)')
ylabel('Torque on Stand (mN-m)')
title('Moment Stand Calibration')
legend('Measured Data', 'Linear Regression', '95% Confidence Bounds')
text(1.2, 300, sprintf('M = %2.1f * V + %2.3g', torque.Coefficients.Estimate(2), torque.Coefficients.Estimate(1)))
text(1.2, 275, sprintf('R^2 = %.4g', torque.Rsquared.Adjusted))

%% Thrust Analysis

[t_time, t_volt, t_speed] = readvars('thrust acquisition.txt');
t_time                    = t_time / 1000;
t_speed                   = t_speed * 1000;

t_speed = t_speed(1:find(t_time >= 19.0037,1));
t_volt  = t_volt(1:find(t_time >= 19.0037,1));
t_time  = t_time(1:find(t_time >= 19.0037,1));

t_thrust = predict(thrust, t_volt);
t_pulse  = linspace(1,2, length(t_time(1:find(t_time >= 18.402,1))));

pulse_thrust = fitlm(t_pulse, t_thrust(1:find(t_time >= 18.402,1)), 'quadratic');

figure
hold on
plot(pulse_thrust)
plot([1.36, 1.75], [2.65, 10.4], 'r*')
xlabel('Pulse Width (ms)')
ylabel('Thrust (N)')
title('Pulse Width vs. Thrust')
text(1.2, 10, sprintf('F = %2.1f * W^2 + %2.3g * W + %2.3g', pulse_thrust.Coefficients.Estimate(3), pulse_thrust.Coefficients.Estimate(2), pulse_thrust.Coefficients.Estimate(1)))
text(1.2, 9, sprintf('R^2 = %.4g', pulse_thrust.Rsquared.Adjusted))
legend('Measured Data', 'Quadratic Regression', '95% Confidence Interval', '', 'Data measured from air speed')
hold off

%% Electrical Power Analysis

[m_time, m_voltm, m_speed, m_volt, m_curr] = readvars('torque acquisition.txt');

m_time   =  m_time / 1000;
m_torque = predict(torque, m_voltm);
m_speed  = m_speed * 1000;
m_power  = m_volt .* m_curr;

m_time   = m_time(1:find(m_power >= 300, 1));
m_torque = m_torque(1:find(m_power >= 300, 1));
m_speed  = m_speed(1:find(m_power >= 300, 1));
m_power  = m_power(1:find(m_power >= 300, 1));

m_pulse     = linspace(1, 2, length(m_time(1:29351)));
pulse_power = fitlm(m_pulse, m_power(1:29351), 'quadratic');    

fig = figure;
hold on
plot(pulse_power)
xlabel('Pulse Width (ms)')
ylabel('Power (W)')
title('Pulse Width vs. Electrical Power')
text(1.2, 150, sprintf('P = %2.1f * W^2 + %2.3g * W + %2.3g', pulse_power.Coefficients.Estimate(3), pulse_power.Coefficients.Estimate(2), pulse_power.Coefficients.Estimate(1)))
text(1.2, 130, sprintf('R^2 = %.4g', pulse_thrust.Rsquared.Adjusted))
legend('Measured Data', 'Quadratic Regression', '95% Confidence Interval')
hold off

%% Efficiency Analysis
m_torque = m_torque - min(m_torque);
m_mpow = (m_torque / 1000) .* (m_speed / 60 * 2 * pi);
m_mpow = m_mpow(1:29351);

figure
plot(m_pulse,m_mpow ./ m_power(1:29351))
yyaxis left
xlabel('Pulse Width (ms)')
ylabel('Power Efficiency')
title('Pulse Width vs. Power Efficiency and Mechanical Power')
yyaxis right
plot(m_pulse, m_mpow, [1.36, 1.75], [9.97, 77.2], 'g*')
ylabel('Mechanical Power (W)')
legend('Efficiency', 'Mechanical Power', 'Air measured power')
%% Manufacturer Specification Comparison
man_rpm = [2, 3, 4, 5, 6, 7, 8] * 1000;
man_pow = [0.004, 0.014, 0.033, 0.063, 0.108, 0.178, 0.276] * 745.7;
man_tor = [0.129, 0.292, 0.515, 0.795, 1.132, 1.601, 2.177] * 0.112985 * 1000;
man_thr = [0.179, 0.406, 0.721, 1.128, 1.624, 2.212, 2.903] * 4.44822;

figure
subplot(3, 1, 1)
plot(man_rpm, man_pow, m_speed(1:29351), m_mpow)
title('Manufacture Specification vs. Measured Values')
ylabel('Mechanical Power (W)')
xlabel('Propeller Speed (RPM)')
legend('Manufacturer', 'Measured')
subplot(3, 1, 2)
plot(man_rpm, man_tor, m_speed, m_torque)
ylabel('Torque (mN-m)')
xlabel('Propeller Speed (RPM)')
legend('Manufacturer', 'Measured')
subplot(3, 1, 3)
plot(man_rpm, man_thr, t_speed, t_thrust)
ylabel('Thrust (N)')
xlabel('Propeller Speed (RPM)')
legend('Manufacturer', 'Measured')