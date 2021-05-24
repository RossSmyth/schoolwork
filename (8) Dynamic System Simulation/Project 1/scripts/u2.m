function uOut= u2(t)
% U2 Input to mass-spring-damper system
%
%   u(t) = 100 * sin(8 * pi * t) newtons
% 
%   Inputs
%      t = Timestep to evaluate the input at (Seconds).
%
%   Outputs
%       uOut = The input at the evaluated time (Newtons).
%

uOut = 100 * sin(8 * pi * t);
end

