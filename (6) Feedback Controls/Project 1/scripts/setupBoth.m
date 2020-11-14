%% Model setup
step_time =  1; % s, time step is activated
step_value = 0.3; % m, Demanded position in step

sin_amp = 0.3; % m, amplitude of positoin demand sine wave
sin_freq = 1; % rad/s, sine input frequency

dt = 0.001; % s, time step
%% Parameter Setup
g =  9.81; % m/s^2 gravitational acceleration
mt = 5.21E-1; % kg total cart mass
mr = 0.23; % kg Rod mass
Jr = 7.88E-3; % kg-m^2 rod MMOI
Lc = 0.64; % m rod length
Jm = 3.9E-7; % kg-m^2 Wheel MMOI (gearbox MMOI is small so Jw = Jm)
Bm = 1E-6; % Post-gearbox damping
n  = 9E-1; % Gearbox efficiency
N =  3.71; % Gear ratio
Kt = 7.68E-3; % N-m/A Motor torque constant
Ke = Kt; % V-s/rad Motor back emf = motor torque constant
Ra = 2.6; % Ohms motor resistance
r =  6.35E-3; % m Pinion radius

KT = 1;
KA = 1;

% Model Setup
% Setup the state space from the parameters
M = [mt + mr + Jm/r, 0;
    0,         Jr + mt + Lc^2]; % Mass matrix
C = [(N/r)^2 * (Bm + n * Kt * Ke / Ra), 0;
     0,                                 0] * -1; % ~C coefficient matrix
K = [0, 0;
     0, mr * Lc * g] * -1; % K coefficient matrix
B = [N * n * Kt / r / Ra; 0]; % B coefficient vector

C = M \ C; % Matrix left divide by mass matrix
K = M \ K;
B = M \ B;

Ad = [zeros(2), eye(2);
      K,            C]; % State space matrix A
Bd = [zeros(2, 1); B]; % State space vector B
Cd = eye(4); % State space matrix C
Dd = zeros(4, 1); % State space vector D