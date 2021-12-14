%% Script for initillizing of the main model; is connected with "Initilze me!" button

currpath = pwd;
% change the directory to the 
modelname = bdroot;
path2model = which(modelname);
path2model = strrep(path2model,modelname + ".slx", "");

cd(path2model)
%% Init muscle parameters
addpath("init_muscle")
init_muscle_MEF_hip;
init_muscle_MEE_hip;
init_muscle_ABD_hip;
init_muscle_ADD_hip;
init_muscle_MEF_knee;
init_muscle_MEE_knee;
init_muscle_MEF_angle;
init_muscle_MEE_angle;

%% Init other parameters
init_model_parameter;
target_position = [0 0 0];
% intv = 2;


%% Choose the colors for the model 
jcolor = [.4 1 .6]; % color of the joint balls (the balls for visualization, with no mass)
lcolor = [.2 .6 1]; % color of the lower body
ucolor = [1.0 0.8 0.8]; % color of the upper body

%% Load the Muscles4SimScienceAB library
slblocks

%% go back to the current path 
cd(currpath)
disp("The model " + modelname + " was  initilized!")

%% 
Ts = 1e-3;
tend = 2; 





