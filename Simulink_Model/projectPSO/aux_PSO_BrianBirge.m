function aux_PSO_BrianBirge(param4Opt,varargin)
%% starts the PSO for psoUI
% starting a PSO to identify the CMSI model
%
% the pso tries to find the minimum of the f6 function, a standard
% benchmark
%
% on the plots, blue is current position, green is Pbest, and red is Gbest
%

% if you want to run the PSO without setting the options by hand, you can
% adjust these settings at the arrows in the lower part

%% inputs
switch nargin
	case 1
		% alles gut
	case 6
		costFunc =	varargin{1};
		minmax =	varargin{2};
		mvden =		varargin{3};
		ps =		varargin{4};
		modl =		varargin{5};
	otherwise
		error('err:auxPSOBrianBirge:InputArguments','Number of input arguments is wrong.')
end

%% ADJUST THE SPECIFIC PREFERENCES FOR YOUR OPTIMISATION HERE %%%%%%%%%%%%%

% Parameters
paramNames = param4Opt(2:end,2);

% min/max Arrays
minX = cell2mat(param4Opt(2:end,3));
maxX = cell2mat(param4Opt(2:end,4));
      
dims = length(minX);
              
%%% NOTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% some PSO specific settings can be adjusted in the following part
%
% you can set default paremeters to skip manual input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% PROGRAM STARTS HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp(' ')
% disp('--- Runnging PSO ---')
% 
% disp('Are you sure that you have entered the correct ')
% beSure = input('cost function? [Y/N]','s');
% if strcmpi(beSure,'Y')
% 	disp(' ')
% elseif strcmpi(beSure,'N')
%     open('aux_PSO_for_psoUI')
%     error('Please set the right cost function!')
% else
%     error('wrong input')
% end
% 
% disp('Are you sure you have assigned the parameters')
% beSure = input('to be optimized and proper ranges? [Y/N]','s');
% if strcmpi(beSure,'Y')
% 	disp(' ')
% elseif strcmpi(beSure,'N')
%     open('funcOptiCMSIModel')
%     error('Please assign the parameters and their proper ranges!')
% else
%     error('wrong input')
% end
% 
% disp(' ');
% disp('1) Default PSO graphing, shows error trend and particle dynamics');
% disp('2) no plot, only final output shown, fastest');
% plotfcn=input('Choose plotting function ? ');
            % immer default wählen
            plotfcn=1;                                                   % <--------------

if plotfcn == 1
   plotfcn = 'goplotpso';
   shw     = 1;   % how often to update display
elseif plotfcn == 2
   plotfcn = 'goplotpso';
   shw     = 0;   % how often to update display
else
   plotfcn = 'goplotpso';
   shw     = 0;   % how often to update display
end

% no dynamic function
dyn_on = 0;

disp(' ');
% if =0 then we look for minimum, =1 then max
%   disp('0) Minimize')
%   disp('1) Maximize')
%   minmax=input('Choose search goal ?');
            % immer minimieren
%             minmax=0;                                                    % <--------------
            
%   disp(' ');
%   mvden = input('Max velocity divisor (2 is a good choice) ? ');
            % immer zu 2 gewählt
%             mvden = 2;                                                   % <--------------
            
%   disp(' ');
%   ps    = input('How many particles (24 - 30 is common)? ');  
            % immer 24 Partikel wählen
%             ps = 24;                                                     % <--------------
            
%   disp(' ');
%   disp('0) Common PSO - with inertia');
%   disp('1) Trelea model 1');
%   disp('2) Trelea model 2');
%   disp('3) Clerc Type 1" - with constriction');
%   modl  = input('Choose PSO model ? ');  
            % immer 'Common PSO' wählen
            % modl = 0;                                                    % <--------------
            
 % note: if errgoal=NaN then unconstrained min or max is performed
  if minmax==1
    %  errgoal=0.97643183; % max for f6 function (close enough for termination)
      errgoal=NaN;
  else
     % errgoal=0; % min
      errgoal=NaN;
  end
  
 % create array for vectorrange and velocity divisor
  varrange=[];
  mv=[];
  for i=1:dims
      varrange=[varrange;minX(i) maxX(i)];
      mv=[mv;(varrange(i,2)-varrange(i,1))/mvden];
  end
  
 %% PSO specific settings 
  ac          = [2.1,2.1];  % acceleration constants, only used for modl=0
  Iwt         = [0.9,0.4];  % intertia weights, only used for modl=0
  epoch       = 2000;       % max iterations
  wt_end      = 1500;       % iterations it takes to go from Iwt(1) to Iwt(2), only for modl=0
  errgrad     = 1e-25;      % lowest error gradient tolerance
  errgraditer = 100;        % max # of epochs without error change >= errgrad
  PSOseed     = 1;          % if=1 then can input particle starting positions, if= 0 then all random
                            % starting particle positions (first 20 at zero, just for an example)
  PSOseedValue = repmat([0],ps-10,1);
  PSOseedValue = (maxX-minX)/2+minX;	% initial particle position, depends on P(13), must be
										% set if P(13) is 1 or 2
  
  psoparams=...
   [shw epoch ps ac(1) ac(2) Iwt(1) Iwt(2) ...
    wt_end errgrad errgraditer errgoal modl PSOseed];

%% RUN THE PSO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % vectorized version
  [pso_out,tr,te]=pso_Trelea_vectorized(costFunc, dims,...
      mv, varrange, minmax, psoparams,plotfcn,PSOseedValue);
  
%% SHOW PSO RESULTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% display best params, this only makes sense for static functions, for dynamic
% you'd want to see a time history of expected versus optimized global best
% values.
disp(' ');
disp(' ');
disp(['Best fit parameters: ']);
disp([' cost = ',costFunc,'( [ input1, input2, ... ] )']);
disp(['---------------------------------']);
for i=1:(dims)                                                             % geändert für beliebig viele Parameter                         
    disp(['      ',paramNames{i},' = ',num2str(pso_out(i))]);
end
	% Warning for the calculation of Fstick and Fcoulomb
	if sum(strcmp(paramNames,'Fstick')) ...
			|| sum(strcmp(paramNames,'Fcoulomb')) ...
			|| sum(strcmp(paramNames,'Fc')) ...
			|| sum(strcmp(paramNames,'Fl'))
		disp(' ')
		disp('ATTENTION: due to summation of Fstick and Fcoulomb the shown values are not correct.')
		disp('Please see mdlPara for the correct ones.')
	end
disp(['---------------------------------']);
disp(['        cost = ',num2str(pso_out(dims+1))]);
disp(['   mean cost = ',num2str(mean(te))]);
disp([' # of epochs = ',num2str(tr(end))]);