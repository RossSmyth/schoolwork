clear, clc, close all
% Ross Smyth
% 2/12/2019
% Dynamic System Project 1

% Some functions don't work on all systems (ilaplace) due to custom
% functions and different versions

k     = 19990; % N/m
m     = 23; % kg
nat_f = sqrt(k/m); % rad/s
syms t s
zero_cross = @(v) find(v(:).*circshift(v(:), [-1 0]) <= 0);

%% 2. No damping
fun2 = 0.01 * cos(nat_f * t);

[t2, d2] = data_import('part_2.data');

figure
fplot(fun2, [0, 5])
title("Undamped spring-mass system")
xlabel("Time (s)")
ylabel("Displacement (m)")
hold on
plot(t2, d2, '--')
legend('Closed form solution', 'AMESim Solution')
hold off

mf2 = 2 * pi /(2 * mean(diff( t2(zero_cross(d2)))));

%% 3. 5% Damping
c     = 2 * m * nat_f * 0.05;
nat_d = sqrt(1 - 0.05^2) * nat_f;
time3  = 1 / (nat_f * 0.05);

[t3, d3] = data_import('part_3.data');

fun3 = exp(-0.05 * nat_f * t)* 0.01 * (cos(nat_d * t) + 0.05 * 0.01 / sqrt(1-0.05) * sin(nat_f * t));
figure
fplot(fun3, [0, 5])
hold on
plot(t3, d3, '--')
xline(time3)
hold off
title("Closed form solution of 5% Damped spring-mass-damper with 10 mm X_o")
xlabel("Time (s)")
ylabel("Displacement (m)")
legend('Close-form spring-mass-damper', 'AMESim solution', 'Time-constant')

mf3 = 2 * pi /(2 * mean(diff( t3(zero_cross(d3)))));

%% 4 10N Step
fun4  = 10 / (m * nat_f^2) * (1 - 1 / sqrt(1 - 0.05^2) * exp(-0.05 * nat_f * t) * sin((nat_f * sqrt(1 - 0.05^2) * t + atan(sqrt(1 - 0.05^2) / 0.05))));
time4 = 1/(0.05 * nat_f);

[t4, d4] = data_import('part_4.data');

figure
fplot(fun4, [0, 5])
hold on
plot(t4, d4, '--')
yline(10/k,'--')
xline(time4)
hold off
title("Closed form solution of 5% Damped spring-mass-damper with 10N step")
xlabel("Time (s)")
ylabel("Displacement (m)")
legend('Close-form spring-mass-damper', 'AMESim Solution', 'Steady-state value', 'Time-constant')

mf4 = 2 * pi /(2 * mean(diff( t4(zero_cross(d4)))));

%% 5 5N sine wave, 50% natrual frequency
f5 = nat_f * 0.5;

[t5, d5] = data_import('part_5.data');

fun5 = (-5/225887).*(cos((9995/46).^(1/2).*t)+(-15).*sin((9995/46).^(1/2).*t))+(5/225887).*399.^(-1/2).*exp(1).^((-1/2).*(1999/230).^(1/2).*t).*(399.^(1/2).*cos((1/2).*(797601/230).^(1/2).*t)+(-149).*sin((1/2).*(797601/230).^(1/2).*t));

mf5 = diff(t5(zero_cross(d5)));
mf5 = 2 * pi /(2 * mean(mf5(end-5)));

%% 6 5N sine wave, 90% natrual frequency
f6 = nat_f * 0.9;

[t6, d6] = data_import('part_6.data');

fun6 = (-25/441779).*(9.*cos(9.*(1999/230).^(1/2).*t)+(-19).*sin(9.*(1999/230).^(1/2).*t))+(75/441779).*(3/133).^(1/2).*exp(1).^((-1/2).*(1999/230).^(1/2).*t).*(399.^(1/2).*cos((1/2).*(797601/230).^(1/2).*t)+(-37).*sin((1/2).*(797601/230).^(1/2).*t));

mf6 = diff(t6(zero_cross(d6)));
mf6 = 2 * pi /(2 * mean(mf6(end-5)));

%% 7 5N sine wave, 130% natrual frequency
f7 = 1.3 * nat_f;

[t7, d7] = data_import('part_7.data');

fun7 = (-5/985507).*(13.*cos(13.*(1999/230).^(1/2).*t)+69.*sin(13.*(1999/230).^(1/2).*t))+(65/985507).*399.^(-1/2).*exp(1).^((-1/2).*(1999/230).^(1/2).*t).*(399.^(1/2).*cos((1/2).*(797601/230).^(1/2).*t)+139.*sin((1/2).*(797601/230).^(1/2).*t));

mf7 = diff(t7(zero_cross(d7)));
mf7 = 2 * pi /(2 * mean(mf7(end-5)));

figure
hold on
fplot(fun5, [0, 5])
fplot(fun6, [0, 5])
fplot(fun7, [0, 5])

plot(t5, d5, '--', t6, d6, '--', t7, d7, '--')

legend('50% \omega_n closed-form', '90% \omega_n closed-form', '130% \omega_n closed-form', '50% AMESim', '90% AMESim', '130% AMESim')
hold off
xlabel('Time (s)')
ylabel('Dispalcement (m)')
title('5N peak sine wave force input at different frequencies with closed-form and AMESim solutions')
