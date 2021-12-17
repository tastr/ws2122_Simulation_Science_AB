function varargout = projectPSO(varargin)
% PROJECTPSO MATLAB code for projectPSO.fig
%      PROJECTPSO, by itself, creates a new PROJECTPSO or raises the existing
%      singleton*.
%
%      H = PROJECTPSO returns the handle to a new PROJECTPSO or the handle to
%      the existing singleton*.
%
%      PROJECTPSO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECTPSO.M with the given input arguments.
%
%      PROJECTPSO('Property','Value',...) creates a new PROJECTPSO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before projectPSO_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to projectPSO_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help projectPSO

% Last Modified by GUIDE v2.5 27-Sep-2017 09:48:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @projectPSO_OpeningFcn, ...
                   'gui_OutputFcn',  @projectPSO_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end


% --- Executes just before projectPSO is made visible.
function projectPSO_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to projectPSO (see VARARGIN)

% Choose default command line output for projectPSO
handles.output = hObject;

%% create a cleanUp object
	origPath	= path;
	origDir		= pwd;
	
cleanupObj		= onCleanup(@()common_func.cleanUpFunc(origPath,origDir));

% restore buttons in case of a stopped pso
handles.pushbutton_startPSO.Enable	= 'on';
handles.pushbutton_stopPSO.Enable	= 'off';

% adjust width of the 5th column
handles.uitable_parameters.ColumnWidth{5} = 250;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes projectPSO wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = projectPSO_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

%% choose pso algo
% --- Executes on selection change in popup_PSOAlgo.
function popup_PSOAlgo_Callback(hObject, eventdata, handles)
% hObject    handle to popup_PSOAlgo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_PSOAlgo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_PSOAlgo
data = guidata(hObject);

contents = cellstr(get(hObject,'String'));
data.usr.psoAlgo = contents{get(hObject,'Value')};

guidata(hObject,data)
end


% --- Executes during object creation, after setting all properties.
function popup_PSOAlgo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_PSOAlgo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

data = guidata(hObject);

contents = cellstr(get(hObject,'String'));
data.usr.psoAlgo = contents{get(hObject,'Value')};

guidata(hObject,data)

end

%% load mesaurement
% --- Executes on button press in pushbutton_loadNewMeasurement.
function pushbutton_loadNewMeasurement_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_loadNewMeasurement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = guidata(hObject);

% load measurements
[measData, busMeasData, data.usr.measInfo] = common_func.aux_createMeasSignalSeries();
	% assign measurement to base
	assignin('base','measDataTimeSeries',measData);
	assignin('base','busMeasData', busMeasData);
% show measurement name
data.text_measurement.String = data.usr.measInfo.Name;
% get max sim time
fldNames = fieldnames(measData);
maxSimTime = round(max(get(measData.(fldNames{1}),'Time')))-1;
data.text_measTime.String = ['Max. simulation time: ',num2str(maxSimTime),'sec'];
% set max sim time as simulation time, if no time is set
if str2double(data.edit_simTime.String) == 0
	data.edit_simTime.String = maxSimTime;
	data.usr.simTime = maxSimTime;
end

