function fOut = f1(x,u,t)
% F1 Example state-variables for integration validation
%
%   x_dot = -4*x+u
% 
%   Inputs
%   Inputs
%      x = The state(s) of the system at the current time.
%      u = The input to the system at the current time.
%      t = The current time being evaluated (seconds)
%
%   Outputs
%       fOut = The derivative of the states at the evaluated time.
%
fOut = -4*x + u;