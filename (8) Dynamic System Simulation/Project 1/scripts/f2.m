function fOut = f2(x,u,t)
% F2 Linear time-varying system of a mass-spring-damper
%
%   m*w_ddot + c * w_dot + k(t) * w(t) = u(t)
% 
%   x1 = w_dot
%   x2 = w_ddot
%
%   Inputs
%   Inputs
%      x = The state(s) of the system at the current time.
%      u = The input to the system at the current time. (newtons)
%      t = The current time being evaluated (seconds)
%
%   Outputs
%       fOut = The derivative of the states at the evaluated time.
%
m = 1; % kg
c = 0.5; % N-m-s
k = 30 + 3 * sin(2 * pi * t); % N/m


fOut = [ x(2), - k / m * x(1) + -c / m * x(2)] + [0, u/m];
    
end

