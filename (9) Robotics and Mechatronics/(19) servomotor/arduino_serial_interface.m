clear, clc, close all

serialportlist % To see what's up
arduino = serialport('COM7', 9600); % set the port

% Read the output line
readline(arduino)

% Write the pan tilt command
write(arduino, '-30 -30', 'char')