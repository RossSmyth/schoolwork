% Ross Smyth
% DSP Homework 7

clc, clear, close all

%% Setup Equation and IC
% Solves zero-input difference equations.

D = 400; % Adjusting this changes the frequency of the signal
A = 0.99; % Adjusts the volume and brightness of the sound. Set to 2 for your ears to bleed.

% Move the y's to the LHS
LHS = [1, (A/2 * -ones(1, D))];

IC = 2 * rand(1,D) - 1;

n = 44100;
%% Calculate output

% Setup output array with IC
out = [IC, zeros(1, n)];
i   = n + length(IC);

% Multiply the previous samples by the LHS coefficients. Then sum the results and divide by
% the coefficient on the y[n] term.
for i=(length(IC) + 1):i
    out(i) = 1 / LHS(1) * sum( out((i-1):-1:(i-length(IC))) .* LHS(2:end) );
end

% Remove IC from array
y = out(length(IC) + 1:end);

%% Generate outut files 

sound(y, 44100)

figure()
plot(0:99, y(1:100))
title('First 100 samples of synthesised guitar sound')
xlabel('n')
ylabel('Amplitude')
saveas(gcf, 'HW7_Smyth.png')

fs = 44100; % Hz, sampling rate
audiowrite('HW7_Smyth.wav', y, fs)