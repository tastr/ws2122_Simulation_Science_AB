%% Script for initillizing of the main model; is connected with "Initilze me!" button

currpath = pwd;
% change the directory to the 
modelname = bdroot;
path2model = which(modelname);
path2model = strrep(path2model,modelname + ".slx", "")

cd(path2model)
init_general_param;
init_muscle_MEF;
init_muscle_MEE;
init_model_parameter;
slblocks

cd(currpath)
disp("The model " + modelname + " was successfully initilized!")





