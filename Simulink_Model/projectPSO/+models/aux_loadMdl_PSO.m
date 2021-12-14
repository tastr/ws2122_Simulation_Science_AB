function aux_loadMdl_PSO(varargin)
%% function to load the model and set environment for the pso

switch nargin
	case 1
		initFunc	= varargin{1};
	case 2
		initFunc	= varargin{1};		
		caller		= varargin{2};
	otherwise
		initFunc	= []; %muss noch implementiert werden: Auswählen der init function
		caller		= [];
end

% load or generate mdlPara
assignin('base','mdlPara',feval(initFunc));
% load the conversion struct
evalin('base','aux_convStruct')

if strcmp(caller,'model')
	% load measurement
	[measDataTimeSeries, busMeasData, ~] = common_func.aux_createMeasSignalSeries;
	fldNames = fieldnames(measDataTimeSeries);
	simTime = round(max(get(measDataTimeSeries.(fldNames{1}),'Time')))-1;
	set_param(bdroot,'StopTime',num2str(simTime))
	% assign in base
	assignin('base', 'measDataTimeSeries', measDataTimeSeries)
	assignin('base', 'busMeasData', busMeasData)
end

end