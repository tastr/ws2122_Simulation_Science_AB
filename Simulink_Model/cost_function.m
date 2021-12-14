function f = cost_function(x)
%% get simTime and simSystem
simTime = evalin('base','simTime;');
simSystem = evalin('base','system;');

%% overwrite the parameters values in mdlPara




%% simulate the model with pso parameters
try
    % Refresh model blocks for making variant subsystem active
    model_obj = get_param(bdroot,'Object');
    model_obj.refreshModelBlocks;
    
    warning('off','Simulink:Engine:UsingDefaultMaxStepSize')
    warning('off','Simulink:Commands:MdlFileChangedOnDisk')
    % start simulation
    sim(simSystem,simTime);    
    % set warning on
    warning('on','Simulink:Engine:UsingDefaultMaxStepSize')
    warning('on','Simulink:Commands:MdlFileChangedOnDisk')
    
    %% %%%%% Berechnung der Fehler und Kostenfunktion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    e = simData.signals.values(:,2) - simData.signals.values(:,1); % Positionsfehler [deg]    
    edeg = simData.signals.values(:,2) - simData.signals.values(:,1); % Positionsfehler [deg]
    
    if identSystem == 1 % Kombinierte Identifikation mit Position [deg] und Druck [Pa]
        ePa =  simData.signals.values(:,6) - simData.signals.values(:,5); % Druckfehler [Pa]
        % Normierung der Fehler (Anpassen auf Maxima der Messungen)
        edeg = edeg ./ 90;
        ePa = ePa ./ 5.5e5;
        % Definition der Kostenfunktion für kombinierte Identifikation
        fdeg = sum(abs(power(edeg,4))); % Anpassung der Potenz der Fehler kann sinnvoll sein
        fPa = sum(abs(power(ePa,4)));
        f = fdeg + 3 * fPa ;
        f = f/(length(edeg+ePa));
    elseif identSystem == 2 || identSystem == 3 % Standardmodell || Mechanik
        % Standardkostenfunktion für Position
        f = sum(abs(power(edeg,3)));
        f = f/length(edeg);
    elseif identSystem == 4 % Pneumatik
        ePa =  simData.signals.values(:,6) - simData.signals.values(:,5); % Druckfehler [Pa]
        % Standardkostenfunktion für Druck
        f = sum(abs(power(ePa,3)));
        f = f/length(ePa);
    end
    
    u = simData.signals.values(:,3);
    
    assignin('base','simData',simData);
    
    
catch
    f = Inf;
    disp('Something went wrong, set f = inf ')
end
end