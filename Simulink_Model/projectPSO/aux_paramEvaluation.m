function aux_paramEvaluation()
% with this function one can calculate the average error of the simulation
% model with a choosen parameter file compared to the choosen measurement
% file. Use this To check if our optimised parameters will be ok for other
% measurements

% ... getting started

% create a cleanUp object
	origPath	= path;
	origDir		= pwd;
	
cleanupObj = onCleanup(@()common_func.cleanUpFunc(origPath,origDir));

%% Modellparameter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load model parameters
disp(' ')
disp('------------------------------------')
disp('Folgende Parameterdatensätze werden geladen und verglichen: ');

% choose the parameter files, you want to compare
mdlParaDirectory = 'C:\Program Files\MATLAB\lib\PASL\PASL_Models\_mdlPara\Positioner\';

    % choose dataset
	dlgTitle = 'Which dataset(s)?';
    [datasetName, datasetPath] = uigetfile([mdlParaDirectory,'mdlPara*.mat'], ...
        dlgTitle,'MultiSelect', 'on');
	
	for i = 1:length(datasetName)
		% load dataset(s)
		disp(['  ', num2str(i), ' ''', datasetName{i}, ''''])
% 		evalin('base',['load(''',datasetPath,datasetName,''')'])
	end

%% measurement signal
% assignin('base','measData',common_files.aux_createMeasSignal());
	% bus solution
	if ~evalin('base','exist(''measDataTimeSeries'',''var'');')
		measDataTimeSeries = common_files.aux_createMeasSignalSeries;
		busMeasData = aux_createBus(measDataTimeSeries);
		aux_renameBus(busMeasData);
		fldNames = fieldnames(measDataTimeSeries);
% 		simTime = round(max(get(measDataTimeSeries.(fldNames{1}),'Time')))-1;
% 		set_param(bdroot,'StopTime',num2str(simTime))
		% assign in base
		assignin('base', 'measDataTimeSeries', measDataTimeSeries)
		assignin('base', 'busMeasData', busMeasData)
	end

%% Simulationsparameter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
assignin('base','Ts',5e-3);                                % Abtastzeit [s]

% simulation time
try
	simTime = evalin('base','round(max(measData.time))-1;');
catch
	fldNames = evalin('base','fieldnames(measDataTimeSeries);');
	simTime = evalin('base',...
		['round(max(get(measDataTimeSeries.',fldNames{1},...
		',''Time'')))-1']);
end

% simulation model
if evalin('base','exist(''system'',''var'')')
	simulinkMdlName = evalin('base','system;');
else
	dlgTitle = 'Which model?';
	[fname,fpath] = uigetfile('simulink',dlgTitle,'MultiSelect','off');
	simulinkMdlName = fullfile(fpath,fname);
end

disp(['Es wird das Modell ''', simulinkMdlName, ...
	''' über ', num2str(simTime), ' Sekunden simuliert.'])

%% simulate the model with each of the choosen parameter files and measurement
	% plot result
	figureID = 99;
	while ishandle(figureID)
		figureID = figureID +1;
	end
	
	PA_silentFigure(figureID)
	clf
	f99(1) = subplot(3,1,1);
	f99(2) = subplot(3,1,2);
	f99(3) = subplot(3,1,3);
	hold(f99(1),'all')
	hold(f99(2),'all')
	hold(f99(3),'all')

disp('The mean/rms errors for the parameter files are:');

for i = 1:length(datasetName)
	%datasetNr
	thisNr = datasetName{i}(length('mdlPara_Positioner_optim_')+1:end-length('.mat'));
	% load parameter file
    evalin('base',['load(''',datasetPath,datasetName{i},''')'])
	
	try
		simData = simulate(simulinkMdlName,simTime);
		% calculate the error: soll/meas/1 - ist/sim/2
		e = simData.signals.values(:,1) - simData.signals.values(:,2);
        
%% choose between RMS and MEAN       
rmsFlag = true;

        if rmsFlag
            rmsError = sqrt(sum(power(e,2))/length(e));
            disp(['	 #', num2str(thisNr), ':   +- ', num2str(rmsError), ' %']);
        else
            meanError = mean(abs(e));
            disp(['	 #', num2str(thisNr), ':   +- ', num2str(meanError), ' %']);
        end
		
		% plot
		% plot xMeas for first at first sim
		if(i==1)
			% x_meas
			plot(f99(1),simData.time,simData.signals.values(:,1),'g',...
				'LineWidth',1.5);
			legendString1 = '''x_{meas}[%]''';
			% u_ctrl/u_can			
			plot(f99(2),simData.time,simData.signals.values(:,3));
			legendString2 = '''u_{ctrl/CAN}''';
		end
		plot(f99(1),simData.time,simData.signals.values(:,2));
		legendString1 = [legendString1, ', ''x_{', num2str(thisNr),' sim}[%]'''];
		
		% errors
		plot(f99(3),simData.time, e);
		if(i==1)
			legendString3 = ['''e_{', num2str(thisNr), '}[%]'''];
		else
			legendString3 = [legendString3, ', ''e_{', num2str(thisNr), '}[%]'''];
		end

	catch
		 disp('CAN''T CALCULATE OR PLOT')
	end
end

	% plot result
	eval(['legend(f99(1),',legendString1,')'])
	eval(['legend(f99(2),',legendString2,')'])
	eval(['legend(f99(3),',legendString3,')'])
	grid(f99(1),'minor')
	grid(f99(2),'minor')
	grid(f99(3),'minor')
	hold(f99(1),'off')
	hold(f99(2),'off')
	hold(f99(3),'off')
	linkaxes(f99,'x')
		
		
		
end

%% help function simulate
function simData = simulate(simulinkMdlName,simTime)
	% Umrechnungsfaktoren %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% absolute Position in relative Position umrechnen
	evalin('base','mm2pr = 100/(mdlPara.xMax * 10^3);')    % Umrechnung von mm nach Prozent
	evalin('base','pr2mm = (mdlPara.xMax * 10^3)/100;')	% Umrechnung von Prozent nach mm
	evalin('base','m2pr  = 100/mdlPara.xMax;')				% Umrechnung von m nach Prozent
	evalin('base','pr2m  = mdlPara.xMax/100;')				% Umrechnung von Prozent nach m
	evalin('base','aux_convStruct')							% Umrechung struct aufrufen
	
	    % disable warnings about the simulation stepsize:
	%
	% "Warning: Model 'Positioner_MdlIdent' is using a default value of 1.6 for
	% maximum step size. You can disable this diagnostic by setting 'Automatic
	% solver parameter selection' diagnostic to 'none' in the Diagnostics page of
	% the configuration parameters dialog "
	%
		warning('off','Simulink:Engine:UsingDefaultMaxStepSize')
try
	sim(simulinkMdlName,simTime);
catch
	disp('CAN''T SIMULATE');
end
		
	% set warning on
		warning('on','Simulink:Engine:UsingDefaultMaxStepSize')

end