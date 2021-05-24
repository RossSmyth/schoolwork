%% Test Simulator Code
% Ross Smyth / Dr. Gordon Parker
% This script runs Euler, AB2, and RK4 integrators with three test systems.
% After the systems are simualted, they are plotted. One system has a known
% closed-form solution, and so the plots with it also include the
% close-form solution for validation of the integrators.

%%
% Cleanup
clearvars;
close all

%%
% Define the dynamic system model
% x' = f1(x,u,t) where f1 and u1(t) are MATLAB functions
% y1(x,u,t) is also a MATLAB function 
s1 = {@f1,@y1,@u1,2.0};
s2 = {@f2,@y2,@u2,[0, 0]};
s3 = {@f3,@y3,@u3,[0, 0]};
 
% Validation data
validTime = 0:0.0001:2;
validData = 2 * exp(-4 * validTime); % Closed form solution.

%%
% Simulate the dynamic systems where the second and third arguments are the
% final time and time step respectively.

[OutE.s1.t,  OutE.s1.y,  OutE.s1.u]     = mySim(s1, 2.0, 0.05, 'euler');
[OutAB.s1.t, OutAB.s1.y, OutAB.s1.u]    = mySim(s1, 2.0, 0.05, 'ab2');
[OutRK4.s1.t, OutRK4.s1.y, OutRK4.s1.u] = mySim(s1, 2.0, 0.05, 'rk4');

[OutE.s2.t,  OutE.s2.y,  OutE.s2.u]     = mySim(s2, 10, 0.005, 'euler');
[OutAB.s2.t, OutAB.s2.y, OutAB.s2.u]    = mySim(s2, 10, 0.005, 'ab2');
[OutRK4.s2.t, OutRK4.s2.y, OutRK4.s2.u] = mySim(s2, 10, 0.005, 'rk4');


[OutE.s3.t,  OutE.s3.y,  OutE.s3.u]     = mySim(s3, 50, 0.01, 'euler');
[OutAB.s3.t, OutAB.s3.y, OutAB.s3.u]    = mySim(s3, 50, 0.01, 'ab2');
[OutRK4.s3.t, OutRK4.s3.y, OutRK4.s3.u] = mySim(s3, 50, 0.01, 'rk4');

OutE.s2.y   = OutE.s2.y(:, 1); % Only look at position, as if it's correct the derivitive will be as well.
OutAB.s2.y  = OutAB.s2.y(:, 1); 
OutRK4.s2.y = OutRK4.s2.y(:, 1); 

OutE.s3.y   = OutE.s3.y(:, 1); % Only look at position, as if it's correct the derivitive will be as well.
OutAB.s3.y  = OutAB.s3.y(:, 1); 
OutRK4.s3.y = OutRK4.s3.y(:, 1); 

%% Plot the validated system with the known data.
expo = '$\dot{x} = -4x, \; x(0) = 2$';

h = plotData(OutE.s1, expo, 'Euler');
hold on
plot(validTime, validData)
legend('y', 'u', 'Closed-form Solution')
hold off

h = plotData(OutAB.s1, expo, 'AB2');
hold on
plot(validTime, validData)
legend('y', 'u', 'Known Solution')
hold off

h = plotData(OutRK4.s1, expo, 'RK4');
hold on
plot(validTime, validData)
legend('y', 'u', 'Known Solution')
hold off

%% Plot the other systems.
msd = '$m\ddot{w}+c\dot{w}+30+3\sin\left(2\pi{}t\right)w = 100\sin\left(8\pi{}t\right), \: w(0) = 0, \; \dot{w} = 0$';
% Plot mass-spring-damper
h = plotData(OutE.s2, msd, 'Euler');
h = plotData(OutAB.s2, msd, 'AB2');
h = plotData(OutRK4.s2, msd, 'RK4');

vdp = '$m\ddot{w}+\mu(1-w^2)+w = 1.2\sin\left(0.2\pi{}t\right), \: w(0) = 0, \; \dot{w} = 0$';
% Plot Van de Pol Oscillator

h = plotData(OutE.s3, vdp, 'Euler');
h = plotData(OutAB.s3, vdp, 'AB2');
h = plotData(OutRK4.s3, vdp, 'RK4');

%% Helper Functions

function h = plotData(dat, equation, integrator)
% dat is assumed to be a structure with fields: t, y, and u. The function
% returns a handle to the figure
  FS = 14; % font size
  LW =  2; % line width
  figs =  findobj('type','figure'); % find all the open figures
  id = length(figs) + 1; % create an id for this fig

  h.fig   = figure(id); % create figure
  h.axs   = axes;       % create axes
  [x,y] =   stairs(dat.t,dat.y); % create stair data
  h.ln(1) = line(x,y,'Color','k'); % plot the stair data
  [x,y] =   stairs(dat.t,dat.u);
  h.ln(2) = line(x,y,'Color','b');

  h.xlb   = xlabel('Time (s)');
  h.ylb   = ylabel('In and Out');
  h.ttl   = title({equation, integrator});
  h.leg   = legend('y','u');
  grid;
  h.axs.FontWeight  = 'Bold';
  h.axs.FontSize    = FS;
  for i=1:length(h.ln)
    h.ln(i).LineWidth = LW;
  end
  h.ttl.Interpreter = 'LaTeX';

end
