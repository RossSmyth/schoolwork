function yOut = y3(x,~,~)
% Y3 Output mapping for mass-spring-damper system
%
%   Maps directly to states.
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
end

