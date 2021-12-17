%% Initial Settings
close all
clear all
clc


%% Import parameters
addpath("lib")
init_muscle_MEF_hip;
init_muscle_MEE_hip;
init_muscle_MEF_knee;
init_muscle_MEE_knee;

param_setting;


%% Generate input signals
% Muscle signals
RN = (1-.7)*rand+.7;
t1 = 1;
musStart1 = -RN;
musEnd1 = RN;
t2 = 1.1;
musStart2 = -RN;
musEnd2 = RN;

% Foot angle
param.foot.ang = rand(1)*30;


%% Run simulation
out = sim('kick_lowerlimb');
Simulink.sdi.clear