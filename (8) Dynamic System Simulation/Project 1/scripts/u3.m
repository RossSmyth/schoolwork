function uOut= u3(t)
%U3 Input to forced van der pol oscillator
%
%   u(t) = 1.2 * sin(0.2 * pi * t)
% 
%   Inputs
%      t = Timestep to evaluate the input at (Seconds).
%
%   Outputs
%       uOut = The input at the evaluated time (Newtons).
%
uOut = 1.2 * sin(0.2 * pi * t);
end

