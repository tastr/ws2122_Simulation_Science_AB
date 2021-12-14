function aux_PSP_Sam(param4Opt,varargin)
%% helps you starting the (constrained) PSO (Sam)
% starting a PSO to identify the CMSI model
%
% the pso tries to find the minimum of the given fitness function
%
% on the plots, blue is current position, green is Pbest, and red is Gbest
%
%
% if you want to run the PSO without setting the options by hand, you can
% give default settings at the arrows in the lower part

%% inputs
switch nargin
	case 1
		% alles gut
	case 2
		costFunc = varargin{1};
% 		minmax = varargin{2};
% 		mvden = varargin{3};
% 		ps = varargin{4};
% 		modl = varargin{5};
	otherwise		
		error('err:auxPSOSam:InputArguments','Number of input arguments is wrong.')
end

%% ADJUST THE SPECIFIC PREFERENCES FOR YOUR OPTIMISATION HERE %%%%%%%%%%%%%

% cost function (if not given as parameter)
% costFunc = @common_files.funcOptiCMSIModel;
% costFunc = @myTestFunction;

% Parameters names
paramNames = param4Opt(2:end,2);

% NOTE:
% Use empty arrays [] for Aineq, bineq, Aeq, beq, LB, or UB if they are not needed.

% min/max Arrays
% Lower and upper bounds defined as LB and UB respectively.
% Both LB and UB, if defined, should be 1 x nvars vectors.
LB = cell2mat(param4Opt(2:end,3))';
UB = cell2mat(param4Opt(2:end,4))';

% number of parameters going to be optimised
nvars = length(LB);

% Linear (in)equality constraints in the form:
%	Aineq * x <= bineq
%	Aeq   * x =	 beq
Aineq	= [];
bineq	= [];
Aeq		= [];
beq		= [];

% Non-linear constraints
%	Nonlinear inequality constraints in the form 
%	c(x) <= 0 
%	have now been implemented using 'soft' boundaries, or experimentally, 
%	using 'penalize' constraint handling method. See the Optimization Toolbox 
%	documentation for the proper syntax for defining nonlinear constraints.
nonlcon = [];

%% Unterscheidung welche Parameter optimiert werden und wie sie im Zusammenhang stehen
% load mdlPara from workspace to compare/load limits
mdlPara = evalin('base','mdlPara;');

% 1st row: Fstick > Fcoulomb
if sum(strcmp(paramNames,'Fstick')) ...
			|| sum(strcmp(paramNames,'Fcoulomb'))
		% built Aineq and bineq if empty
		if isempty(Aineq)
			Aineq = zeros(nvars);
			bineq = zeros(nvars,1);
		end
		
		posFs = find(strcmp(paramNames,'Fstick'),1,'first');
		posFc = find(strcmp(paramNames,'Fcoulomb'),1,'first');
		Aineq(1,posFs) = -1;
		Aineq(1,posFc) = 1;
		bineq(1) = -.01;
end

% 2nd row: pv > pu
if sum(strcmp(paramNames,'pv')) ...
			|| sum(strcmp(paramNames,'pu'))
		% built Aineq and bineq if empty
		if isempty(Aineq)
			Aineq = zeros(nvars);
			bineq = zeros(nvars,1);
		end
		
		posPv = find(strcmp(paramNames,'pv'),1,'first');
		posPu = find(strcmp(paramNames,'pu'),1,'first');
		
		if ~isempty(posPv) && ~isempty(posPu)
			Aineq(2,posPv) = -1;
			Aineq(2,posPu) = 1;
			bineq(2) = 1e-5;
		elseif ~isempty(posPv) && isempty(posPu)
			if LB(posPv) < mdlPara.pu
				LB(posPv) = mdlPara.pu;
			end
		elseif isempty(posPv) && ~isempty(posPu)
			if UB(posPu) > mdlPara.pv
				UB(posPu) = mdlPara.pv;
			end
		else
			error('constraints:PvPu','An error occured with generating the constraints for pressures.')
		end
end

% 3rd row: PinionMstick > PinionMcoulomb
if sum(strcmp(paramNames,'PinionMstick')) ...
			|| sum(strcmp(paramNames,'PinionMcoulomb'))
		% built Aineq and bineq if empty
		if isempty(Aineq)
			Aineq = zeros(nvars);
			bineq = zeros(nvars,1);
		end
		
		posPMs = find(strcmp(paramNames,'PinionMstick'),1,'first');
		posPMc = find(strcmp(paramNames,'PinionMcoulomb'),1,'first');
		Aineq(3,posPMs) = -1;
		Aineq(3,posPMc) = 1;
		bineq(3) = -.01;
end

%%% Ende der Unterscheidung %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Options
%   Default algorithm parameters replaced with those defined in the options
%   structure:
%   Use >> options = psooptimset('Param1,'value1','Param2,'value2',...) to
%   generate the options structure. Type >> psooptimset with no input or
%   output arguments to display a list of available options and their
%   default values.
% options = psooptimset('ConstrBoundary','penalize','PlotFcns',{@psoplotbestf,@psoplotswarmsurf});
options = psooptimset('ConstrBoundary','soft','PlotFcns',{@psoplotbestf,@psoplotswarmsurf},...
	'Generations',100,'PopulationSize',20,'TolFun',1);

%% run the pso
[x,fval,exitflag,output,population,scores] = pso(costFunc,nvars,Aineq,bineq,Aeq,beq,LB,UB,nonlcon,options);
% run once again with the best parameters
costFunc(x);

%% calc  Root Mean Square Error
posMeas  = evalin('base','simData.signals.values(:,1);');
posSim   = evalin('base','simData.signals.values(:,2);');
e        = posMeas - posSim;
rmsError = sqrt(sum(power(e,2))/length(e));

%% SHOW PSO RESULTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% display best params, this only makes sense for static functions, for dynamic
% you'd want to see a time history of expected versus optimized global best
% values.
disp(' ');
disp(' ');
disp(['Best fit parameters: ']);
disp([' cost = ',func2str(costFunc),'( [ input1, input2, ... ] )']);
disp(['---------------------------------']);
for i=1:(nvars)                                                             % geändert für beliebig viele Parameter                         
    disp(['      ',paramNames{i},' = ',num2str(x(i))]);
end
disp(['---------------------------------']);
disp(['        cost = ',num2str(fval)]);
 disp(['   root mean square error = ',num2str(rmsError)]);
% disp(['   mean cost = ',num2str(mean(te))]);
% disp([' # of epochs = ',num2str(tr(end))]);

end