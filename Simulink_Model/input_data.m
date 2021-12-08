%% General parameter
Ts = 1e-3;
tend = 1;
t = 0:Ts:tend;

inputdata_file = "./input_data_files/data.mat";


%% Target 
target_position = [.1, 0, .3];

%%
N = length(t);

oz = [ones((N-1)/2,1); zeros((N-1)/2 + 1,1)];
z  = [zeros(N,1)];
%%
dataset.u_knee_MEF = timeseries(oz, t, 'Name', 'u_knee_MEF');
dataset.u_knee_MEE = timeseries(z, t, 'Name', 'u_knee_MEF');

dataset.u_hip_MEF = timeseries(z, t, 'Name', 'u_hip_MEF');
dataset.u_hip_MEE = timeseries(z, t, 'Name', 'u_hip_MEE');

dataset.u_hip_abd = timeseries(z, t, 'Name', 'u_hip_abd');
dataset.u_hip_add = timeseries(z, t, 'Name', 'u_hip_add');


dataset.u_foot_MEF = timeseries(z, t, 'Name', 'u_foot_MEF');
dataset.u_foot_MEE = timeseries(z, t, 'Name', 'u_foot_MEE');


InputBus = Simulink.Bus.createObject(dataset);
oldName = InputBus.busName;
InputBus.busName = "InputBus";
clear(oldName)

%%
dataset.u_knee_MEF = oz;
dataset.u_knee_MEE = z;

dataset.u_hip_MEF = z;
dataset.u_hip_MEE = z;

dataset.u_hip_abd = z;
dataset.u_hip_add = z;


dataset.u_foot_MEF = z;
dataset.u_foot_MEE = z;

