clc, clear, close all

%% --------------------------- File Opening -------------------------------
one   = open('Run 1.mat');
two   = open('Run 2.mat');
three = open('Run 3.mat');
four  = open('Run 4.mat');
five  = open('Run 5.mat');
six   = open('Run 6.mat');

oneX = one.Signal.x_values.start_value:one.Signal.x_values.increment:(one.Signal.x_values.increment * one.Signal.x_values.number_of_values + one.Signal.x_values.start_value - one.Signal.x_values.increment);
oneY = one.Signal.y_values.values;

oneX = oneX(14:end); % Gets rid of bad initial values that don't mean anything
oneY = oneY(14:end) * 9.8;

twoX = two.Signal.x_values.start_value:two.Signal.x_values.increment:(two.Signal.x_values.increment * two.Signal.x_values.number_of_values + two.Signal.x_values.start_value - two.Signal.x_values.increment);
twoY = two.Signal.y_values.values * 9.8;

threeX = three.Signal.x_values.start_value:three.Signal.x_values.increment:(three.Signal.x_values.increment * three.Signal.x_values.number_of_values + three.Signal.x_values.start_value - three.Signal.x_values.increment);
threeY = three.Signal.y_values.values * 9.8;

threeX = threeX(15:end);
threeY = threeY(15:end);

fourX = four.Signal.x_values.start_value:four.Signal.x_values.increment:(four.Signal.x_values.increment * four.Signal.x_values.number_of_values + four.Signal.x_values.start_value - four.Signal.x_values.increment);
fourY = four.Signal.y_values.values * 9.8;

fourX = fourX(66:end);
fourY = fourY(66:end);

fiveX = five.Signal.x_values.start_value:five.Signal.x_values.increment:(five.Signal.x_values.increment * five.Signal.x_values.number_of_values + five.Signal.x_values.start_value - five.Signal.x_values.increment);
fiveY = five.Signal.y_values.values * 9.8;

fiveX = fiveX(19:end);
fiveY = fiveY(19:end);

sixX = six.Signal.x_values.start_value:six.Signal.x_values.increment:(six.Signal.x_values.increment * six.Signal.x_values.number_of_values + six.Signal.x_values.start_value - six.Signal.x_values.increment);
sixY = six.Signal.y_values.values * 9.8;

sixX = sixX(19:end);
sixY = sixY(19:end);

%% ------------------------ Spring Constant Fit ---------------------------
mass = [598, 337, 936]; % grams
disp = [-0.048, -0.029, -0.74]; %inches

force = mass / 1000 * 9.8; % newtons
disp  = disp * 2.54 / 100; % meters

stiff_fit = fit(disp', force', 'poly1'); % least squares fit of hooke's law
stiff     = coeffvalues(stiff_fit); 
stiff     = stiff(1); % Newtons/meter

figure
plot(stiff_fit, disp, force)
xlabel('Displacement (Meters))')
ylabel('Force (Newtons)')
title('Linear fit of spring stiffness')
text(-0.015, 9, sprintf('Fit spring constant: %.3g N/m', stiff))

%% ---------------------- First Run Processing ----------------------------

figure
plot(oneX, oneY)
title('No added mass, no damper, free vibration')
xlabel('Time (sec)')
ylabel('Acceleration (m/s^2)')

zCross = @(v) find(v(:) .* circshift(v(:), [-1 0]) <= 0); % Lambda that counts zero crosses

T = mean(diff(oneX(zCross(oneY(1:250))))) * 2; % Average time between zero-crosses (peroid of signal)
fEstimateOne = 1 / T; % Hz

pksOne = findpeaks(oneY, 'MinPeakHeight', 5, 'MinPeakProminence', 160); % Finds peaks for logarithmic descea=nt
pksOne = pksOne(2:end);

sigmaOne = 1./(1:length(pksOne) - 1)' .* log(pksOne(1)./pksOne(2:end)); % Mean for first part of descent
sigmaOne = mean(sigmaOne);

syms x
dampOne = solve(2*pi*x/sqrt(1-x^2) == sigmaOne, x); % Solves the descent
cOne = dampOne * 2 * sqrt(-stiff * 344/1000.);

% copied from mathworks
onef = fft(oneY);
one2 = onef/length(oneY);
one1 = one2(1:length(oneY)/2+1);
one1(2:end-1) = 2*one1(2:end-1);
onef = 1/one.Signal.x_values.increment*(0:(length(oneY)/2))/length(oneY);

% Plot the fourier transform
figure
semilogy(abs(onef), abs(one1))
xlabel('Frequency (Hz)')
ylabel('Acceleration (m/s^2)')
title('Fourier transform for system without extra mass and no damper')

% FRF I think
FRF = @(x, m, c) 1 ./ (-stiff - x.^2 * m + 1i*x*c);

oneFRF = FRF(linspace(0, 250, 1000), 344/1000, double(cOne));
figure
subplot(2, 1, 1)
semilogy(linspace(0, 250, 1000), abs(oneFRF))
title('Frequency Reponse for no added mass, no damper system')
ylabel('Displacement / Force (m/N)')
subplot(2, 1, 2)
plot(linspace(0, 250, 1000), phase(oneFRF) * 180 / pi)
xlabel('Frequency (Hz)')
ylabel('Phase (degrees)')

