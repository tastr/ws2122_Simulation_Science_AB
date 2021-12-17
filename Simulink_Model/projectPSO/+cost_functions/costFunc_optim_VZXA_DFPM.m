function f = costFunc_optim_VZXA_DFPM(x)
% Stand: 25.01.2018, Editor: Maximilian Nitsch (MMNT)
% Aktuell erweiterte Kostenfunktion aktiv f = fdeg + 3 * fPa
% Achtung: Im Modell "VZXA_DFPK_SA_MdlIdent.slx" darauf achten, dass sich der Pressure Switch in der
%          oberen Stellung befindet!

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
        case 'Fstick'		% Haftreibung [N]
            evalin('base',['mdlPara.Fstick = ', num2str(x(i-1)),';']);		% beim PSO Sam kann hier auf die Addition verzichtet werden.
        case 'Fcoulomb'		% Gleitreibung [N]
            evalin('base',['mdlPara.Fcoulomb = ', num2str(x(i-1)),';']);
        case 'mass'         % Masse [kg]
            evalin('base',['mdlPara.mass = ', num2str(x(i-1)),';']);
        case 'ks'			% Viskose Reibung
            evalin('base',['mdlPara.ks = ', num2str(x(i-1)),';']);
        case 'vs'			% Stribeckgeschwindigkeit [m/s]
            evalin('base',['mdlPara.vs = ', num2str(x(i-1)),';']);
        case 'stribeckVel'	% Stribeckgeschwindigkeit [m/s]
            evalin('base',['mdlPara.stribeckVel = ', num2str(x(i-1)),';']);
        case 'viscFriCoeff1'	% Koeff.1 f�r Viskose Reibung [Ns/m]
            evalin('base',['mdlPara.viscFriCoeff1 = ', num2str(x(i-1)),';']);
        case 'viscFriCoeff2'	% Koeff.1 f�r Viskose Reibung [Ns/m]
            evalin('base',['mdlPara.viscFriCoeff2 = ', num2str(x(i-1)),';']);
        case 'viscFriCoeff3'	% Koeff.1 f�r Viskose Reibung [Ns/m]
            evalin('base',['mdlPara.viscFriCoeff3 = ', num2str(x(i-1)),';']);
            %%%%%%%%% Fl�che/Volumen
        case 'dmem'		% Membrandurchmesser
            evalin('base',['mdlPara.dmem = ', num2str(x(i-1)),'* conv.mm2m;']);
        case 'd2ch'		% Au�endurchmesser Kammer/Kolben 2
            evalin('base',['mdlPara.d2ch = ', num2str(x(i-1)),'* conv.mm2m;']);
        case 'd2In'			% Innendurchmesser Kammer/Kolben 2
            evalin('base',['mdlPara.d2In = ', num2str(x(i-1)),'* conv.mm2m;']);
        case 'Vtot2'		% Totvolumen Kammer2 [m^3]
            evalin('base',['mdlPara.Vtot2 = ', num2str(x(i-1)),'* conv.cm32m3;']);
            %%%%%%%%% Druck
        case 'pv'			% Versorgungsdruck[Pa] (6 bar Nennbetriebsdruck, laut Datenblatt)
            evalin('base',['mdlPara.pv = ', num2str(x(i-1)),';']);
        case 'pu'			% Umgebungsdruck [Pa]
            evalin('base',['mdlPara.pu = ', num2str(x(i-1)),';']);
        case 'p02'			% Anfangsdruck Kammer2 [Pa] (entsprechend Messung)
            evalin('base',['mdlPara.p02 = ', num2str(x(i-1)),';']);
            %%%%%%%%% Feder
        case 'c'			% Federkonstante [N/m] = [kg/s^2]
            evalin('base',['mdlPara.c = ', num2str(x(i-1)),';']);
        case 'xf'			% Federvorspannung [m]
            evalin('base',['mdlPara.xf = ', num2str(x(i-1)),'* conv.mm2m;']);
            % Federvorspannung bei x = 0 [m], "at zero displacement"
            switch thisVariant{1}(end-1:end)
                case 'NC'
                    evalin('base','mdlPara.xfZero = mdlPara.xf + mdlPara.xMax;');
                case 'NO'
                    evalin('base','mdlPara.xfZero = mdlPara.xf;');
                otherwise
                    error('pso:noVariant','No variant NC/NO found.')
            end
        case 'd'			% D�mpferkonstante [N/(m s)] = [kg/s]
            evalin('base',['mdlPara.d = ', num2str(x(i-1)),';']);
            %%%%%%%%% pneum. Leitwerte
        case 'cMax'			% max. pneum. Leitwert
            evalin('base',['mdlPara.cMax = ', num2str(x(i-1)),';']);
        case 'cMin'			% max. pneum. Leitwert
            evalin('base',['mdlPara.cMin = ', num2str(x(i-1)),';']);
    end
    
