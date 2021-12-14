function measData = aux_createMeasSignal()
%% create signal from measurement
disp(' ')
disp('------------------------------------')
disp('Generierung eines Referenzsignals für die Initialisierung...')
disp('  ...')

% Messschrieb laden
disp(' ')
dlgTitle = 'From which measurement do you want to create your reference signals?';
disp(dlgTitle)
disp(' ')

dlgDefPath = 'M:\ORG_Process_Automation\Dev_Electronics\50_Archiv\MessablageRT\';
dlgDefAns = [dlgDefPath,'rec_mdlIdent_005.mat'];

[measName, measPath] = uigetfile( ...
    [dlgDefPath,'*.mat'],dlgTitle,dlgDefAns,'MultiSelect', 'off');

disp(['Referenzsignal wird aus Messung ''', measName, ''' generiert...'])
try
	measurementData = load([measPath,measName]);
	disp('... abgeschlossen.')
catch
	error('createMeasSig:loadMeas','WARNING: \nAn error occured while loading the measurement data.')
end

fldnm = fieldnames(measurementData);
measurementData = measurementData.(fldnm{1});
clear fldnm

%% suppress warngings
warning('off','getDSpaceDataByLabel:noSignal')
% set them on, when closing the function or error occurs
cleanUp_warning = onCleanup(@() warning('on','getDSpaceDataByLabel:noSignal'));





%% Hinweis
% Die Listen mit mehreren Labels sind erforderlich, weil es über die Zeit
% mehrere Anpassungen der Parameternamen gab und sonst jeweils alte oder
% neue Messungen nicht mehr verarbeitet werden könnten.
% Wer eine elegantere Lösung hat, nur her damit!

%% time
measData.time = PA_getDSpaceTime(measurementData);

%% u
labelList = {'uCAN','uCtrl','CtrlSignalCAN'};
measData = searchForAllLabels(measurementData,measData,labelList,1);

%% position [mA]
labelList = {'xDSpace [mA]','pos[mA]','PositionAbs [mA]'};
measData = searchForAllLabels(measurementData,measData,labelList,2);

%% dVIn [l/min]
labelList = {'dVIn [lmin]','dV2In [lmin]'};
measData = searchForAllLabels(measurementData,measData,labelList,3);

%% dVOut [l/min]
labelList = {'dVOut [lmin]','dV2Out [lmin]'};
measData = searchForAllLabels(measurementData,measData,labelList,4);

%% p2 [bar] (relative)
labelList = {'p1 [bar]','p2 [bar]'};
measData = searchForAllLabels(measurementData,measData,labelList,5);

%% pV [bar] (relative)
labelList = {'pV [bar]'};
measData = searchForAllLabels(measurementData,measData,labelList,6);

%% pOut/pU [bar] (relative)
labelList = {'pOut [bar]','pU [bar]'};
measData = searchForAllLabels(measurementData,measData,labelList,7);

%% p2 [bar] (absolute)
labelList = {'p2Abs [bar]'};
measData = searchForAllLabels(measurementData,measData,labelList,8);

%% pV [bar] (absolute)
labelList = {'pVAbs [bar]'};
measData = searchForAllLabels(measurementData,measData,labelList,9);

%% pOut/pU [bar] (absolute)
labelList = {'pUAbs [bar]'};
measData = searchForAllLabels(measurementData,measData,labelList,10);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('--> Referezsignal aus Messung erstellt.')
disp('------------------------------------')
disp(' ')

end




%% aux functions
function measData = searchForAllLabels(measurementData,measData,labelList,idx)
% Diese Hilfsfunktion arbeitet die Liste der übergebenen Labels ab, bis ein
% Signal mit diesem Label gefunden wurde.

	for i=1:length(labelList)
		data = PA_getDSpaceDataByLabel(measurementData,labelList(i));
		% Wenn der Rückgabewert nicht leer ist, wird das Signal übernommen
		% und die Schleife durchbrochen.
		if ~isempty(data)
			measData.signals.values(:,idx) = data;
			break
		end
		% Falls gar keines der übergebenen Labels gefunden wurde, wird eine
		% Warnung ausgegeben und der unveränderte struct zurückgegeben.
		if i==length(labelList)
			warning('createMeasSig:noSignal',['There is no signal with one ',...
				'of the given labels {',strjoin(labelList,', '),'}.'])
		end
	end
	
end