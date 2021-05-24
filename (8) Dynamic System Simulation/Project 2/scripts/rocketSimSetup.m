%% Clean up
clearvars;
close('all');
Simulink.sdi.clear;

%% Indices
X  = 1;
Y  = 2;
XD = 3;
YD = 4;

%% Load Bus Defs
load('busDefs_Project2');

%% Open model
open_system('rocketSim');

%% Assign Constant Parmeters
% Planet
pln.g = 10; % grav accel (m/s^2)

% Rocket
rkt.m   = 1000;      % mass (kg)
rkt.ics = [0;0;0;0]; % initial conditions x,y,xd,yd
rkt.t1  = 5;         % burn time (sec)

% Thrust
thr.F = 15000; % thrust amplitude (N)
thr.tht = 56;  % thrust angle (deg)
thr.w   = 2*pi; % thrust angle frequency (rad/s)
thr.amp = 20; % amplitude of time varying component of thrust ang (deg)

% Solver
smp.h      = 1E-2; % time step (s)
smp.solTyp = 'Fixed-step';
smp.sol    = 'ode3';

% Variants
%   SCENARIO = 
%     1, constant thrust, constant angle
%     2, varying thrust, varying angle
CONST_F_VSS = Simulink.Variant('SCENARIO==1');
VARYG_F_VSS = Simulink.Variant('SCENARIO==2');

%% Update Configuration Settings
% Solver
set_param('rocketSim','SolverType',smp.solTyp);  % set solver type
set_param('rocketSim','Solver'    ,smp.sol);     % set solver

%% Run 1: Constant Thrust, Constant Angle Case
% Set the sim stop time by: (1) finding the closed form burnout state, 
% (2) calculate the closed form impact time, (3) add 1 sec so as not to
% miss the impact event, some extra data is ok, and (4) set the model's
% stop time programatically. 
s1.boSCF = burnoutClosedForm(rkt.m,thr.F,thr.tht,pln.g,rkt.t1);
s1.t2CF  = tImpactClosedForm(rkt.t1,s1.boSCF(Y),s1.boSCF(YD),pln.g);
s1.tStop = s1.t2CF + 1;
set_param('rocketSim','StopTime',num2str(s1.tStop));

% Simulate
SCENARIO=1;
s1.out = sim('rocketSim','SignalLoggingName','sdat');

% Pull the logged data from the sim output file into more easily used
% variables. 
s1 = pullData(s1);

% Extract the burnout state and time from the simulation data. At this
% point we need to pick one of the models, I suppose we could asses both,
% but here I'll pick the Simulink model data for comparing the closed form
% and simulated burnout states
[s1.boS,s1.boT] = burnoutSimData(s1.mag,s1.t,s1.xS,s1.yS,s1.xdS,s1.ydS);

% Extract the impact state and time from the simulation data. This can be
% used to limit plot data and analysis.
[s1.imS,s1.imT] = impactSimData(s1.t,s1.xS,s1.yS,s1.xdS,s1.ydS);

% Calculate the rocket's energy change from burnout to impact. This should
% be constant since energy is conserved in theory. This value is set to
% zero from launch until burnout since it's not really used in the
% analysis.
[s1.dNrg,s1.boNrg] = nrgChange(pln.g,s1.mag,s1.yS,s1.xdS,s1.ydS);

% Show plots and tables
h = displayRun1(s1);

%% Run 2: Constant Thrust, Time-Varying Angle Case
% Set the sim stop time by: We'll just use the same one that we calculated
% for the constant angle case. The reason we can get away with this is that
% the constant angle that was specified in the project description was a
% very special one. Use some analysis from Optimal Control Theory, that
% angle of 56 degrees was the value that gives the maximum range for the
% rocket. Although that doesn't mean the longest flight time, it's in the
% ball park. If we wiggle the engine, then the rocket will have a smaller
% downrange value. That topic is for another class... Here's we'll just
% update the s2 structure with the proper values from above.
s2.tStop = s1.tStop;
set_param('rocketSim','StopTime',num2str(s2.tStop));

SCENARIO = 2;
s2.out = sim('rocketSim','SignalLoggingName','sdat');

% Pull the logged data from the sim output file into more easily used
% variables. 
s2 = pullData(s2);