end

%%%%%%%% Berechnungen, die von anderen Parametern abh�ngen
% L�nge Kammer2 [m] bei t=0
switch thisVariant{1}(end-1:end)
    case 'NC'
        evalin('base','mdlPara.x02 = mdlPara.xMax - mdlPara.x0;');
    case 'NO'
        evalin('base','mdlPara.x02 = mdlPara.x0;');
    otherwise
        error('err:initNoVar','Variants can only be NC or NO.')
end

% �quivalente Fl�che [m^2] (siehe Praktikumsbericht Anna Mack S.5) hier: Am = A2
evalin('base','mdlPara.A2 = pi/12 * (mdlPara.dmem^2 + mdlPara.dmem * mdlPara.d2ch + mdlPara.d2ch^2);');
% Anfangsvolumen Kammer [m^3] (siehe Praktikumsbericht Anna Mack S.8)
evalin('base','mdlPara.V02 = mdlPara.A2 * mdlPara.x02 - pi/4 * mdlPara.d2In^2 * mdlPara.x02 + mdlPara.Vtot2;');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% simulate the model with pso parameters
try
    % disable warnings about the simulation stepsize:
    %
    % "Warning: Model 'Positioner_MdlIdent' is using a default value of 1.6 for
    % maximum step size. You can disable this diagnostic by setting 'Automatic
    % solver parameter selection' diagnostic to 'none' in the Diagnostics page of
    % the configuration parameters dialog "
    %
    
    warning('off','Simulink:Engine:UsingDefaultMaxStepSize')
    
    % start simulation
    sim(simSystem,simTime);
    
    % set warning on
    warning('on','Simulink:Engine:UsingDefaultMaxStepSize')
    
    e = simData.signals.values(:,2) - simData.signals.values(:,1);
    
    % Modifizerte Kostenfunktion
    ePos = simData.signals.values(:,2) - simData.signals.values(:,1); % Positionsfehler [%]
    ePa =  simData.signals.values(:,6) - simData.signals.values(:,5); % Druckfehler [Pa]
    ePos = ePos ./ 100; % Normierung auf maximalen Positionsfehler
    ePa = ePa ./ 7.5e5; % Normierung auf maximalen Druckfehler
    fPos = sum(abs(power(ePos,4))); % Anpassung der Potenz der Fehler kann sinnvoll sein
    fPa = sum(abs(power(ePa,4)));
    f = fPos + 3 * fPa ;
    %     f = f/(length(edeg+ePa));
    
    % Standardkostenfunktion
    %     f = sum(abs(power(e,3)));
    %     f = f/(length(e));
    
    u = simData.signals.values(:,3);
    
    assignin('base','simData',simData);
    
    % plot result
    PA_silentFigure(77)
    clf
    hold all
    f77(1) = subplot(3,1,1);
    plot(simData.time,simData.signals.values(:,1), ...
        simData.time,simData.signals.values(:,2))
    legend('x_{meas}[%]','x_{sim}[%]')
    ylim([-5 105])
    grid minor
    f77(2) = subplot(3,1,2);
    plot(simData.time, e)
    legend('e[%]')
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