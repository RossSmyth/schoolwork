function [t,y,u] = myInteg(ss,tEnd,dt,intMethod)
% MYINTEG simulates a dynamic system, defined by the ss cell array, using
%   the selected integration method.
% Inputs
%   ss = Cell array that has funtion handles that descirbe the system. 
%           ss{1} = The state-variables function describing the derivative
%                   of the system
%           ss{2} = The state-variables function mapping the derivatives of
%                    the system to the measured outputs.
%           ss{3} = The input the system
%           ss{4} = The initial conditions vector 
%
%   tEnd      = The end time of the simulation (seconds)
%   dt        = The simulation step time (seconds)
%   intMethod = The integration method to use. Either euler, ab2, or rk4.
%
% Outputs
% 	t = The time vector where the system is evaluated at each point (s)
%   y = The states of the system at each evaluation point
%   u = The input to the system at each evaluation step
%
% Functions Called
%   LOWER
%   MYEULER
%   MYAB2
%   MYRK4
%   ERROR
%
% Author / Version
%   Dr. Gordon Parker
%   V1.0 (assuming)

switch lower(intMethod)
  case 'euler'
    [t,y,u] = myEuler(ss,tEnd,dt);
  case 'ab2'
    [t,y,u] = myAB2(ss,tEnd,dt);
  case 'rk4'
    [t,y,u] = myRK4(ss,tEnd,dt);      
  otherwise
    error('oops');
end
  
