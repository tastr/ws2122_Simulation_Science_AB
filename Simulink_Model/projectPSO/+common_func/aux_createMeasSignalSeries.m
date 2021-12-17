function [measData, busMeasData, measInfo] = aux_createMeasSignalSeries()
%% create signal from measurement
disp(' ')
disp('------------------------------------')
disp('Reference signal for model identification')
disp('  ...')

%% load measurement
dlgTitle = 'From which measurement do you want to create your reference signals?';
dlgDefPath = 'M:\ORG_Process_Automation\Dev_Electronics\50_Archiv\MessablageRT\';
dlgDefAns = [dlgDefPath,'rec_mdlIdent_005.mat'];

[measName, measPath] = uigetfile( ...
    [dlgDefPath,'*.mat'],dlgTitle,dlgDefAns,'MultiSelect', 'off');

disp(['  ... trying to load ''', measName, ''' for reference signal...'])
try
	measurementData = load([measPath,measName]);
catch
	error('createMeasSig:loadMeas','WARNING: \nAn error occured while loading the measurement data.')
end

fldnm = fieldnames(measurementData);
measurementData = measurementData.(fldnm{1});

%% suppress warngings
warning('off','getDSpaceDataByLabel:noSignal')
% set them on, when closing the function or error occurs
cleanUp_warning = onCleanup(@() warning('on','getDSpaceDataByLabel:noSignal'));

%% generate reference signal
disp('  ... generating data and time signals...')

fldnms = PA_getDSpaceAllLabels(measurementData);
% empty struct
measData = struct();
% time signal
[timeHostService, timeOnChange] = PA_getDSpaceTime(measurementData);
% data signals
for i=1:length(fldnms)
	str = fldnms{i};
	str(ismember(str,'^ ,.:;!%[]')) = [];
	
	data = PA_getDSpaceDataByLabel(measurementData,fldnms{i});
	
	if length(data)==length(timeHostService)
		measData.(str) = timeseries(data,timeHostService,'Name',fldnms{i});
	elseif length(data)==length(timeOnChange)
		measData.(str) = timeseries(data,timeOnChange,'Name',fldnms{i});
	else
		warning('No timeline found.')
	end
	
end

% create and rename bus
busMeasData = PA_busCreate(measData);
PA_busRename(busMeasData);

% save information about name and path
measInfo.Name = measName;
measInfo.Path = measPath;

%% disp area
disp('... done.')
disp('------------------------------------')
end