% Extract the impact state and time from the simulation data. This can be
% used to limit plot data and analysis.
[s2.imS,s2.imT] = impactSimData(s2.t,s2.xS,s2.yS,s2.xdS,s2.ydS);

% Calculate the rocket's energy change from burnout to impact. This should
% be constant since energy is conserved in theory. This value is set to
% zero from launch until burnout since it's not really used in the
% analysis.
[s2.dNrg,s2.boNrg] = nrgChange(pln.g,s2.mag,s2.yS,s2.xdS,s2.ydS);

h = displayRun2(h,s1,s2);

% ******* END *******

%% Helper Functions

function rO = pullData(rI)
% PULLDATA This is a beast of a function... It takes a simulation output
% object, that is assumed to be in rI.out, then extracts data from it and
% puts it into nicely named structure fields. It's very fragile since it
% needs to use the exact same naming convention used in the Simulink model. 
%
% Since some of the extractions are done twice, I've used several anonymous
% functions to avoid duplicating code.

%% Anonymous Functions
  % Extract time from sim output. Call syntax example to extract time
  % t = xT(s1);
  xTime = @(rn) rn.out.tout;

  % Extract data from sim output bus. Call syntax example to extract
  % data from cTraj, which is a traj bus, from the s1 run.
  % trj = xBus(s1,'cTraj');
  xTrajX  = @(rn,nm) rn.out.sdat.getElement(nm).Values.x.Data;
  xTrajY  = @(rn,nm) rn.out.sdat.getElement(nm).Values.y.Data;
  xTrajXd = @(rn,nm) rn.out.sdat.getElement(nm).Values.xd.Data;
  xTrajYd = @(rn,nm) rn.out.sdat.getElement(nm).Values.yd.Data;

  xThrustMag = @(rn) rn.out.sdat.getElement('thrust').Values.mag.Data;
  xThrustAng = @(rn) rn.out.sdat.getElement('thrust').Values.ang.Data;

  % copy the incoming run structure into the output structure. Then it will
  % get things added to it below
  rO = rI;

  rO.t     = xTime(  rO);
  
  rO.xC    = xTrajX( rO,'trajC');
  rO.yC    = xTrajY( rO,'trajC');
  rO.xdC   = xTrajXd(rO,'trajC');
  rO.ydC   = xTrajYd(rO,'trajC');
  
  rO.xS    = xTrajX( rO,'trajS');
  rO.yS    = xTrajY( rO,'trajS');
  rO.xdS   = xTrajXd(rO,'trajS');
  rO.ydS   = xTrajYd(rO,'trajS');
  
  rO.mag   = xThrustMag(rO);
  rO.ang   = xThrustAng(rO);

end

function t = tImpactClosedForm(t1,ybo,ydbo,g)
% Once the engine burns out, the rocket's motion behaves according to
% classic projectile motion since the aerodynamics are ignored. As long as
% we know the state of the rocket at burnout, its impact time, t2, can be
% found by solving
%
% y(t2) = 0

  % y-component projectile equation
  projEq = [-g/2 ydbo ybo];
  
  % possible impact times
  times = roots(projEq);
  
  % these times (roots) will either be:
  %   complex  : the scenario is impossible
  %   0        : this is also a bad solution
  %   real > 0 : this is the one we want
  %   real < 0 : this is the one we don't want
  
  if ~isreal(times)
      error('in tImpact: complex impact time');
  end
  
  t = max(times); % time from burnout to impact (s)
  
  if t == 0
      error('in tImpact: 0 impact time');
  end
  
  t = t + t1; % total time at impact (s)
  
end

%%
function boS = burnoutClosedForm(rM,tF,tA,pG,t1)
% Given the burnout time, t1, and if the thrust and angle are constant then
% we can calculate the closed form burnout state:
%
%   x(t1), y(t1), xdot(t1), ydot(t1)
%
% by integrating F = ma. This assumes that the initial condition of the
% rocket is zero for all position and speed states. It also checks if the
% rocket lifted off properly.
%
% Inputs
%  rM: rocket mass (kg)
%  tF: constant thrust value (N)
%  tA: constant thrust angle (deg)
%  pG: gravity accel (m/s^2)
%  t1: burnout time (s)
%
% Output
%  boS: burn out state, [x(t1);y(t1);xd(t1);yd(1)], (m) and (m/s)

  fBar = tF/rM; % normalized thrust (m/s^2)
  
  boS = zeros(4,1); % initialize the output
  
  boS(3) = fBar*cosd(tA)*t1;       % xdot (m/s)
  boS(4) = (fBar*sind(tA)-pG)*t1;  % ydot (m/s)
  boS(1) = boS(3)*t1 / 2;           % x (m)
  boS(2) = boS(4)*t1 / 2;           % y (m)
  
  % We can now check if the rocket actually lifted off and throw a warning
  % if it fell through Earth.
  t = 0:.001:t1;
  y = .5*(fBar*sind(tA)-pG)*t.^2;
  
  if any(y<0)
      warning('The rocket fell through Earth')
  end
  
