function f = costFunc_optim_DFPD(x)

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
        case 'ks'			% Viskose Reibung
            evalin('base',['mdlPara.ks = ', num2str(x(i-1)),';']);
        case 'vs'			% Stribeckgeschwindigkeit [m/s]
            evalin('base',['mdlPara.vs = ', num2str(x(i-1)),';']);
        case 'stribeckVel'	% Stribeckgeschwindigkeit [m/s]
            evalin('base',['mdlPara.stribeckVel = ', num2str(x(i-1)),';']);
        case 'viscFriCoeff1'	% Koeff.1 für Viskose Reibung [Ns/m]
            evalin('base',['mdlPara.viscFriCoeff1 = ', num2str(x(i-1)),';']);
        case 'viscFriCoeff2'	% Koeff.1 für Viskose Reibung [Ns/m]
            evalin('base',['mdlPara.viscFriCoeff2 = ', num2str(x(i-1)),';']);
        case 'viscFriCoeff3'	% Koeff.1 für Viskose Reibung [Ns/m]
            evalin('base',['mdlPara.viscFriCoeff3 = ', num2str(x(i-1)),';']);
%%%%%%%%% Fläche/Volumen
        case 'd2Out'		% Außendurchmesser Kammer/Kolben 2
            evalin('base',['mdlPara.d2Out = ', num2str(x(i-1)),'* sqrt(2) * conv.mm2m;']);
            evalin('base',['mdlPara.A2 = (mdlPara.d2Out.^2 - mdlPara.d2In.^2) .*(pi/4);']);
        case 'd2In'			% Innendurchmesser Kammer/Kolben 2
            evalin('base',['mdlPara.d2In = ', num2str(x(i-1)),'* conv.mm2m;']);
            evalin('base',['mdlPara.A2 = (mdlPara.d2Out.^2 - mdlPara.d2In.^2) .*(pi/4);']);
		case 'Vtot2'		% Totvolumen Kammer2 [m^3]
            evalin('base',['mdlPara.Vtot2 = ', num2str(x(i-1)),'* conv.cm32m3;']);
        case 'd4Out'		% Außendurchmesser Kammer/Kolben 4
            evalin('base',['mdlPara.d4Out = ', num2str(x(i-1)),'* sqrt(2) * conv.mm2m;']);
            evalin('base',['mdlPara.A4 = (mdlPara.d4Out.^2 - mdlPara.d4In.^2) .*(pi/4);']);
        case 'd4In'			% Innendurchmesser Kammer/Kolben 4
            evalin('base',['mdlPara.d4In = ', num2str(x(i-1)),'* conv.mm2m;']);
            evalin('base',['mdlPara.A4 = (mdlPara.d4Out.^2 - mdlPara.d4In.^2) .*(pi/4);']);
		case 'Vtot4'		% Totvolumen Kammer4 [m^3]
            evalin('base',['mdlPara.Vtot4 = ', num2str(x(i-1)),'* conv.cm32m3;']);
%%%%%%%%% Druck
		case 'pv'			% Versorgungsdruck[Pa] (6 bar Nennbetriebsdruck, laut Datenblatt)
            evalin('base',['mdlPara.pv = ', num2str(x(i-1)),';']);
        case 'pu'			% Umgebungsdruck [Pa]
            evalin('base',['mdlPara.pu = ', num2str(x(i-1)),';']);
        case 'p02'			% Anfangsdruck Kammer2 [Pa] (entsprechend Messung)
            evalin('base',['mdlPara.p02 = ', num2str(x(i-1)),';']);
        case 'p04'			% Anfangsdruck Kammer4 [Pa] (entsprechend Messung)
            evalin('base',['mdlPara.p04 = ', num2str(x(i-1)),';']);
%%%%%%%%% Feder
		case 'c'			% Federkonstante [N/m] = [kg/s^2]
            evalin('base',['mdlPara.c = ', num2str(x(i-1)),';']);
        case 'xf'			% Federvorspannung [m]
            evalin('base',['mdlPara.xf = ', num2str(x(i-1)),'* conv.mm2m;']);
							% Federvorspannung bei x = 0 [m], "at zero displacement"
			switch 'NO' % fest auf 'NO', das es beim DFPD keine NC Variante gibt
				case 'NC'
					evalin('base','mdlPara.xfZero = mdlPara.xf + mdlPara.xMax;');
				case 'NO'
					evalin('base','mdlPara.xfZero = mdlPara.xf;');
				otherwise
					error('pso:noVariant','No variant NC/NO found.')
			end
        case 'd'			% Dämpferkonstante [N/(m s)] = [kg/s]
            evalin('base',['mdlPara.d = ', num2str(x(i-1)),';']);
%%%%%%%%% pneum. Leitwerte
        case 'cMax'			% max. pneum. Leitwert
            evalin('base',['mdlPara.cMax = ', num2str(x(i-1)),';']);
        case 'cMin'			% max. pneum. Leitwert
            evalin('base',['mdlPara.cMin = ', num2str(x(i-1)),';']);
