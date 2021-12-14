function [tseries, Ts, tend]  = create_timeseries(full_name_dataset)


% for each dataset create timeseries  
for i = 1:length(fldnames)
    eval("tseries. " + fldnames{i} + "= timeseries(dataset.(fldnames{i}), t, 'Name', fldnames{i});");
end

InputBus = Simulink.Bus.createObject(tseries); % create bus 
busName = InputBus.busName;

end

%%
% Simulink.Bus.createObject(dataset); % create bus 




