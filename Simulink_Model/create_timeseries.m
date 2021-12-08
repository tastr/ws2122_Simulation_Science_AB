function [tseries, Ts, tend]  = create_timeseries(full_name_dataset)
    
dataset = load(full_name_dataset);

Ts = 1e-3;

% dataset from the path is loaded as dataset.<original name> => change it
% to just <original name>
dsname = fieldnames(dataset);
dataset = dataset.(dsname{1});

% define the field names in the original structure
fldnames = fieldnames(dataset); 

% depending on the number of elements define the end time tend
N = length(dataset.(fldnames{1}));
tend = (N-1)*Ts;
t = 0:Ts:tend';

% for each dataset create timeseries  
for i = 1:length(fldnames)
    eval("tseries. " + fldnames{i} + "= timeseries(dataset.(fldnames{i}), t, 'Name', fldnames{i});");
end

InputBus = Simulink.Bus.createObject(tseries); % create bus 
busName = InputBus.busName;

end

%%
% Simulink.Bus.createObject(dataset); % create bus 




