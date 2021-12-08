%% Script for testing of the input data, the input daata is given as the time series 

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
indata.u_knee_MEF = timeseries(z, t, 'Name', 'u_knee_MEF');
indata.u_knee_MEE = timeseries(oz, t, 'Name', 'u_knee_MEF');

indata.u_hip_MEF = timeseries(z, t, 'Name', 'u_hip_MEF');
indata.u_hip_MEE = timeseries(z, t, 'Name', 'u_hip_MEE');

indata.u_hip_abd = timeseries(z, t, 'Name', 'u_hip_abd');
indata.u_hip_add = timeseries(z, t, 'Name', 'u_hip_add');


indata.u_foot_MEF = timeseries(z, t, 'Name', 'u_foot_MEF');
indata.u_foot_MEE = timeseries(z, t, 'Name', 'u_foot_MEE');


InputBus = Simulink.Bus.createObject(indata);


%%


