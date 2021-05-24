clearvars;
close all

%% Dynamic System 1: x' = -4x
ics = 2.0;
s1 = {@f1,@y1,@u1,ics};

dt   = 0.05;
tEnd = 2;

[soln1.tE,soln1.yE,soln1.uE] = myInteg(s1,tEnd,dt,'Euler');
[soln1.tA,soln1.yA,soln1.uA] = myInteg(s1,tEnd,dt,'AB2');
[soln1.tR,soln1.yR,soln1.uR] = myInteg(s1,tEnd,dt,'RK4');

%% Dynamic System 2: LTV
ics = [0 0];
s2 = {@f2,@y2,@u2,ics};

dt   = 0.005;
tEnd = 10;

[soln2.tE,soln2.yE,soln2.uE] = myInteg(s2,tEnd,dt,'Euler');
[soln2.tA,soln2.yA,soln2.uA] = myInteg(s2,tEnd,dt,'AB2');
[soln2.tR,soln2.yR,soln2.uR] = myInteg(s2,tEnd,dt,'RK4');


%% Dynamic System 3: Van der Pol
ics = [0 0];
s3 = {@f3,@y3,@u3,ics};

dt = 0.01;
tEnd = 50;

[soln3a.tE,soln3a.yE,soln3a.uE] = myInteg(s3,tEnd,dt,'Euler');
[soln3a.tA,soln3a.yA,soln3a.uA] = myInteg(s3,tEnd,dt,'AB2');
[soln3a.tR,soln3a.yR,soln3a.uR] = myInteg(s3,tEnd,dt,'RK4');

dt = 0.001;

[soln3b.tE,soln3b.yE,soln3b.uE] = myInteg(s3,tEnd,dt,'Euler');
[soln3b.tA,soln3b.yA,soln3b.uA] = myInteg(s3,tEnd,dt,'AB2');
[soln3b.tR,soln3b.yR,soln3b.uR] = myInteg(s3,tEnd,dt,'RK4');

save solutionData.mat soln1 soln2 soln3a soln3b

%% Zero Data Solution
soln1.yE = soln1.yE * 0;
soln1.uE = soln1.uE * 0;
soln1.yA = soln1.yA * 0;
soln1.uA = soln1.uA * 0;
soln1.yR = soln1.yR * 0;
soln1.uR = soln1.uR * 0;

soln2.yE = soln2.yE * 0;
soln2.uE = soln2.uE * 0;
soln2.yA = soln2.yA * 0;
soln2.uA = soln2.uA * 0;
soln2.yR = soln2.yR * 0;
soln2.uR = soln2.uR * 0;

soln3a.yE = soln3a.yE * 0;
soln3a.uE = soln3a.uE * 0;
soln3a.yA = soln3a.yA * 0;
soln3a.uA = soln3a.uA * 0;
soln3a.yR = soln3a.yR * 0;
soln3a.uR = soln3a.uR * 0;

soln3b.yE = soln3b.yE * 0;
soln3b.uE = soln3b.uE * 0;
soln3b.yA = soln3b.yA * 0;
soln3b.uA = soln3b.uA * 0;
soln3b.yR = soln3b.yR * 0;
soln3b.uR = soln3b.uR * 0;

save solutionDataZero.mat soln1 soln2 soln3a soln3b



