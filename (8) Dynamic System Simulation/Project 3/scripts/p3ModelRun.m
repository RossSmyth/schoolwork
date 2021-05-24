clc, clear, close all

%% Simulink setup

modelArgs = {%  Key             Value
                'Solver',       'ode4'... % DiffEq fixed solver
                'StopTime',     '20.0'... % s
                'FixedStep',    '0.01'... % s
            };
        
load          state_bus.mat
load_system   p3Model
BANG_C_BANG = Simulink.Variant('THRUST==1');
FREE_SWING  = Simulink.Variant('THRUST==2');

set_param('p3Model', 'SolverType', 'Fixed-step', modelArgs{:});

%% Model Parameters

gravity = 9.81; % m/s/s, gravitational accleration in -Y direction.

% Brick
brick.w   = 20/100; % (cm)
brick.l   = 10/100; % (cm)
brick.h   = 10/100; % (cm)
brick.clr = [147 174 200]/255; % light blue
brick.ics = [0;0]; % pos and spd (cm, cm/s)
brick.rho = 8000; % density (kg/m^3)
brick.m   = brick.rho * brick.w * brick.l * brick.h; % kg, brick mass

% Rod
rod.r     =  1/100; % radius (cm)
rod.l     = 40/100; % length (cm)
rod.clr   = [50 100 50]/255; % green
rod.fLoc  = 20/100; % force application location from the rod pin (cm)
rod.ics   = [0;0]; % ang and ang rate (deg, deg/s)
rod.rho   = 2700; % density (kg/m^3)
rod.m     = rod.rho * rod.l * pi * rod.r^2;

% Bang-coast Bang Parameters
thrust.amp(1)    = 1.5; % amplitude (N)
thrust.pulseT(1) = 3; % pulse duration (sec)
thrust.coastT(1) = 0.4; % coast time (sec)

% Swing-free manuver parameters
thrust.amp(2)    = 1; % amplitude (N)
thrust.coastT(2) = 12; % coast time (sec)

%% Run Sims
THRUST=1;
data = sim('p3Model.slx');
[BCB.DiffEq, BCB.Simscape, BCB.Thrust] = getStates(data);

THRUST=2;
data = sim('p3Model.slx');
[SF.DiffEq, SF.Simscape, SF.Thrust] = getStates(data);

function [diffEqState, simscapeState, thrust] = getStates(simulinkData)
% Gets data from Simulink runs and puts them into structs.

    % Get names.
    elementNames = getElementNames(simulinkData.logsout);

    % Check assumption that data is logged.
    assert(length(elementNames) == 3, "Proper Simulink data not logged.");

    for element = 1:3
        switch simulinkData.logsout{element}.Name
            case 'DiffEqState'
                diffEqState = simulinkData.logsout{element}.Values;
            case 'SimscapeState'
                simscapeState = simulinkData.logsout{element}.Values;
            case 'Thrust'
                thrust = simulinkData.logsout{element}.Values;
            otherwise
                error("Weird field in this Simulink data.")
        end
    end
end