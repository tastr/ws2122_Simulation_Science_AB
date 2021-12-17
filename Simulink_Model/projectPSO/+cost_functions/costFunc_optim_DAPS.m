function f = costFunc_optim_DAPS(x)
% Stand: 29.01.2018, Editor: Maximilian Nitsch (MMNT)
% Um die Kostenfunktion für den DAPS zu nutzen, müssen in der "projectPSO.m" einige
% Änderungen vorgenommen werden! Dies betrifft die Abfrage nach doppelwirkendem Antrieb:
% contains(thisVariant,'DFPI')||contains(thisVariant,'DA') die um: && ~contains(thisVariant,'DAPS')
% ergänzt werden muss, sowie die switch case struktur zur Abfrage der Einheiten der Position. Diese
% muss um:
%                     case listPosUnits(5) % deg
%                     data.edit_initPosition.String = num2str(thisPos);
%                     evalin('base',['mdlPara.z0 = double(',num2str(thisPos),');'])
% erweitert werden!

% Kostenfunktion für den DAPS-Antrieb. Bisher nur für den einfachwirkenden DAPS implementiert. Für
% die doppeltwirkende Variante sollten die Variablen analog zum DFPD umbenannt werden, also statt
% Vtot: Vtot2 und Vtot4, V0: V02 und V04,A: A2 und A4, dOut: d2Out und d4Out (im Normalfall gilt:
% dOut=d2Out=d4Out), initChamberLength: initChamberLength2 und initChamberLength4 oder z02 und z04
% Modelle für Identifikation in "DAPS_SA_MdlIdent.slx"

%% get simTime and simSystem
simTime = evalin('base','simTime;');
simSystem = evalin('base','system;');

%% get the stopPSONow flag
global flag_stopPSONow

%% overwrite the parameters values in mdlPara
%%% evalin('base',['mdlPara.parameter = ', num2str(),';']);

% detect variant
thisVariant = evalin('base','mdlPara.variant;');

% load parameters to be optimised from ws
param4Opt = evalin('base','param4Opt');

