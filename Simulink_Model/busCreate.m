function [measData, busMeasData, measInfo] = aux_createMeasSignalSeries(measPath,measName)
%% create signal from measurement
disp(' ')
disp('------------------------------------')
disp('Reference signal for model identification')
disp('  ...')
try
 measurementData = load([measPath,measName]);
catch
 error('createMeasSig:loadMeas','WARNING: \nAn error occured while loading the measurement data.')
end

fldnm = fieldnames(measurementData);
measurementData = measurementData.(fldnm{1});

%% suppress warnings
warning('off','getDSpaceDataByLabel:noSignal')
% set them on, when closing the function or error occurs
cleanUp_warning = onCleanup(@() warning('on','getDSpaceDataByLabel:noSignal'));

%% generate reference signal
disp('  ... generating data and time signals...')


% compare the fildnames of the measurement with the bus in the model 
sys = evalin('base', 'sys');
syspath = evalin('base','sys_path');

load_system([syspath, sys]); %load the system if not loaded 

BusNames = strsplit(get_param(sys + "/busSolution/DataInBus", 'OutputSignals'), ',');

fldnms = PA_getDSpaceAllLabels(measurementData);
ask = false; 

for i = 1:length(BusNames)
    if ~any(strcmp(fldnms,BusNames{i}))
        ask = true;
        sigName = aux_DialogBoxBus(fldnms,BusNames{i});
        measurementData.Y((strcmp(fldnms,sigName) == 1)).Name = BusNames{i};
    end
end

if ask
    answer = questdlg('Save the new dataset?');
    if strcmp(answer,'Yes')
        [name,path] = uiputfile('*.mat*','Save dataset',measName(1:end-4)+"_mod" + ".mat");
        save([path,name],'measurementData')
    end
end

% read the field names again as they possible has been changed 
fldnms = PA_getDSpaceAllLabels(measurementData);

% empty struct
measData = struct();
% time signal
[timeHostService, timeOnChange] = PA_getDSpaceTime(measurementData);% PATL function



% data signals
for i=1:length(fldnms)
 str = fldnms{i};
 str(ismember(str,'^ ,.:;!%[]')) = [];

    data = PA_getDSpaceDataByLabel(measurementData,fldnms{i});% PATL function
    if length(data)==length(timeHostService)
        measData.(str) = timeseries(data,timeHostService,'Name',fldnms{i});
    elseif length(data)==length(timeOnChange)
        measData.(str) = timeseries(data,timeOnChange,'Name',fldnms{i});
    else
        warning('No timeline found.')
    end
 
end

% create and rename bus
busMeasData = PA_busCreate(measData); % PATL function
PA_busRename(busMeasData);

% save information about name and path
measInfo.Name = measName;
measInfo.Path = measPath;


disp('  ... set initial parameters')
init_param = find_system(bdroot + "/busSolution/Initial Parameters",'LookUnderMasks','all','BlockType','Constant');

for i = 1:length(init_param)
    %indx_param = fldnms
    param = strsplit(init_param{i}, '/');
    param = param{end};
    evalin('base',get_param(init_param{i}, 'Value') + " = " + num2str(measData.(param).Data(1,1,1)) + ";")
end

Ts = evalin('base','Ts');
assignin('base','measDataTimeSeries',measData);
assignin('base','maxSimTime',round(timeHostService(end)/Ts)*Ts);
close_system(sys);
%% disp area
disp('... done.')
disp('------------------------------------')
end