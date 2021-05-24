function yOut = y1(x,~,~)
% Y1 Example output mapping for validation of integraiton methods.
%
%   Always the state
% 
%   Inputs
%      x = The state(s) of the system at the current time.
%      u = The input to the system at the current time.
%      t = The current time being evaluated (seconds)
%
%   Outputs
%       yOut = The mapped output for the evaluated time.
%
yOut = x;