for i = 2:size(param4Opt,1)
    switch param4Opt{i,2}
        %%%%%%%%% Reibung
        case 'z0'           % Initiale Auslenkung des Kolbens [m]
            evalin('base',['mdlPara.z0 = ', num2str(x(i-1)),'* conv.mm2m;']);
        case 'mass'         % Masse [kg]
            evalin('base',['mdlPara.mass = ', num2str(x(i-1)),';']);
        case 'Fstick'		% Haftreibung [N]
            evalin('base',['mdlPara.Fstick = ', num2str(x(i-1)),';']);		% beim PSO Sam kann hier auf die Addition verzichtet werden.
        case 'Fcoulomb'		% Gleitreibung [N]
            evalin('base',['mdlPara.Fcoulomb = ', num2str(x(i-1)),';']);
        case 'ks'			% Viskose Reibung - nicht benötigt
            evalin('base',['mdlPara.ks = ', num2str(x(i-1)),';']);
        case 'stribeckVel'	% Stribeckgeschwindigkeit [m/s]
            evalin('base',['mdlPara.stribeckVel = ', num2str(x(i-1)),';']);
        case 'viscFriCoeff1'	% Koeff.1 für Viskose Reibung [Ns/m]
            evalin('base',['mdlPara.viscFriCoeff1 = ', num2str(x(i-1)),';']);
        case 'viscFriCoeff2'	% Koeff.1 für Viskose Reibung [Ns/m]
            evalin('base',['mdlPara.viscFriCoeff2 = ', num2str(x(i-1)),';']);
        case 'viscFriCoeff3'	% Koeff.1 für Viskose Reibung [Ns/m]
            evalin('base',['mdlPara.viscFriCoeff3 = ', num2str(x(i-1)),';']);
            %%%%%%%%% Fläche/Volumen
        case 'dOut'		% Außendurchmesser Kammer/Kolben 2
            evalin('base',['mdlPara.dOut = ', num2str(x(i-1)),'* conv.mm2m;']);
        case 'dIn'		% Innendurchmesser Kammer/Kolben 2
            evalin('base',['mdlPara.dIn = ', num2str(x(i-1)),'* conv.mm2m;']);
        case 'Vtot'		% Totvolumen Kammer2 [m^3]
            evalin('base',['mdlPara.Vtot = ', num2str(x(i-1)),'* conv.cm32m3;']);
            %%%%%%%%% Druck
        case 'pv'			% Versorgungsdruck[Pa]
            evalin('base',['mdlPara.pv = ', num2str(x(i-1)),';']);
        case 'pu'			% Umgebungsdruck [Pa]
            evalin('base',['mdlPara.pu = ', num2str(x(i-1)),';']);
        case 'p02'			% Anfangsdruck Kammer [Pa] (entsprechend Messung)
            evalin('base',['mdlPara.p02 = ', num2str(x(i-1)),';']);
            %%%%%%%%% Feder
        case 'c'			% Federkonstante [N/m] = [kg/s^2]
            evalin('base',['mdlPara.c = ', num2str(x(i-1)),';']);
        case 'zf'			% Federvorspannung [m]
            evalin('base',['mdlPara.zf = ', num2str(x(i-1)),'* conv.mm2m;']);
        case 'd'            % Dämpferkonstante [N/(m s)] = [kg/s]
            evalin('base',['mdlPara.d = ', num2str(x(i-1)),';']);
        case 'transLot'     % Translatorisches Lot [m]
            evalin('base',['mdlPara.transLot = ', num2str(x(i-1)),';']);
            %%%%%%%% Rotierende Masse
        case 'Inertia'				% Trägheitsmoment des Ritzels [kg m^2]
            evalin('base',['mdlPara.Inertia = ', num2str(x(i-1)),';']);
        case 'PinionMstick'			% Haftreibungsmoment d. Ritzels [Nm]
            evalin('base',['mdlPara.PinionMstick = ', num2str(x(i-1)),';']);
        case 'PinionMcoulomb'		% Gleitreibungsmoment d. Ritzels [Nm]
            evalin('base',['mdlPara.PinionMcoulomb = ', num2str(x(i-1)),';']);
        case 'PinionViscFri'		% Viskose Reibung d. Ritzels [Nm s/rad]
            evalin('base',['mdlPara.PinionViscFri = ', num2str(x(i-1)),';']);
        case 'PinionStribeckVel'	% Stribeckgeschwindigkeit d. Ritzels [rad/s]
            evalin('base',['mdlPara.PinionStribeckVel = ', num2str(x(i-1)),';']);
    end
    
end

%% %%%%%% Berechnungen, die von anderen Parametern abhängen
% Länge Kammer2[m] bei t=0
evalin('base','mdlPara.initChamberLength = mdlPara.z0;');

% Initialer Federvorspannweg [m]
evalin('base','mdlPara.zfZero = mdlPara.zf;');

% Fläche Kammer2 [m^2], alle Varianten haben durchgehende Kolbenstange
evalin('base','mdlPara.A = (mdlPara.dOut^2 - mdlPara.dIn^2) * pi/4;');

% Anfangsvolumen Kammer2 [m^3]
evalin('base','mdlPara.V0 = mdlPara.Vtot + mdlPara.A *mdlPara.initChamberLength;');

% Falls doppeltwirkende Variante (für DAPS noch nicht implementiert - Stand 16.01.2018)
% Anpassung der Variablenbezeichnungen für doppelwirkenden Antrieb nötig!
if strcmp(thisVariant(end-1:end),'DA')
    % Kammerlänge 4 bei t=0 [m]
    evalin('base','mdlPara.initChamberLength4 = (mdlPara.zMax - mdlPara.z0);');
    
    % Fläche Kammer4 [m^2], alle Varianten haben durchgehende Kolbenstange
    evalin('base','mdlPara.A4 = (mdlPara.d4Out^2 - mdlPara.d4In^2) *pi/4;');
    
    % Anfangsvolumen Kammer 4 [m^3]
    evalin('base','mdlPara.V04 = mdlPara.Vtot4 + mdlPara.z04 * mdlPara.A4;');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% simulate the model with pso parameters
