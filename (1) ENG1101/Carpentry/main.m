clc, clear
a = [1, 0, -1; 2, -1, 3; 3, 0, 5];
b = [6; 3; 35];
solution = a\b

%problem 1
quantity = [1, 2, 1, 3];
[profit, wood, labor] = carpentry(quantity, 2.25, 8.5)

%problem 3 part 1
load('DataSet0.mat');
plot(current, voltage, 'o')
xlabel('Current (I) [amps]')
ylabel('Voltage (V) [volts]')
title('Experimental Power Analysis of an Electric Circuit')
grid on
hold on 
plot(13.5, 136, 'p')
hold off

%problem 3 part 2
hold on
load('Part2_datasets.mat')
semilogy(x1,y1, 'o')
xlabel('x2')
ylabel('y2 (on log scale)')
title('y2 versus x2 (semilogy plot)')
grid on

hold on 
plot(x3, y3, 'o')
xlabel('x3')
ylabel('y3')
title('y3 versus x3')
grid on
hold off

hold on 
loglog(x3, y3, 'o')
xlabel('log(x3)'), ylabel('y3'), title('y3 vs x3 (log log chart)')
grid on
hold off
