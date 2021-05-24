function [t,y,u] = myAB2(ss,tEnd,dt)
% MYAB2 implements AB2 integration.
%   This function takes in a state-variables description of a system, then
%   evaluates the system using the AB-2 integration technique. The system is
%   evaluated at fixed time steps described by the input until the defined
%   end time. For the first time-step, Euler integration is used.   
%
% Inputs
%   ss = Cell array that has funtion handles that descirbe the system. 
%           ss{1} = The state-variables function describing the derivative
%                   of the system
%           ss{2} = The state-variables function mapping the derivatives of
%                    the system to the measured outputs.
%           ss{3} = The input the system
%           ss{4} = The initial conditions vector 
%
%   tEnd = The end time of the simulation (seconds)
%   dt   = The simulation step time (seconds)
%
% Outputs
% 	t = The time vector where the system is evaluated at each point (s)
%   y = The states of the system at each evaluation point
%   u = The input to the system at each evaluation step
%
% Functions Called
%   INITARRAYS
%   FFN
%   YFN
%   UFN
%   LENGTH
% 

  fFn = ss{1};
  yFn = ss{2};
  uFn = ss{3};
  x0  = ss{4};

% create the time vector and acquire memory for the state, input and
% output arrays  
  [t,x,u,y] = initArrays(ss, tEnd, dt);

% Set the values of the first element, t=0, for the state, input and output
% arrays.
  x(1,:) =     x0;
  u(1,:) = uFn( 0);
  y(1,:) = yFn(x0);

% Euler start-up, just do it inline as it's probably faster than calling
% myEuler.
x(2,:) = x(1, :) + dt * fFn(x(1, :), u(1, :), t(1) );
u(2,:) = uFn(t(2));
y(2,:) = yFn(x(2, :), u(2, :), t(2));

% Implement AB2 integration and keep track of the quantities that must
% be returned by the function.  
  for i=3:length(t)
    % This is the actual AB-2 equation.
    x(i,:) = x(i-1, :) + ...
      dt * 1 / 2 * ( 3 * fFn( x(i-1, :), u(i-1, :), t(i-1) ) - ...
                         fFn( x(i-2, :), u(i-2, :), t(i-2) ) );    
    % Set variables for next step.
    u(i,:) = uFn(t(i));
    y(i,:) = yFn(x(i,:), u(i,:), t(i));
  end

end