try
    % disable warnings about the simulation stepsize:
    %
    % "Warning: Model 'Positioner_MdlIdent' is using a default value of 1.6 for
    % maximum step size. You can disable this diagnostic by setting 'Automatic
    % solver parameter selection' diagnostic to 'none' in the Diagnostics page of
    % the configuration parameters dialog "
    
    %% Hier Modell aussuchen:
    identSystem = 1; %[1: Gesamtsystem, 2: Standardmodell, 3: Mechanik, 4: Pneumatik]
    
    % Solver: auto, variable Schrittweite mit "Max step size": 0.01 
    
    % Swap variant subsystem in Simulink
    if identSystem == 1 || identSystem == 4
        evalin('base','VARIANT_MODE = 1;');
    elseif identSystem == 2 
        evalin('base','VARIANT_MODE = 3;');
    elseif identSystem == 3 
        evalin('base','VARIANT_MODE = 2;');
    end
    
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
    
    % Je nachdem welcher Systemteil identifiziert werden soll, muss die Variable "identSystem"
    % angepasst werden. Dabei gibt es bisher die folgenden Fälle:
    % 1.: Gesamtsystem: Fehler edeg wird aus Position in [deg] gebildet und
    % Fehler ePa wird aus Druck in [Pa] gebildet, kombinierte Kostenfunktion (f = fdeg + const * fPa)
    % 2.: Standardmodell: Fehler e wird aus Position in [deg] gebildet, Standardkostenfunktion
    % 3.: Mechanik: Fehler e wird aus Position in [deg] gebildet, Standardkostenfunktion, Druck wird
    % direkt als Eingang auf den Kolben gegeben, daher ist es nur sinnvoll Parameter der Mechanik zu
    % optimieren
    % 4.: Pneumatik: Fehler ePa wird aus Druck in [Pa] gebildet,
    % Standardkostenfunktion mit ePA, Druck wird als Ausgang hinter dem Volumen genutzt, daher ist
    % es nur sinnvoll Parameter der Pneumatik zu optimieren
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
    
    % plot result
    PA_silentFigure(77)
    clf
    hold all
    f77(1) = subplot(3,1,1);
    if identSystem ~= 4
        plot(simData.time,simData.signals.values(:,1), ...
            simData.time,simData.signals.values(:,2))
        ylim([-5,105])
        legend('x_{meas}[°]','x_{sim}[°]')
    else % Pneumatik
        plot(simData.time,simData.signals.values(:,5), ...
            simData.time,simData.signals.values(:,6))
        ylim([-5, 10e5])
        legend('p_{meas}[Pa]','p_{sim}[Pa]')
    end
    
    grid minor
    f77(2) = subplot(3,1,2);

    if identSystem ~= 4
        plot(simData.time, e)
        legend('e[°]')
        ylim([min(e)-5, max(e)+5])
    else % Pneumatik
        plot(simData.time, ePa)
        legend('e[Pa]')
    end

    grid minor
    f77(3) = subplot(3,1,3);
    plot(simData.time, u)
    legend('u')
    grid on
    hold off
    
    linkaxes(f77,'x')
    
catch
    f = Inf;
    %     disp('CAN''T SIMULATE')
end

%% breake if user stops

if flag_stopPSONow
    qstString = 'Would you like to stop the PSO?';
    qstTitle = qstString;
    qstAns = {'Yes, stop the PSO','No'};
    usrInput = questdlg(qstString,qstTitle,qstAns{1},qstAns{2},qstAns{1});
    switch usrInput
        case qstAns(1)
            error('err:PSO:userStop','User stopped the PSO by clicking the button.')
        case qstAns(2)
            flag_stopPSONow = false;
    end
end

drawnow()

end