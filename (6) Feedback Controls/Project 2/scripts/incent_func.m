function [incentive, pass] = incent_func(simout, ts, sensor_time)
%COST_FUNC(sys)
% This function calculates the cost for MEEM 4775 Project 2. For ye' olde
% non-linear optimization.
%
% Inputs:
%   simout      = The simulation data output
%   ts          = CPU update time (s). Cannot be less than 0.001, but
%                 doesn't actively check
%   sensor_time = Sensor time constant. Cannot be less than 0.04 but
%                 doesn't actively check.
%
% Output:
%   revenue = The system cost in dollars [double]
%   pass = Does the system meet the requirments? [bool]
% 
% See Also: STEPINFO, STEP

position  = simout.logsout.get('Position').Values.Data;
actuator  = simout.logsout.get('Actuator').Values.Data;
time      = simout.logsout.get('Position').Values.Time;

stats = stepinfo(position, time, 'SettlingTimeThreshold', 0.01);

%% Requirments
% Steady-state error must be less than 5%
ss_error_req = (position(end) - 1) < 0.05;

% Maximum overshoot must be less than 5%
mp_req = (stats.Peak - 1) < 0.05;

% 1% Settling time less than 3 s
set_time_req = stats.SettlingTime < 3;

pass = all([ss_error_req, mp_req, set_time_req]);
    
%% Cost
% Overshoot incentive
mp_rev = 10 * 100 * (0.05 - (stats.Peak - 1)); % $

% Settling time incentive
set_time_rev = 20 * (3 - stats.SettlingTime); % $

% Steady-state error incentive
ss_error_rev = 20 * 100 * (0.05 - (position(end) - 1)); % $

% Actuator cost/incentive
if max(actuator) > 2.5
    act_rev = -(max(actuator) - 2.5) * 50; % $
elseif min(actuator) < -2.5
    act_rev = (min(actuator) + 2.5) * 50; % $
else
    act_rev = 0; % $
end

% Sensor time constant cost/incentive
if sensor_time < 0.1
    sens_rev = (sensor_time - 0.1) * 140; % $
else
    sens_rev = (sensor_time - 0.1) * 35; % $
end

% CPU time step cost/incentive
cpu_rev = (ts - 0.1) * 300; % $

incentive = sum([ss_error_rev, set_time_rev, mp_rev, act_rev, sens_rev, cpu_rev]);
end