end

function [boS,boT] = burnoutSimData(tF,t,x,y,xd,yd)
% Given a structure of simulation data this fn extracts that rocket state
% at burnout. It first finds the index of the thrust vector when it drops
% to zero, then pulls the state from the data at this index. It's tempting
% to use the hardwired t2 value to find the burnout state. However, this is
% an indirect approach and assumes your model works as expected. It's safer
% to look at the actual simulated data.

% array index when the thrust mag first becomes zero.
idx = find(tF==0,1);

% pull burnout time
boT  = t(idx); % burnout time (s)

boS = [x(idx);y(idx);xd(idx);yd(idx)];

end

function [imS,imT] = impactSimData(t,x,y,xd,yd)
% Extract the rocket's state at impact, and the time it occurs, from the
% simulation data
  idx = find(y<0,1) - 1; % array index
  imT = t(idx);  % time (s)
  imS = [x(idx); y(idx); xd(idx); yd(idx)]; % state (m), (m/s)
end

function [dNrg,boNrg] = nrgChange(g,tF,y,xd,yd)
% Calculate the change in energy from burnout, and the energy at burnout,
% from simulation data.

  dNrg = zeros(size(y)); % initialize the memory
  
  % array index when the thrust mag first becomes zero.
  idx = find(tF==0,1);
  
  % First compute the energy from burnout to impact
  dNrg(idx:end) = (xd(idx:end).^2 + yd(idx:end).^2)/2 + g*y(idx:end);
  
  % then snatch the energy at burnout
  boNrg = dNrg(idx);
  
  % finally, subtract away the energy at burnout, leaving just the change
  % in energy.
  dNrg(idx:end) = abs( boNrg - dNrg(idx:end) );
end

function h = displayRun1(s1)
% This is another beast of a function. I've just loaded it up with anything
% plot and table related. You'll certainly want to adjust this so the plots
% are nice.

  % Indices
  X  = 1;
  Y  = 2;
  XD = 3;
  YD = 4;

  % Possibly interesting plots
  id = 1; % X-Y Trajectory for both Simscape and Simulink
  h(id).fig = figure(id);
  h(id).axs = axes;
  h(id).ln(1) = line(s1.xS,s1.yS);
  h(id).ln(2) = line(s1.xC,s1.yC);grid;
  h(id).xlb = xlabel('X (m)');
  h(id).ylb = ylabel('Y (m)');
  h(id).axs.XLim = [0 s1.imS(1)];

  id = id+1; % X and Y Differences between Simscape and Simulink
  h(id).fig = figure(id);
  h(id).axs = axes;
  h(id).ln(1) = line(s1.t,abs(s1.xS-s1.xC)/1000);
  h(id).ln(2) = line(s1.t,abs(s1.xS-s1.xC)/1000);grid;
  h(id).xlb = xlabel('Time (s)');
  h(id).ylb = ylabel('Simscape vs Simulink');
  h(id).leg = legend('x diff (mm)','y diff (mm)');

  id = id+1; % Energy Conservation Check
  h(id).fig = figure(id);
  h(id).axs = axes;
  h(id).ln(1) = line(s1.t,s1.dNrg);grid;
  h(id).axs.XLim = [0 s1.imT];
  h(id).xlb = xlabel('Time (s)');
  h(id).ylb = ylabel('Energy Error (J)');
  h(id).ttl = title(['Energy at Burnout = ',num2str(s1.boNrg,'%0.1f'),' (J)']);

  fprintf('\n');
  fprintf(' *** BURNOUT STATE COMPARISON *** \n');
  fprintf(' State  Unit  Closed Form  Simulated     Error \n');
  fprintf(' ----------------------------------------------- \n');
  fprintf('   x     m      %+7.2f     %+7.2f    %9.3e     \n',...
      s1.boSCF(X),s1.boS(X),abs(s1.boSCF(X)-s1.boS(X)));
  fprintf('   y     m      %+7.2f     %+7.2f    %9.3e     \n',...
      s1.boSCF(Y),s1.boS(Y),abs(s1.boSCF(Y)-s1.boS(Y)));
  fprintf('  xd   m/s      %+7.2f     %+7.2f    %9.3e     \n',...
      s1.boSCF(XD),s1.boS(XD),abs(s1.boSCF(XD)-s1.boS(XD)));
  fprintf('  yd   m/s      %+7.2f     %+7.2f    %9.3e     \n',...
      s1.boSCF(YD),s1.boS(YD),abs(s1.boSCF(YD)-s1.boS(YD)));
