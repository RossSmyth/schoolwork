clc, clear, close all
% This file is to primarily initialize variables to be plugged into
% Control System Designer and to initialize Simulink variables.

%% Transfer functions
sensor_time = 0.1;
dt = 0.01; % This is also the microcontroller speed. Not the simulation dt.

plant_tf = tf(25, [1, 4, 25]);
sensor_tf = tf(1, [sensor_time, 1]);

%% Raw Plant SS
plant_A = [0, 1; -25, -4];
plant_B = [0; 25];
plant_C = [1, 0];
plant_D = 0;

plant_ss = ss(plant_A, plant_B, plant_C, plant_D);

au_A = [plant_A, [0 0]';
        plant_C, 0];
au_B = [plant_B; 0];
au_C = [plant_C, 0];
au_D = plant_D;

au_ss = ss(au_A, au_B, au_C, au_D, dt);

sf_gains = place(au_A, au_B, [-2, 2+2i, 2-2i]);

%% Kalman filter, accounts for sensor.
filter_A = [0, 1, 0; -25, -4, 0; 1/sensor_time, 0, -1/sensor_time];
filter_B = [0; 25; 0];
filter_C = [0, 0, 1];
filter_D = 0;

filter_ss = ss(filter_A, filter_B, filter_C, filter_D, dt);
% This is sort of cheaty but oh well
filter_Q = 1;
filter_R = 1;

%% Load CSD controllers
CSD         = load('ControlSystemDesignerSession.mat');
controller1 = CSD.ControlSystemDesignerSession.DesignerData.Designs(1).Data.C;
controller2 = CSD.ControlSystemDesignerSession.DesignerData.Designs(2).Data.C;
controller1_d = c2d(controller1, dt);
controller2_d = c2d(controller2, dt);

%% Calculate cost
% Can't combine discrete and continous in matlab
%total_sys = feedback(series(controller_d, plant_tf), sensor_tf)

controller = controller1_d;
sim_out1 = sim('p2Sim');

controller = controller2_d;
sim_out2 = sim('p2Sim');

%% Tuned model parameters
% Have to reinitialize everything
sensor_time2 = 0.04;
dt           = 0.077;

sensor_tf = tf(1, [sensor_time2, 1]);

controller_tune   = CSD.ControlSystemDesignerSession.DesignerData.Designs(4).Data.C;
controller_tune_d = c2d(controller_tune, dt);

filter_A = [0, 1, 0; -25, -4, 0; 1/sensor_time2, 0, -1/sensor_time2];
filter_B = [0; 25; 0];
filter_C = [0, 0, 1];
filter_D = 0;

filter_ss = ss(filter_A, filter_B, filter_C, filter_D, dt);

controller = controller_tune_d;
sim_out2_tuned = sim('p2Sim');