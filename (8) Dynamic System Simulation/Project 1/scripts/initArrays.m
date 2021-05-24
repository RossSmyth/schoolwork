function [t,x,u,y] = initArrays(ss, tEnd, dt)
% INITARRAYS Pre-allocates arrays for speed over dyanmic allcoation.
%
% Takes in system parametes, and calcualtes the dimensions of the vectors
% needed to pre-allocate for running a simulation. This allows for faster
% compuation over dynamic allocation.
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
% Functions Called
%   CALCDIMS
%   CEIL
%   ZEROS
%   
% Author / Version
%   Dr. Gordon Parker
%   V1 (assuming)

  [n,r,m] = calcDims(ss);

  tEndSim = ceil(tEnd/dt)*dt;
  N = tEndSim/dt + 1;
  u = zeros(N,m);
  y = zeros(N,r);
  x = zeros(N,n);

  t = (0:dt:tEndSim)';
end

function [n,r,m] = calcDims(ss)
% CALCDIMS This functions calculates the dimensions of the state-variables
%
% This function takes in the cell array describing a system, and calculates
% the dimensions of the system based upon the initial conditions.
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
% Outputs
%   n = Dimension of the the IC
%   r = Dimension of states
%   m = Dimension of input
%
% Functions Called
%   YFN
%   UFN
%   LENGTH
%
% Author / Version
%   Dr. Gordon Parker
%   V1 (assuming)

  % Put handle to variable for ease
  yFn = ss{2};
  uFn = ss{3};
  x0  = ss{4};

  % Check the function's when input with IC to see the dimensions
  n = length(x0);
  r = length(yFn(x0));
  m = length(uFn( 0));
  
end