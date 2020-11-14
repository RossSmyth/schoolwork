clear, clc, close all

man1 = readtable("BCB_1.txt");
man2 = readtable("BCB_2.txt");
man3 = readtable("BCB_3.txt");
man4 = readtable("BCB_4.txt");
man5 = readtable("BCB_5.txt");
man6 = readtable("BCB_6.txt");
man7 = readtable("BCB_7.txt");
man8 = readtable("BCB_8.txt");
%%
figure
hold on
plot(man1{:, 1} / 1000, man1{:, 2})
plot(man2{:, 1} / 1000, man2{:, 2})
plot(man3{:, 1} / 1000, man3{:, 2})
plot(man4{:, 1} / 1000, man4{:, 2})
plot(man5{:, 1} / 1000, man5{:, 2})
plot(man6{:, 1} / 1000, man6{:, 2})
plot(man7{:, 1} / 1000, man7{:, 2})
plot(man8{:, 1} / 1000, man8{:, 2})
grid on
xlabel('Time (s)')
ylabel('Altitude (m)')
legend('Manuver 1', 'Manuver 2', 'Manuver 3', 'Manuver 4', 'Manuver 5', 'Manuver 6', 'Manuver 7', 'Manuver 8')
hold off
%%
figure
hold on
plot(man1{:, 1} / 1000, cumsum(man1{:, 3} .* man1{:, 4}))
plot(man2{:, 1} / 1000, cumsum(man2{:, 3} .* man2{:, 4}))
plot(man3{:, 1} / 1000, cumsum(man3{:, 3} .* man3{:, 4}))
plot(man4{:, 1} / 1000, cumsum(man4{:, 3} .* man4{:, 4}))
plot(man5{:, 1} / 1000, cumsum(man5{:, 3} .* man5{:, 4}))
plot(man6{:, 1} / 1000, cumsum(man6{:, 3} .* man6{:, 4}))
plot(man7{:, 1} / 1000, cumsum(man7{:, 3} .* man7{:, 4}))
plot(man8{:, 1} / 1000, cumsum(man8{:, 3} .* man8{:, 4}))
grid on
xlabel('Time (s)')
ylabel('Energy (J)')
legend('Manuver 1', 'Manuver 2', 'Manuver 3', 'Manuver 4', 'Manuver 5', 'Manuver 6', 'Manuver 7', 'Manuver 8')
hold off
%%
figure

c = 23.595854405907037; % not used because memes, instead 20.093 from slides

hold on
energy = @(f, t) 20.093 * 12.06 * (1 * 1.23 / f / t + t); % From slides, uses meme C

colormap(jet)
hfc = fcontour(energy, [4, 7, 0.3, 0.7]);
[m, c1] = contour(hfc.XData, hfc.YData, hfc.ZData, 'ShowText','on');
clabel(m, c, 'BackgroundColor', [1, 1, 1])

caxis([110 320]);
xlabel('Force Amplitude (N)')
ylabel('Thrust Time (sec)')
grid on

hfc = fcontour(@(f, t) 1 * 1.23 / f / t - t, [4, 7, 0.3, 0.7], 'LevelList', [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7]);
[m, c2] = contour(hfc.XData, hfc.YData, hfc.ZData, 'LevelList', [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7], 'LineColor', 'black');
clabel(m, c, 'BackgroundColor', [1, 1, 1])

l = xline(5.93, '--', 'F = 5.94 N', 'LineWidth', 2, 'DisplayName', 'F = 5.94 N', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'middle');

s = scatter([5.94, 5.5, 5.7, 4.7, 5.4, 4, 4, 4.9], [0.5, 0.5, 0.45, 0.5, 0.4, 0.4, 0.4, 0.35], 'X');
legend([c1, c2, l, s], 'Energy (J)', 'Coast Time (s)', 'Min. Force', 'Test Points')

%% 
% coast_time = @(f, t) t - 1 * 1.23 / f / t;
% energy = @(f, t) 20.093 * 12.06 * (1 * 1.23 / f / t + t);

[op_force, op_energy, exit_flag] = fmincon(@energy_fun, [5.94, 0.45], [], [], [], [], [0, 0], [5.94, inf], @coast_time)