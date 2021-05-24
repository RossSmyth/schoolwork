function fOut = f3(x,u,~)
% F2 Non-linear Forced Van der Pol Oscillator
%
%   w_ddot - mu * (1 - w^2)*w_dot + w = u
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
mu = 8.53;

fOut = [ x(2), mu * (1- x(1)^2) * x(2) - x(1)] + [0, u];
end