%%%%%%%%% Zahnstange/Ritzel
		case 'Inertia'				% Trägheitsmoment des Ritzels [kg m^2]
            evalin('base',['mdlPara.inertia = ', num2str(x(i-1)),';']);
		case 'PinionMstick'			% Haftreibungsmoment d. Ritzels [Nm]
            evalin('base',['mdlPara.pinionMstick = ', num2str(x(i-1)),';']);
		case 'PinionMcoulomb'		% Gleitreibungsmoment d. Ritzels [Nm]
            evalin('base',['mdlPara.pinionMcoulomb = ', num2str(x(i-1)),';']);
		case 'PinionViscFri'		% Viskose Reibung d. Ritzels [Nm s/rad]
            evalin('base',['mdlPara.pinionViscFri = ', num2str(x(i-1)),';']);
		case 'PinionStribeckVel'	% Stribeckgeschwindigkeit d. Ritzels [rad/s]
            evalin('base',['mdlPara.pinionStribeckVel = ', num2str(x(i-1)),';']);
		
    end

end

%% %%%%%% Berechnungen, die von anderen Parametern abhängen
% Länge Kammer2 [m] bei t=0
evalin('base','mdlPara.x02 = mdlPara.x0;');

% Fläche Kammer2 [m^2], alle Varianten haben durchgehende Kolbenstange
evalin('base','mdlPara.A2 = (mdlPara.d2Out^2 - mdlPara.d2In^2) *pi/4;');

% Anfangsvolumen Kammer2 [m^3] 
evalin('base','mdlPara.V02 = mdlPara.Vtot2 + mdlPara.A2 *mdlPara.x02;');

% Ausgangsstellung des Ritzels [rad]
evalin('base','mdlPara.phi0 = mdlPara.x0 / mdlPara.pitchRadius;');

% Dämpfung der Verzahnung [Ns/m]
evalin('base',['mdlPara.gearDamp = 2 * 0.05 * sqrt(mdlPara.gearStiffness',...
	'* mdlPara.width * mdlPara.inertia);']);


% falls doppeltwirkende Variante
if strcmp(thisVariant(end-1:end),'RD')
	% Kammerlänge 4 bei t=0 [m]
	evalin('base','mdlPara.x04 = (mdlPara.xMax - mdlPara.x0);');
	
	% Fläche Kammer4 [m^2], alle Varianten haben durchgehende Kolbenstange
	evalin('base','mdlPara.A4 = (mdlPara.d4Out^2 - mdlPara.d4In^2) *pi/4;');
	
	% Anfangsvolumen Kammer 4 [m^3]
	evalin('base','mdlPara.V04 = mdlPara.Vtot4 + mdlPara.x04 * mdlPara.A4;');
	
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
	%
		
		warning('off','Simulink:Engine:UsingDefaultMaxStepSize')
		warning('off','Simulink:Commands:MdlFileChangedOnDisk')
        warning('off','Simulink:Engine:SolverMinStepSizeWarn')
	
	% start simulation
	sim(simSystem,simTime);
	
	% set warning on
		warning('on','Simulink:Engine:UsingDefaultMaxStepSize')
		warning('on','Simulink:Commands:MdlFileChangedOnDisk')
        warning('on','Simulink:Engine:SolverMinStepSizeWarn')
        
%% cost function
    % position error
    posMeas = simData.signals.values(:,1);
    posSim = simData.signals.values(:,2);
    e = posMeas - posSim;
    % pressure error
    p2Meas = simData.signals.values(:,5);
    p2Sim = simData.signals.values(:,6);
    try
        % in case of DA
        p4Meas = simData.signals.values(:,7);
        p4Sim = simData.signals.values(:,8);
    catch
        % nothing
    end

withPressure = false;

if withPressure
    pErr = (p2Meas - p2Sim) / evalin('base','mdlPara.pv;');                 % normierter Druckfehler
    posErr = e / evalin('base','mdlPara.xMax*mdlPara.conv.m2pr');           % normierter Positionsfehler
    f = sum(abs(power(posErr,3)) + 3*abs(power(pErr,3)));
else
    f = sum(abs(power(e,4)));
end
    
    % norm costs with simulation length
    f = f/length(e);
    
%% Root Mean Square Error
rmsError = sqrt(sum(power(e,2))/length(e));

	% assign simulation results in wirkspace
    assignin('base','simData',simData);
    
%% plot result
% get more signals for plotting
u = simData.signals.values(:,3);

% plot
    PA_silentFigure(77)
    clf
    hold all
    f77(1) = subplot(4,1,1);
    plot(simData.time,posMeas, ...
        simData.time,posSim)
	ylim([-5,105])
    legend('x_{meas}[%]','x_{sim}[%]')
    grid minor
    title(['Root Mean Square Error = ',num2str(rmsError)])
    f77(2) = subplot(4,1,2);
    plot(simData.time, p2Meas,...
        simData.time, p2Sim)
    legend('p2Meas [Pa]','p2Sim [Pa]')
    grid minor
    f77(3) = subplot(4,1,3);
    plot(simData.time, e,...
        simData.time, min(e)*ones(length(e),1),'--r',...
        simData.time, max(e)*ones(length(e),1),'--r')
    legend('e[%]')
    grid minor
    f77(4) = subplot(4,1,4);
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