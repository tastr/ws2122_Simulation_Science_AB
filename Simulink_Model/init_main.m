%% Script for initillizing of the main model; is connected with "Initilze me!" button

currpath = pwd;
% change the directory to the 
modelname = bdroot;
path2model = which(modelname);
path2model = strrep(path2model,modelname + ".slx", "")

cd(path2model)
addpath("init_muscle")
init_general_param;
init_muscle_MEF_hip;
init_muscle_MEE_hip;
init_muscle_ABD_hip;
init_muscle_ADD_hip;
init_muscle_MEF_knee;
init_muscle_MEE_knee;

init_model_parameter;
slblocks

cd(currpath)
disp("The model " + modelname + " was successfully initilized!")






