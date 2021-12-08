%% load_data_and_sim_example
% Example script for the loading of the data from the computer and running the simulation. 
% After the simulation has run, the output values are collected in outdata.
% The current simulation has fixed time step of Ts = 1e-3s; If the
% calculations become to complecated, it is advisable to try to reduce the
% time step. 
% However, for the cases, that the movements are too complex and the
% simulation throws error anyways, one can use the try-catch blocks (for
% such a simulations one can set e.g. the cost function = inf)
%
% try catch is commented out in this script, and can be added if needed


%% Define target position (default [0 0 0])
target_position = [.1, 0, .3];

%% load data into the system
[indata, Ts, tend] = create_timeseries("input_data_files\input_data_set")

%% Simulate the system
% try
out = sim('main', tend);
% catch
% do some stuff, and just run the next simulation with new parameters 
% end
%% load data from the system
outdata = out.OutputData;

