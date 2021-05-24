clearvars;
close all
clc

% Load soln1, soln2 and soln3 into the workspace. Use the solutionDataZero
% file to see that all your simulations work. You should get no errors, but
% all 'fail' messages in the command window. To test your work against
% someone else in the class, use the solutionData file that your classmate
% creates using the makeSolutionData script. If you get all 'Pass' comments
% in the command window then you know that your data matches your
% classmate's. They could both be wrong, or both be correct. 
load solutionData_sH-2
% load solutionData

% Threshold for a valid result
myTol = 1E-9;

%% Dynamic System 1: x' = -x
% Define the system
s1 = {@f1,@y1,@u1,2.0};

% Define simulation conditions
dt   = 0.05;
tEnd = 2;

% Run the simulations
[~,yE,~] = myInteg(s1,tEnd,dt,'Euler');
[~,yA,~] = myInteg(s1,tEnd,dt,'AB2');
[~,yR,~] = myInteg(s1,tEnd,dt,'RK4');

% Check the results
if max( abs(yE-soln1.yE) ) > 1E-9
    fprintf('DS1 Euler Fail\n');
else
    fprintf('DS1 Euler Pass\n');
end

if max( abs(yA-soln1.yA) ) > myTol
    fprintf('DS1 AB-2 Fail\n');
else
    fprintf('DS1 AB-2 Pass\n');
end

if max( abs(yR-soln1.yR) ) > myTol
    fprintf('DS1 RK-4 Fail\n');
else
    fprintf('DS1 RK-4 Pass\n');
end

fprintf('\n');

%% Dynamic System 2: LTV
% Define the system
s2 = {@f2,@y2,@u2,[0.0 0.0]};

% Define simulation conditions
dt = 0.005;
tEnd = 10;

% Run the simulations
[~,yE,uE] = myInteg(s2,tEnd,dt,'Euler');
[~,yA,uA] = myInteg(s2,tEnd,dt,'AB2');
[~,yR,uR] = myInteg(s2,tEnd,dt,'RK4');

% Check the results
if max( abs(yE-soln2.yE) ) > myTol
    fprintf('DS2 Euler Y Fail\n');
else
    fprintf('DS2 Euler Y Pass\n');
end

if max( abs(uE-soln2.uE) ) > myTol
    fprintf('DS2 Euler U Fail\n');
else
    fprintf('DS2 Euler U Pass\n');
end

if max( abs(yA-soln2.yA) ) > myTol
    fprintf('DS2 AB-2 Y Fail\n');
else
    fprintf('DS2 AB-2 Y Pass\n');
end

if max( abs(uA-soln2.uA) ) > myTol
    fprintf('DS2 AB-2 U Fail\n');
else
    fprintf('DS2 AB-2 U Pass\n');
end

if max( abs(yR-soln2.yR) ) > myTol
    fprintf('DS2 RK-4 Y Fail\n');
else
    fprintf('DS2 RK-4 Y Pass\n');
end

if max( abs(uR-soln2.uR) ) > myTol
    fprintf('DS2 RK-4 U Fail\n');
else
    fprintf('DS2 RK-4 U Pass\n');
end

fprintf('\n');

%% Dynamic System 3: Van der Pol
% Define the system
s3 = {@f3,@y3,@u3,[0.0 0.0]};

% Define simulation conditions
dt = 0.01;
tEnd = 50;

% Run the simulations
[~,yE,uE] = myInteg(s3,tEnd,dt,'Euler');
[~,yA,uA] = myInteg(s3,tEnd,dt,'AB2');
[~,yR,uR] = myInteg(s3,tEnd,dt,'RK4');

% Check the results
if max( abs(yE-soln3a.yE) ) > myTol
    fprintf('DS2a Euler Y Fail\n');
else
    fprintf('DS2a Euler Y Pass\n');
end

if max( abs(uE-soln3a.uE) ) > myTol
    fprintf('DS2a Euler U Fail\n');
else
    fprintf('DS2a Euler U Pass\n');
end

if max( abs(yA-soln3a.yA) ) > myTol
    fprintf('DS2a AB-2 Y Fail\n');
else
    fprintf('DS2a AB-2 Y Pass\n');
end

if max( abs(uA-soln3a.uA) ) > myTol
    fprintf('DS2a AB-2 U Fail\n');
else
    fprintf('DS2a AB-2 U Pass\n');
end

if max( abs(yR-soln3a.yR) ) > myTol
    fprintf('DS2a RK-4 Y Fail\n');
else
    fprintf('DS2a RK-4 Y Pass\n');
end

if max( abs(uR-soln3a.uR) ) > myTol
    fprintf('DS2a RK-4 U Fail\n');
else
    fprintf('DS2a RK-4 U Pass\n');
end

fprintf('\n');

% Define simulation conditions
dt = 0.001;

% Run the simulations
[tE,yE,uE] = myInteg(s3,tEnd,dt,'Euler');
[tA,yA,uA] = myInteg(s3,tEnd,dt,'AB2');
[tR,yR,uR] = myInteg(s3,tEnd,dt,'RK4');

% Check the results
if max( abs(yE-soln3b.yE) ) > myTol
    fprintf('DS2b Euler Y Fail\n');
else
    fprintf('DS2b Euler Y Pass\n');
end

if max( abs(uE-soln3b.uE) ) > myTol
    fprintf('DS2b Euler U Fail\n');
else
    fprintf('DS2b Euler U Pass\n');
end

if max( abs(yA-soln3b.yA) ) > myTol
    fprintf('DS2b AB-2 Y Fail\n');
else
    fprintf('DS2b AB-2 Y Pass\n');
end

if max( abs(uA-soln3b.uA) ) > myTol
    fprintf('DS2b AB-2 U Fail\n');
else
    fprintf('DS2b AB-2 U Pass\n');
end

if max( abs(yR-soln3b.yR) ) > myTol
    fprintf('DS2b RK-4 Y Fail\n');
else
    fprintf('DS2b RK-4 Y Pass\n');
end

if max( abs(uR-soln3b.uR) ) > myTol
    fprintf('DS2b RK-4 U Fail\n');
else
    fprintf('DS2b RK-4 U Pass\n');
end

fprintf('\n');