%%
figure
plot(twoX, twoY)
title('With camera mass, no damper, free vibration')
xlabel('Time (sec)')
ylabel('Acceleration (m/s^2)')

T = mean(diff(twoX(zCross(twoY(1:300))))) * 2; % Average time between zero-crosses (peroid of signal)
fEstimateTwo = 1 / T % Hz

pksTwo = findpeaks(twoY, 'MinPeakHeight', 5, 'MinPeakProminence', 30); % Finds peaks for logarithmic descea=nt
pksTwo = pksTwo(2:end);

sigmaTwo = 1./(1:length(pksTwo) - 1)' .* log(pksTwo(1)./pksTwo(2:end)); % Mean for first part of descent
sigmaTwo = mean(sigmaTwo);

syms x
dampTwo = solve(2*pi*x/sqrt(1-x^2) == sigmaTwo, x); % Solves the descent
cTwo = dampTwo * 2 * sqrt(-stiff * 344/1000.);

% copied from mathworks
twof = fft(twoY);
two2 = twof/length(twoY);
two1 = two2(1:length(twoY)/2+1);
two1(2:end-1) = 2*two1(2:end-1);
twof = 1/two.Signal.x_values.increment*(0:(length(twoY)/2))/length(twoY);

% fourier transform
figure
semilogy(abs(twof), abs(two1))
xlabel('Frequency (Hz)')
ylabel('Acceleration (m/s^2)')
title('Fourier transform for system with added camera mass and no damper')

% FRF I think
twoFRF = FRF(linspace(0, 250, 1000), (344+337)/1000, double(cTwo));
figure
subplot(2, 1, 1)
semilogy(linspace(0, 250, 1000), abs(twoFRF))
title('Frequency Reponse for added camera mass, no damper system')
ylabel('Displacement / Force (m/N)')
subplot(2, 1, 2)
plot(linspace(0, 250, 1000), phase(twoFRF) * 180 / pi)
xlabel('Frequency (Hz)')
ylabel('Phase (degrees)')

%%
figure
plot(threeX, threeY)
title('No added mass, light damper, free vibration')
xlabel('Time (sec)')
ylabel('Acceleration (m/s^2)')

T = mean(diff(threeX(zCross(threeY(1:300))))) * 2; % Average time between zero-crosses (peroid of signal)
fEstimatethree = 1 / T; % Hz

pksthree = findpeaks(threeY, 'MinPeakHeight', 5, 'MinPeakProminence', 190); % Finds peaks for logarithmic descea=nt
pksthree = pksthree(2:end);

sigmathree = 1./(1:length(pksthree) - 1)' .* log(pksthree(1)./pksthree(2:end)); % Mean for first part of descent
sigmathree = mean(sigmathree);

syms x
dampthree = solve(2*pi*x/sqrt(1-x^2) == sigmathree, x); % Solves the descent
cthree = dampthree * 2 * sqrt(-stiff * 344/1000.);

% copied from mathworks
threef = fft(threeY);
three2 = threef/length(threeY);
three1 = three2(1:length(threeY)/2+1);
three1(2:end-1) = 2*three1(2:end-1);
threef = 1/three.Signal.x_values.increment*(0:(length(threeY)/2))/length(threeY);

% Fourier transform
figure
semilogy(abs(threef), abs(three1))
xlabel('Frequency (Hz)')
ylabel('Accleration (m/s^2)')
title('Fourier transform for system without camera mass and light damper')

% FRF I think
threeFRF = FRF(linspace(0, 250, 1000), 344/1000, double(cthree));
figure
subplot(2, 1, 1)
semilogy(linspace(0, 250, 1000), abs(threeFRF))
title('Frequency Reponse for no added camera mass, light damper system')
ylabel('Displacement / Force (m/N)')
subplot(2, 1, 2)
plot(linspace(0, 250, 1000), phase(threeFRF) * 180 / pi)
xlabel('Frequency (Hz)')
ylabel('Phase (degrees)')

%%
figure
plot(fourX, fourY)
title('Added camera mass, light damper, free vibration')
xlabel('Time (sec)')
ylabel('Acceleration (m/s^2)')

T = mean(diff(fourX(zCross(fourY(1:300))))) * 2; % Average time between zero-crosses (peroid of signal)
fEstimatefour = 1 / T; % Hz

pksfour = findpeaks(fourY, 'MinPeakHeight', 50, 'MinPeakProminence', 200); % Finds peaks for logarithmic descea=nt
pksfour = pksfour(2:end);

sigmafour = 1./(1:length(pksfour) - 1)' .* log(pksfour(1)./pksfour(2:end)); % Mean for first part of descent
sigmafour = mean(sigmafour);

syms x
dampfour = solve(2*pi*x/sqrt(1-x^2) == sigmafour, x); % Solves the descent
cfour = dampfour * 2 * sqrt(-stiff * 344/1000.);

