clear, clc, close all
%% Feedforward, no PID; No
ff1 = readtable("FF_1.txt");
ff2 = readtable("FF_2.txt");
ff3 = readtable("FF_3.txt");
ff4 = readtable("FF_4.txt");

figure
hold on
yline(1);
plot(ff1{:, 1}, ff1{:, 3} - ff1{1, 3})
plot(ff2{:, 1}, ff2{:, 3} - ff2{1, 3})
plot(ff3{:, 1}, ff3{:, 3} - ff3{1, 3})
plot(ff4{:, 1}, ff4{:, 3} - ff4{1, 3})

ylabel('Altitude (m)')
xlabel('Time (s)')
title('12.65 N Bicopter Feedforward Control Test')

legend('1 meter (target)', 't_f = 0.46 N, F_A = 5.94 N, t_C = 0', 't_F = 0.4 N, F_A = 5.7 N, t_C = 0.13 s', 't_F = 0.45 N, F_A = 4.7 N, t_C = 0.13', 't_F = 0.35 N, F_A = 4 N, t_C = 0.533') 
hold off

%% Feedforward, PID
fffb1 = readtable("FF_FB_1.txt");
fffb2 = readtable("FF_FB_2.txt");
fffb3 = readtable("FF_FB_3.txt");
fffb4 = readtable("FF_FB_4.txt");


figure
hold on
yline(1);
plot(fffb1{:, 1}, fffb1{:, 3} - fffb1{1, 3})
plot(fffb2{:, 1}, fffb2{:, 3} - fffb2{1, 3})
plot(fffb3{:, 1}, fffb3{:, 3} - fffb3{1, 3})
plot(fffb4{:, 1}, fffb4{:, 3} - fffb4{1, 3})

ylabel('Altitude (m)')
xlabel('Time (s)')
title('12.65 N Bicopter Feedforward & Feedback Control Test')

legend('1 meter (target)', 'K_p = 0.2, K_i = 0.1, K_d = 0.1', 'K_p = 0.4, K_i = 0.1, K_d = 0.1', 'K_p = 0.4, K_i = 0.15, K_d = 0.1', 'K_p = 0.4, K_i = 0.15, K_d = 0.15') 
hold off

%% PID
pid1 = readtable("PID_1.txt");
pid2 = readtable("PID_2.txt");
pid3 = readtable("PID_3.txt");
pid4 = readtable("PID_4.txt");


figure
hold on
yline(1);
plot(pid1{149:end, 1} - pid1{149, 1}, pid1{149:end, 3} - pid1{1, 3})
plot(pid2{186:end, 1} - pid2{186, 1}, pid2{186:end, 3} - pid2{1, 3})
plot(pid3{101:end, 1} - pid3{101, 1}, pid3{101:end, 3} - pid3{1, 3})
plot(pid4{127:end, 1} - pid4{127, 1}, pid4{127:end, 3} - pid4{1, 3})

ylabel('Altitude (m)')
xlabel('Time (s)')
title('12.65 N Bicopter Feedback Control Test')

legend('1 meter (target)', 'K_p = 0.2, K_i = 0.1, K_d = 0.1', 'K_p = 0.4, K_i = 0.1, K_d = 0.1', 'K_p = 0.4, K_i = 0.15, K_d = 0.1', 'K_p = 0.4, K_i = 0.15, K_d = 0.15') 
hold off

%% S-track
st1 = readtable("S-track_1.txt");
st2 = readtable("S-track_2.txt");
st3 = readtable("S-track_3.txt");
st4 = readtable("S-track_4.txt");


figure
hold on
yline(1);
plot(st1{:, 1}, st1{:, 3} - st1{1, 3})
plot(st2{:, 1}, st2{:, 3} - st2{1, 3})
plot(st3{:, 1}, st3{:, 3} - st3{1, 3})
plot(st4{:, 1}, st4{:, 3} - st4{1, 3})

ylabel('Altitude (m)')
xlabel('Time (s)')
title('12.65 N Bicopter S-Track Control Test')

legend('1 meter (target)', 'K_p = 0.2, K_i = 0.1, K_d = 0.1', 'K_p = 0.4, K_i = 0.1, K_d = 0.1', 'K_p = 0.4, K_i = 0.15, K_d = 0.1', 'K_p = 0.4, K_i = 0.15, K_d = 0.15') 
hold off

%% Ki Stability

ki = readtable('Ki_stability.txt');

figure 
hold on
plot(ki{:, 1}, ki{:, 3} - ki{1, 3}, ki{:, 1}, ki{:, 2})

ylabel('Altitude (m)')
xlabel('Time (s)')
title('Copter K_i Stability Test')

legend('K_p = 0.20, K_i = 1.05, K_d = 0.10', 'Target (1 m)')

hold off

cki = @(x, x1, x2, x3) 3*(840*x+160*x1+80*x2+41*x3) /100 ./ x2;

ki_x1 = diff(ki{:, 3}) ./ diff(ki{:, 1});
ki_x2 = diff(ki{:, 3}, 2) ./ diff(ki{:, 1}, 2);
ki_x3 = diff(ki{:, 3}, 3) ./ diff(ki{:, 1}, 3);

ki_c = cki(ki{1:end-3, 3} - ki{1, 3}, ki_x1(1:end-2), ki_x2(1:end-1), ki_x3)

%% Kp stability

kp = readtable('Kp_stability.txt');

figure 
hold on
plot(kp{:, 1}, kp{:, 3} - kp{1, 3}, kp{:, 1}, kp{:, 2})
ylim([-inf 1.2])

ylabel('Altitude (m)')
xlabel('Time (s)')
title('Copter K_p Stability Test')

legend('K_p = 0.004, K_i = 0.10, K_d = 0.10', 'Target (1 m)')

hold off

%% viscous damping

cki = @(x, x1, x2, x3) 3*(840*x+160*x1+80*x2+41*x3) /100 ./ x2;

ki_x1 = diff(ki{:, 3}) ./ diff(ki{:, 1});
ki_x2 = diff(ki{:, 3}, 2) ./ diff(ki{:, 1}, 2);
ki_x3 = diff(ki{:, 3}, 3) ./ diff(ki{:, 1}, 3);

ki_c = cki(ki{1:end-3, 3} - ki{1, 3}, ki_x1(1:end-2), ki_x2(1:end-1), ki_x3);


ckp = @(x, x1, x2, x3) 3 * (400 * x + 16 * x1 + 400 * x2 + 205 * x3) / 500 ./ x2;

kp_x1 = diff(kp{:, 3}) ./ diff(kp{:, 1});
kp_x2 = diff(kp{:, 3}, 2) ./ diff(kp{:, 1}, 2);
kp_x3 = diff(kp{:, 3}, 3) ./ diff(kp{:, 1}, 3);

kp_c = cki(kp{1:end-3, 3} - kp{1, 3}, kp_x1(1:end-2), kp_x2(1:end-1), kp_x3);

[label1{1:length(kp_c)}] = deal('Kp Data')
[label2{1:length(ki_c)}] = deal('Ki Data')
label = [label1, label2]

figure
hold on
boxplot([kp_c; ki_c], label, 'Orientation', 'horizontal')
xlim([-50 50])

xline(median([kp_c; ki_c]))

title('Distribution of Viscous Friction Coefficeients')
hold off