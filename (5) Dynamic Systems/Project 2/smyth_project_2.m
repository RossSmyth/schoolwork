clear, clc, close all
% Ross Smyth
% 2/26/2019
% Dynamic System Project 2

k     = 19990; % N/m
m     = 23; % kg
nat_f = sqrt(k/m); % rad/s
syms t s
zero_cross = @(v) find(v(:).*circshift(v(:), [-1 0]) <= 0);
%% 2. No damping
x0       = 0.01; % Simulink initial condition
c        = 0; % for simulink
run_case = 1; % simulink external force case

sim2 = sim('springmassdamper.slx');

ss2              = ss([0, 1; -k/m, -c/m], [0; 1/m], [1, 0; 0, 1], [0; 0]);
[ss2_out, ss2_t] = initial(ss2, [x0; 0], 5);
ss2_dis          = ss2_out(:, 1);

fun2 = 0.01 * cos(nat_f * t);

figure
fplot(fun2, [0, 5])
title("Undamped spring-mass system")
xlabel("Time (s)")
ylabel("Displacement (m)")
hold on
plot(sim2.tout, sim2.displacement, 'r--', ss2_t, ss2_dis, 'bo')
legend('Closed form solution', 'Simulink Solution', 'State-Space Solution')
hold off

mf2 = 2 * pi /(2 * mean(diff( sim2.tout(zero_cross(sim2.displacement)))));

%% 3. 5% Damping
c     = 2 * m * nat_f * 0.05;
nat_d = sqrt(1 - 0.05^2) * nat_f;
time3  = 1 / (nat_f * 0.05);

sim3 = sim('springmassdamper.slx');

ss3              = ss([0, 1; -k/m, -c/m], [0; 1/m], [1, 0; 0, 1], [0; 0]);
[ss4_out, ss3_t] = initial(ss3, [x0; 0], 5);
ss3_dis          = ss4_out(:, 1);

fun3 = exp(-0.05 * nat_f * t)* 0.01 * (cos(nat_d * t) + 0.05 * 0.01 / sqrt(1-0.05) * sin(nat_f * t));

figure
fplot(fun3, [0, 5])

hold on
plot(sim3.tout, sim3.displacement, '--', ss3_t, ss3_dis, 'b.')
xline(time3)
hold off
title("5% Damped spring-mass-damper with 10 mm X_o")
xlabel("Time (s)")
ylabel("Displacement (m)")
legend('Close-form spring-mass-damper', 'Simulink solution', 'State-space solution', 'Time-constant')

mf3 = 2 * pi /(2 * mean(diff( sim3.tout(zero_cross(sim3.displacement)))));

%% 4 10N Step
run_case = 2;
x0       = 0;

fun4  = 10 / (m * nat_f^2) * (1 - 1 / sqrt(1 - 0.05^2) * exp(-0.05 * nat_f * t) * sin((nat_f * sqrt(1 - 0.05^2) * t + atan(sqrt(1 - 0.05^2) / 0.05))));
time4 = 1/(0.05 * nat_f);

ss4_step         = stepDataOptions('StepAmplitude', 10);
[ss4_out, ss4_t] = step(ss3, 5, ss4_step);
ss4_dis          = ss4_out(:, 1);

sim4 = sim('springmassdamper.slx');

figure
fplot(fun4, [0, 5])

hold on
plot(sim4.tout, sim4.displacement, '--', ss4_t, ss4_dis, 'b.')
yline(10/k,'--');
xline(time4);
hold off
title("5% Damped spring-mass-damper with 10N step")
xlabel("Time (s)")
ylabel("Displacement (m)")
legend('Close-form spring-mass-damper', 'Simulink Solution', 'State-space solution', 'Steady-state value', 'Time-constant')

mf4      = 2 * pi /(2 * mean(diff( sim4.tout(zero_cross(sim4.displacement)))));
err4_ss  = (mean(ss4_dis) - 5e-4) / 5e-4 * 100;
err4_sim = (mean(sim4.displacement) - 5e-4) / 5e-4 * 100;
%% 5 5N sine wave, 50% natrual frequency
run_case = 3;

f5 = nat_f * 0.5;

sim5 = sim('springmassdamper.slx');

ss5_t   = 0:0.001:5;
ss5_out = lsim(ss3, 5 * sin(f5 * ss5_t), ss5_t);
ss5_dis          = ss5_out(:, 1);

fun5 = (-5/225887).*(cos((9995/46).^(1/2).*t)+(-15).*sin((9995/46).^(1/2).*t))+(5/225887).*399.^(-1/2).*exp(1).^((-1/2).*(1999/230).^(1/2).*t).*(399.^(1/2).*cos((1/2).*(797601/230).^(1/2).*t)+(-149).*sin((1/2).*(797601/230).^(1/2).*t));

mf5 = diff(sim5.tout(zero_cross(sim5.displacement)));
mf5 = 2 * pi /(2 * mean(mf5(end-5)));

%% 6 5N sine wave, 90% natrual frequency
run_case = 4;

f6 = nat_f * 0.9;

sim6 = sim('springmassdamper.slx');

ss5_t   = 0:0.001:5;
ss6_out = lsim(ss3, 5 * sin(f6 * ss5_t), ss5_t);
ss6_dis          = ss6_out(:, 1);


fun6 = (-25/441779).*(9.*cos(9.*(1999/230).^(1/2).*t)+(-19).*sin(9.*(1999/230).^(1/2).*t))+(75/441779).*(3/133).^(1/2).*exp(1).^((-1/2).*(1999/230).^(1/2).*t).*(399.^(1/2).*cos((1/2).*(797601/230).^(1/2).*t)+(-37).*sin((1/2).*(797601/230).^(1/2).*t));

mf6 = diff(sim6.tout(zero_cross(sim6.displacement)));
mf6 = 2 * pi /(2 * mean(mf6(end-5)));

%% 7 5N sine wave, 130% natrual frequency
run_case = 5;

f7 = 1.3 * nat_f;

sim7 = sim('springmassdamper.slx');

ss5_t   = 0:0.001:5;
ss7_out = lsim(ss3, 5 * sin(f7 * ss5_t), ss5_t);
ss7_dis = ss7_out(:, 1);

fun7 = (-5/985507).*(13.*cos(13.*(1999/230).^(1/2).*t)+69.*sin(13.*(1999/230).^(1/2).*t))+(65/985507).*399.^(-1/2).*exp(1).^((-1/2).*(1999/230).^(1/2).*t).*(399.^(1/2).*cos((1/2).*(797601/230).^(1/2).*t)+139.*sin((1/2).*(797601/230).^(1/2).*t));

mf7 = diff(sim7.tout(zero_cross(sim7.displacement)));
mf7 = 2 * pi /(2 * mean(mf7(end-5)));

figure
hold on
fplot(fun5, [0, 5])
fplot(fun6, [0, 5])
fplot(fun7, [0, 5])

plot(sim5.tout, sim5.displacement, '--', sim6.tout, sim6.displacement, '--', sim7.tout, sim7.displacement, '--')
plot(ss5_t, ss5_dis, '.', ss5_t, ss6_dis, '.', ss5_t, ss7_dis, '.')

legend('50% \omega_n closed-form', '90% \omega_n closed-form', '130% \omega_n closed-form', '50% Simulink', '90% Simulink', '130% Simulink', '50% State-space', '90% State-space', '130% State-space')
hold off
xlabel('Time (s)')
ylabel('Dispalcement (m)')
title('5N peak sine wave force input at different frequencies')