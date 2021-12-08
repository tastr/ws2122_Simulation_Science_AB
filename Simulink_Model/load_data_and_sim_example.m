%% Define target position (default [0 0 0])
target_position = [.1, 0, .3];

%% load data into the system
[indata, Ts, tend] = create_timeseries("input_data_files\input_data_set")

%% Simulate the system
out = sim('main', tend);

%% load data from the system
outdata = out.OutputData;

