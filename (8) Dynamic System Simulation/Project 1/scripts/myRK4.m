function [t,y,u] = myRK4(ss,tEnd,dt)
%MYRK4 
% MYRK4 implements RK4 integration.
%   This function takes in a state-variables description of a system, then
%   evaluates the system using the RK4 integration technique. The system is
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

% Implement RK4 integration and keep track of the quantities that must
% be returned by the function.
% Because RK4 is a weighted average, each point that is weighted is set to
% kn where n is each point forward that is weighted.
  for i=2:length(t)
    % Slope calcaulted by RK-4 values at forward values.
    k1 = fFn(x(i-1, :),               u(i-1, :),          t(i-1) );
    k2 = fFn(x(i-1, :) + dt * k1 / 2, uFn(t(i-1) + dt/2), t(i-1) + dt / 2 );
    k3 = fFn(x(i-1, :) + dt * k2 / 2, uFn(t(i-1) + dt/2), t(i-1) + dt / 2 );
    k4 = fFn(x(i-1, :) + dt * k3,     uFn(t(i-1) + dt),   t(i-1) + dt );
    
    % Weighted average of the slopes multiplied by time step.
    x(i, :) = x(i-1, :) + 1 / 6 * dt * (k1 + 2 * k2 + 2 * k3 + k4);
    u(i,:) = uFn(t(i));
    y(i,:) = yFn(x(i, :), u(i, :), t(i));
  end

end