% get, set and show initial conditions
aux_convStruct;
	% supply pressure
	try
		data.edit_initSuppPressure.String = measData.pVAbsPa.Data(1,1,1);
		evalin('base',['mdlPara.pv = double(',num2str(round(measData.pVAbsPa.Data(1,1,1))),');'])
	catch
		listPressureUnits = {'Pascals rel.','Pascals abs.',...
							'Bars rel.','Bars abs.'};
		[sigName,sigUnit] = common_func.aux_psoDialogBox('supply pressure pv',listPressureUnits,measData);
		% get choosen signal
		thisPressure = measData.(sigName).Data(1,1,1);
		
		% is it in [bar]?
		if any(strcmp(sigUnit,listPressureUnits(3:4)))
			thisPressure = thisPressure * conv.bar2Pa;
		end
		% is it rel.?
		if any(strcmp(sigUnit,listPressureUnits([1,3])))
			thisPressure = thisPressure + 1 * conv.bar2Pa;
		end
		
		thisPressure = num2str(round(thisPressure));
		data.edit_initSuppPressure.String = thisPressure;
		evalin('base',['mdlPara.pv = double(',thisPressure,');'])
	end
	
	% initial pressure p02
	try
		data.edit_initPressure2.String = measData.p2AbsPa.Data(1,1,1);
		evalin('base',['mdlPara.p02 = double(',num2str(round(measData.p2AbsPa.Data(1,1,1))),');'])
	catch
		listPressureUnits = {'Pascals rel.','Pascals abs.',...
							'Bars rel.','Bars abs.'};
		[sigName,sigUnit] = common_func.aux_psoDialogBox('initial pressure p02',listPressureUnits,measData);
		% get choosen signal
		thisPressure = measData.(sigName).Data(1,1,1);
		
		% is it in [bar]?
		if any(strcmp(sigUnit,listPressureUnits(3:4)))
			thisPressure = thisPressure * conv.bar2Pa;
		end
		% is it rel.?
		if any(strcmp(sigUnit,listPressureUnits([1,3])))
			thisPressure = thisPressure + 1 * conv.bar2Pa;
		end
		
		thisPressure = num2str(round(thisPressure));
		data.edit_initPressure2.String = thisPressure;
		evalin('base',['mdlPara.p02 = double(',thisPressure,');'])
	end
	
	% initial pressure p04, if DA or DFPI
	thisVariant = evalin('base','mdlPara.variant;');
	if contains(thisVariant,'DFPI')||contains(thisVariant,'DA')||contains(thisVariant,'RD')
		try
			data.edit_initPressure4.String = measData.p4AbsPa.Data(1,1,1);
			evalin('base',['mdlPara.p04 = double(',num2str(round(measData.p4AbsPa.Data(1,1,1))),');'])
		catch
			listPressureUnits = {'Pascals rel.','Pascals abs.',...
								'Bars rel.','Bars abs.'};
			[sigName,sigUnit] = common_func.aux_psoDialogBox('initial pressure p04',listPressureUnits,measData);
			% get choosen signal
			thisPressure = measData.(sigName).Data(1,1,1);

			% is it in [bar]?
			if any(strcmp(sigUnit,listPressureUnits(3:4)))
				thisPressure = thisPressure * conv.bar2Pa;
			end
			% is it rel.?
			if any(strcmp(sigUnit,listPressureUnits([1,3])))
				thisPressure = thisPressure + 1 * conv.bar2Pa;
			end

			thisPressure = num2str(round(thisPressure));
			data.edit_initPressure.String4 = thisPressure;
			evalin('base',['mdlPara.p04 = double(',thisPressure,');'])
		end
	else
		data.edit_initPressure.String4 = '-';
	end
	
	% initial position
	try
		data.edit_initPosition.String = measData.PositionRel.Data(1,1,1);
		evalin('base',['mdlPara.x0 = double(',num2str(round(measData.PositionRel.Data(1,1,1))),'* mdlPara.conv.pr2m);'])	
	catch
		listPosUnits = {'%','m','mm','rad'};
		[sigName,sigUnit] = common_func.aux_psoDialogBox('initial position x0',listPosUnits,measData);
		% get choosen signal
		thisPos = round(measData.(sigName).Data(1,1,1));

		% switch between given units
		switch sigUnit
			case listPosUnits(1) % % (it's the same for transl. and rot.)
				thisPos = num2str(thisPos);
				data.edit_initPosition.String = num2str(thisPos);
				evalin('base',['mdlPara.x0 = double(',thisPos, ...			% with conversion from % to m
					'* mdlPara.conv.pr2m);'])
			case listPosUnits(2) % m
				data.edit_initPosition.String = num2str(thisPos * ...		% convert m to %
					evalinin('base','mdlPara.conv.m2pr')); 
				evalin('base',['mdlPara.x0 = double(',num2str(thisPos),');'])
			case listPosUnits(3) % mm
				thisPos = thisPos * conv.mm2m;								% convert mm to m
				data.edit_initPosition.String = num2str(thisPos * ...		% convert m to %
					evalinin('base','mdlPara.conv.m2pr')); 
				evalin('base',['mdlPara.x0 = double(',thisPos,');'])
			case listPosUnits(4) % rad
				thisPos = thisPos * evalinin('base','mdlPara.conv.rad2pr'); % convert rad to %
				data.edit_initPosition.String = num2str(thisPos);
				evalin('base',['mdlPara.x0 = double(',thisPos, ...			% with conversion from % to m
					'* mdlPara.conv.pr2m);'])
			otherwise
				error('err:unitConv',...
					'ERROR:\nCan''t convert the given unit ''%s''.',sigUnit)
		end
		
	end
	
guidata(hObject,data)

end

%% choose model
% --- Executes on button press in pushbutton_chooseModel.
function pushbutton_chooseModel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_chooseModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = guidata(hObject);

% choose the model
dlgTitle = 'Choose the model for PSO';
dlgDefPath = fullfile(cd,'+models',filesep);
dlgDefAns = [dlgDefPath,'Positioner_MdlIdent.slx'];

[sysName, sysPath] = uigetfile( ...
    [dlgDefPath,'*.slx'],dlgTitle,dlgDefAns,'MultiSelect', 'off');
data.usr.system = fullfile(sysPath,sysName);

% show model/system name
data.text_model.String = sysName;

% load model
initFunc = str2func(['aux_initMdlPara',strrep(sysName,'_MdlIdent.slx','')]);
% eval(['models.aux_loadMdl_',sysName(1:end-4),'(''',data.usr.system,''')']);	% old solution with load function for each model
eval(['models.aux_loadMdl_PSO(initFunc,''',data.usr.system,''')']);

% show variant
data.edit_modelVariant.String = evalin('base','mdlPara.variant;');

guidata(hObject,data)
end

%% start PSO
% --- Executes on button press in pushbutton_startPSO.
function pushbutton_startPSO_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_startPSO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set flag for stopping pso
% this flag is global, beacause the ease of use, it's not comfiy to pass it
% through all functions
global flag_stopPSONow
flag_stopPSONow= false;

handles.pushbutton_startPSO.Enable	= 'off';
handles.pushbutton_stopPSO.Enable	= 'on';

data = guidata(hObject);

includeArray = cell2mat(data.uitable_parameters.Data(:,2));
% paramNames = data.uitable_parameters.RowName(includeArray);
paramSymbol = data.uitable_parameters.Data(includeArray,1);
paramMin = data.uitable_parameters.Data(includeArray,3);
paramMax = data.uitable_parameters.Data(includeArray,4);
paramNames = data.uitable_parameters.Data(includeArray,5);

param4Opt		= cell(sum(includeArray)+1,4);
param4Opt(1,:)	= {'NAME', 'SYMBOL', 'MIN', 'MAX'};
param4Opt(2:end,1) = paramNames;
param4Opt(2:end,2) = paramSymbol;
param4Opt(2:end,3) = paramMin;
param4Opt(2:end,4) = paramMax;

data.usr.param4Opt = param4Opt;

% assign user data in base workspace
assignin('base','param4Opt',param4Opt);
assignin('base','simTime',data.usr.simTime)
assignin('base','system',data.usr.system)

% swtich algo
algoDir = fullfile(fileparts(mfilename('fullpath')),'Algorithms');

switch data.usr.psoAlgo
	case 'Sam'
		% Add your local path for Sam's PSO, check if there are (useful) updates:
		addpath(genpath(fullfile(algoDir,'Sam','sdnchen-psomatlab-b4c4a1e')))
		
		% get pso options
		costFunc = data.popupmenu_costFunc.String(data.popupmenu_costFunc.Value,:);
		costFunc = eval(['@cost_functions.',costFunc{1}]);
		
		% start pso
		aux_PSP_Sam(param4Opt,costFunc)
		
	case 'BrianBirge'
		% Add your local path for Brian's PSO, check if there are (useful) updates:
		addpath(genpath(fullfile(algoDir,'Brian_Birge','PSOt')))
		
		% get pso options
		costFunc = data.popupmenu_costFunc.String(data.popupmenu_costFunc.Value,:);
		costFunc = ['cost_functions.',costFunc{1}];
			if data.radiobutton_minimise.Value == 1
				minmax = 0; 
			elseif data.radiobutton_maximise.Value == 1
				minmax =  1;
			else
				error('err:noMinMax','No desicion if minimise or maximise.')
			end
		mvden = str2double(data.edit_velDivisor.String);
		ps = str2double(data.edit_particles.String);
		modl = str2double(data.popupmenu_psoModel.String(data.popupmenu_psoModel.Value,1));
		
		% start pso
		aux_PSO_BrianBirge(param4Opt,costFunc,minmax,mvden,ps,modl)
end

handles.pushbutton_startPSO.Enable	= 'on';
handles.pushbutton_stopPSO.Enable	= 'off';

guidata(hObject,data)
end


%% edit sim time
function edit_simTime_Callback(hObject, eventdata, handles)
% hObject    handle to edit_simTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_simTime as text
%        str2double(get(hObject,'String')) returns contents of edit_simTime as a double
data = guidata(hObject);

data.usr.simTime = str2double(get(hObject,'String'));

guidata(hObject,data)
end

%% toggle min/max
% --- Executes on button press in radiobutton_minimise.
function radiobutton_minimise_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_minimise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_minimise
data = guidata(hObject);

% toggle min/max radio button
thisValue = get(hObject,'Value');
data.radiobutton_minimise.Value = thisValue;
data.radiobutton_maximise.Value = ~thisValue;

guidata(hObject,data)
end


% --- Executes on button press in radiobutton_maximise.
function radiobutton_maximise_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_maximise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_maximise
data = guidata(hObject);

% toggle min/max radio button
thisValue = get(hObject,'Value');
data.radiobutton_minimise.Value = ~thisValue;
data.radiobutton_maximise.Value = thisValue;

guidata(hObject,data)
end


% --- Executes on button press in pushbutton_stopPSO.
function pushbutton_stopPSO_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_stopPSO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global flag_stopPSONow
flag_stopPSONow = true;

end


% --- Executes on selection change in popupmenu_costFunc.
function popupmenu_costFunc_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_costFunc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_costFunc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_costFunc
data = guidata(hObject);

contents = cellstr(get(hObject,'String'));
data.usr.costFunc = contents{get(hObject,'Value')};

guidata(hObject,data)
end


% --- Executes during object creation, after setting all properties.
function popupmenu_costFunc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_costFunc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

data = guidata(hObject);

costFunc = dir(fullfile(cd,'+cost_functions','*.m'));
costFuncName = cell(length(costFunc),1);
for i=1:length(costFunc)
	costFuncName{i} = costFunc(i).name(1:end-2);
end
hObject.String = costFuncName;

guidata(hObject,data)
end


%% unused functions

% --- Executes during object creation, after setting all properties.
function edit_simTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_simTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


% --- Executes during object creation, after setting all properties.
function uitable_parameters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable_parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
end


function edit_velDivisor_Callback(hObject, eventdata, handles)
% hObject    handle to edit_velDivisor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_velDivisor as text
%        str2double(get(hObject,'String')) returns contents of edit_velDivisor as a double
end


% --- Executes during object creation, after setting all properties.
function edit_velDivisor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_velDivisor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit_particles_Callback(hObject, eventdata, handles)
% hObject    handle to edit_particles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_particles as text
%        str2double(get(hObject,'String')) returns contents of edit_particles as a double
end


% --- Executes during object creation, after setting all properties.
function edit_particles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_particles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on selection change in popupmenu_psoModel.
function popupmenu_psoModel_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_psoModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_psoModel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_psoModel
end


% --- Executes during object creation, after setting all properties.
function popupmenu_psoModel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_psoModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton_loadNewMeasurement.
function pushbutton_loadNewMeasurement_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_loadNewMeasurement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


function edit_initPressure2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_initPressure2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_initPressure2 as text
%        str2double(get(hObject,'String')) returns contents of edit_initPressure2 as a double
end


% --- Executes during object creation, after setting all properties.
function edit_initPressure2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_initPressure2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit_initPosition_Callback(hObject, eventdata, handles)
% hObject    handle to edit_initPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_initPosition as text
%        str2double(get(hObject,'String')) returns contents of edit_initPosition as a double
end


% --- Executes during object creation, after setting all properties.
function edit_initPosition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_initPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit_initSuppPressure_Callback(hObject, eventdata, handles)
% hObject    handle to edit_initSuppPressure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_initSuppPressure as text
%        str2double(get(hObject,'String')) returns contents of edit_initSuppPressure as a double
end


% --- Executes during object creation, after setting all properties.
function edit_initSuppPressure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_initSuppPressure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit_modelVariant_Callback(hObject, eventdata, handles)
% hObject    handle to edit_modelVariant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_modelVariant as text
%        str2double(get(hObject,'String')) returns contents of edit_modelVariant as a double
end


% --- Executes during object creation, after setting all properties.
function edit_modelVariant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_modelVariant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function edit_initPressure4_Callback(hObject, eventdata, handles)
% hObject    handle to edit_initPressure4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_initPressure4 as text
%        str2double(get(hObject,'String')) returns contents of edit_initPressure4 as a double
end


% --- Executes during object creation, after setting all properties.
function edit_initPressure4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_initPressure4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end