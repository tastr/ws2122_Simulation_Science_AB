function f = cost_function(x)
%% get simTime and simSystem
simTime = evalin('base','simTime;');
Ts = evalin('base','Ts;');
simSystem = evalin('base','system;');
brake_time = evalin('base','brake_time');
res_nb = evalin("base","res_nb");

%% overwrite the parameters values in mdlPara
t = 0:Ts:simTime;

% knee
dataset.u_knee_MEF = [x(1)*ones(brake_time/Ts,1); x(9)*ones(brake_time/Ts,1); zeros(length(t) - 2*brake_time/Ts,1)];
dataset.u_knee_MEE = [x(2)*ones(brake_time/Ts,1); x(10)*ones(brake_time/Ts,1); zeros(length(t) - 2*brake_time/Ts,1)];

% hip
dataset.u_hip_MEF = [x(3)*ones(brake_time/Ts,1); x(11)*ones(brake_time/Ts,1); zeros(length(t) - 2*brake_time/Ts,1)];
dataset.u_hip_MEE = [x(4)*ones(brake_time/Ts,1); x(12)*ones(brake_time/Ts,1); zeros(length(t) - 2*brake_time/Ts,1)];

dataset.u_hip_abd = [x(5)*ones(brake_time/Ts,1); x(13)*ones(brake_time/Ts,1); zeros(length(t) - 2*brake_time/Ts,1)];
dataset.u_hip_add = [x(6)*ones(brake_time/Ts,1); x(14)*ones(brake_time/Ts,1); zeros(length(t) - 2*brake_time/Ts,1)];

dataset.u_foot_MEF = [x(7)*ones(brake_time/Ts,1); x(15)*ones(brake_time/Ts,1); zeros(length(t) - 2*brake_time/Ts,1)];
dataset.u_foot_MEE = [x(8)*ones(brake_time/Ts,1); x(16)*ones(brake_time/Ts,1); zeros(length(t) - 2*brake_time/Ts,1)];

fldnames = fieldnames(dataset);
% for the given dataset create timeseries  
for i = 1:length(fldnames)
    eval("tseries. " + fldnames{i} + "= timeseries(dataset.(fldnames{i}), t, 'Name', fldnames{i});");
end
assignin("base","indata", tseries);

% create the bus
InputBus = Simulink.Bus.createObject(tseries); % create bus 
busName = InputBus.busName;
if not(strcmp(busName, "slBus1"))
    evalin("base", "clear " + busName)
end


%% simulate the model with pso parameters
try
    % Refresh model blocks for making variant subsystem active
    model_obj = get_param(bdroot,'Object');
    model_obj.refreshModelBlocks;
    
    warning('off','all');
    % start simulation
    out = sim(simSystem,simTime);    
    % set warning on
    warning('on','all');
    
    %% %%%%% Berechnung der Fehler und Kostenfunktion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     x_dist = out.Ball_Target_distance{1}.Values.Data(:,1);
% %     y_dist = out.Ball_Target_distance{1}.Values.Data(:,2);
% %     z_dist = out.Ball_Target_distance{1}.Values.Data(:,3);
%     dist = out.Ball_Target_distance{1}.Values.Data(:,4);
%     
%     x_contact = x_dist(abs(x_dist)<.11);
% 
% 
%     if length(x_contact)>1
%         x_contact = x_contact(min(abs(x_contact)));
%     end
% 
% 
% %     y_contact = y_dist(x_dist == x_contact);
% %     z_contact = z_dist(x_dist == x_contact);
%     if length(x_contact)==1
%         f = dist(x_dist == x_contact)
%     else % length = 0
%         f = min(abs(dist))
%     end
    dist = out.Ball_Target_distance{1}.Values.Data(:,4); 
    f = min(abs(dist))

    if f<.7
        save("./pso_output/res_" + num2str(res_nb) + ".mat", "x")
        res_nb = res_nb + 1;
    end
        


    
    
catch
    f = Inf;
    disp('Something went wrong, set f = inf ')
end
end