end

function h = displayRun2(hI,s1,s2)
% This is another beast of a function. I've just loaded it up with anything
% plot and table related. You'll certainly want to adjust this so the plots
% are nice.

  h = hI;

  id = length(h);

  % Possibly interesting plots
  id = id+1; % X-Y Trajectory for both Simscape and Simulink
  h(id).fig = figure(id);
  h(id).axs = axes;
  h(id).ln(1) = line(s2.xS,s2.yS);
  h(id).ln(2) = line(s2.xC,s2.yC);grid;
  h(id).xlb = xlabel('X (m)');
  h(id).ylb = ylabel('Y (m)');
  h(id).axs.XLim = [0 s2.imS(1)];

  id = id+1; % X and Y Differences between Simscape and Simulink
  h(id).fig = figure(id);
  h(id).axs = axes;
  h(id).ln(1) = line(s2.t,abs(s2.xS-s2.xC)/1000);
  h(id).ln(2) = line(s2.t,abs(s2.xS-s2.xC)/1000);grid;
  h(id).xlb = xlabel('Time (s)');
  h(id).ylb = ylabel('Simscape vs Simulink');
  h(id).leg = legend('x diff (mm)','y diff (mm)');

  id = id+1; % X-Y Trajectory Comparsions - Constant vs Time-Varying Angle
  h(id).fig = figure(id);
  h(id).axs = axes;
  idx1 = find(s1.t>=s1.imT,1);
  idx2 = find(s2.t>=s2.imT,2);
  h(id).ln(1) = line(s1.xS(1:idx1),s1.yS(1:idx1),'Color','k');
  h(id).ln(1) = line(s2.xS(1:idx2),s2.yS(1:idx2),'Color','r');grid
  h(id).xlb = xlabel('X (m)');
  h(id).ylb = ylabel('Y (m)');
  h(id).leg = legend('Constant Thrust Angle','Varying Thrust Angle');

  id = id+1; % Thrust Components Comparison
  h(id).fig = figure(id);
  h(id).axs(1) = subplot(2,1,1);
  h(id).a(1).ln(1) = line(s1.t,s1.mag.*cosd(s1.ang)/1000,'Color','k');
  h(id).a(1).ln(2) = line(s2.t,s2.mag.*cosd(s2.ang)/1000,'Color','r');grid;
  h(id).a(1).xlb = xlabel('Time (s)');
  h(id).a(1).ylb = ylabel('Fx (kN)');
  h(id).leg = legend('Constant Thrust Angle','Varying Thrust Angle');
  h(id).axs(2) = subplot(2,1,2);
  h(id).a(2).ln(1) = line(s1.t,s1.mag.*sind(s1.ang)/1000,'Color','k');
  h(id).a(2).ln(2) = line(s2.t,s2.mag.*sind(s2.ang)/1000,'Color','r');grid;
  h(id).a(2).xlb = xlabel('Time (s)');
  h(id).a(2).ylb = ylabel('Fy (kN)');

  id = id+1; % Energy Conservation Check
  h(id).fig = figure(id);
  h(id).axs = axes;
  h(id).ln(1) = line(s2.t,s2.dNrg);grid;
  h(id).axs.XLim = [0 s2.imT];
  h(id).xlb = xlabel('Time (s)');
  h(id).ylb = ylabel('Energy Error (J)');
  h(id).ttl = title(...
      ['Energy at Burnout = ',num2str(s2.boNrg,'%0.1f'),' (J)']);
end