% copied from mathworks
fourf = fft(fourY);
four2 = fourf/length(fourY);
four1 = four2(1:length(fourY)/2+1);
four1(2:end-1) = 2*four1(2:end-1);
fourf = 1/four.Signal.x_values.increment*(0:(length(fourY)/2))/length(fourY);

% Fourier transform
figure
semilogy(abs(fourf), abs(four1))
xlabel('Frequency (Hz)')
ylabel('Acceleration (m/s^2)')
title('Fourier transform for system with added camera mass and light damper')

% FRF I think
fourFRF = FRF(linspace(0, 250, 1000), (344+337)/1000, double(cfour));
figure
subplot(2, 1, 1)
semilogy(linspace(0, 250, 1000), abs(fourFRF))
title('Frequency Reponse for added camera mass, light damper system')
ylabel('Displacement / Force (m/N)')
subplot(2, 1, 2)
plot(linspace(0, 250, 1000), phase(fourFRF) * 180 / pi)
xlabel('Frequency (Hz)')
ylabel('Phase (degrees)')

%%
figure
plot(fiveX, fiveY)
title('No added mass, heavy damper, free vibration')
xlabel('Time (sec)')
ylabel('Acceleration (m/s^2)')

T = mean(diff(fiveX(zCross(fiveY(1:300))))) * 2; % Average time between zero-crosses (peroid of signal)
fEstimatefive = 1 / T; % Hz

pksfive = findpeaks(fiveY, 'MinPeakHeight', 10, 'MinPeakProminence', 20); % Finds peaks for logarithmic descea=nt
pksfive = pksfive(2:end);

sigmafive = 1./(1:length(pksfive) - 1)' .* log(pksfive(1)./pksfive(2:end)); % Mean for first part of descent
sigmafive = mean(sigmafive);

syms x
dampfive = solve(2*pi*x/sqrt(1-x^2) == sigmafive, x); % Solves the descent
cfive = dampfive * 2 * sqrt(-stiff * 344/1000.);

% copied from mathworks
fivef = fft(fiveY);
five2 = fivef/length(fiveY);
five1 = five2(1:length(fiveY)/2+1);
five1(2:end-1) = 2*five1(2:end-1);
fivef = 1/five.Signal.x_values.increment*(0:(length(fiveY)/2))/length(fiveY);

% fourier transform
figure
semilogy(abs(fivef), abs(five1))
xlabel('Frequency (Hz)')
ylabel('Acceleration (m/s^2)')
title('fourier transform for system with no added camera mass and heavy damper')

% FRF I think
fiveFRF = FRF(linspace(0, 250, 1000), 344/1000, double(cfive));
figure
subplot(2, 1, 1)
semilogy(linspace(0, 250, 1000), abs(fiveFRF))
title('Frequency Reponse for no camera mass, heavy damper system')
ylabel('Displacement / Force (m/N)')
subplot(2, 1, 2)
plot(linspace(0, 250, 1000), phase(fiveFRF) * 180 / pi)
xlabel('Frequency (Hz)')
ylabel('Phase (degrees)')

%%
figure
plot(sixX, sixY)
title('Added camera mass, heavy damper, free vibration')
xlabel('Time (sec)')
ylabel('Acceleration (m/s^2)')

T = mean(diff(sixX(zCross(sixY(1:300))))) * 2; % Average time between zero-crosses (peroid of signal)
fEstimatesix = 1 / T; % Hz

pkssix = findpeaks(sixY, 'MinPeakHeight', 10, 'MinPeakProminence', 150); % Finds peaks for logarithmic descea=nt
pkssix = pkssix(2:end);

sigmasix = 1./(1:length(pkssix) - 1)' .* log(pkssix(1)./pkssix(2:end)); % Mean for first part of descent
sigmasix = mean(sigmasix);

syms x
dampsix = solve(2*pi*x/sqrt(1-x^2) == sigmasix, x); % Solves the descent
csix = dampsix * 2 * sqrt(-stiff * 344/1000.);

% copied from mathworks
sixf = fft(sixY);
six2 = sixf/length(sixY);
six1 = six2(1:length(sixY)/2+1);
six1(2:end-1) = 2*six1(2:end-1);
sixf = 1/six.Signal.x_values.increment*(0:(length(sixY)/2))/length(sixY);

% fourier transform
figure
semilogy(abs(sixf), abs(six1))
xlabel('Frequency (Hz)')
ylabel('Acceleration (m/s^2)')
title('fourier transform for system with added camera mass and heavy damper')

% FRF I think
sixFRF = FRF(linspace(0, 250, 1000), (344+337)/1000, double(csix));
figure
subplot(2, 1, 1)
semilogy(linspace(0, 250, 1000), abs(sixFRF))
title('Frequency Reponse for added camera mass, heavy damper system')
ylabel('Displacement / Force (m/N)')
subplot(2, 1, 2)
plot(linspace(0, 250, 1000), phase(sixFRF) * 180 / pi)
xlabel('Frequency (Hz)')
ylabel('Phase (degrees)')