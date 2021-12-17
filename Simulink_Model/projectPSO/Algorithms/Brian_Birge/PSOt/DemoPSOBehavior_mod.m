% demopsobehavior.m
% demo of the pso.m function
% the pso tries to find the minimum of the f6 function, a standard
% benchmark
%
% on the plots, blue is current position, green is Pbest, and red is Gbest

% Brian Birge
% Rev 3.0
% 2/27/06

% clear all
% close all
% clc
help demopsobehavior
warning off

%%% hier als letzte Funktion (oder wo auch immer) die eigene gewünschte
%%% Funktion eintragen
functnames = {'ackley','alpine','DeJong_f2','DeJong_f3','DeJong_f4',...
              'Foxhole','Griewank','NDparabola',...
              'Rastrigin','Rosenbrock','f6','f6mod','tripod','ackley',...
              'f6_bubbles_dyn','f6_linear_dyn','f6_spiral_dyn',...
              'mrft_opt_ise_second'};                                      % <--------------
          
disp('Static test functions, minima don''t change w.r.t. time/iteration:');
disp(' 1) Ackley');                                            
disp(' 2) Alpine');
disp(' 3) DeJong_f2');
disp(' 4) DeJong_f3');
disp(' 5) DeJong_f4');
disp(' 6) Foxhole');
disp(' 7) Griewank');
disp(' 8) NDparabola (for this demo N = 2)');
disp(' 9) Rastrigin');
disp('10) Rosenbrock');
disp('11) Schaffer f6');
disp('12) Schaffer f6 modified (5 f6 functions translated from each other)');
disp('13) Tripod');
disp('14) ackley');
disp(' ');
disp('Dynamic test functions, minima/environment evolves over time/iteration:');
disp('15) f6_bubbles_dyn');
disp('16) f6_linear_dyn');
disp('17) f6_spiral_dyn');
disp(' ');
disp('Dynamic test functions, minima/environment evolves over time/iteration:');
disp('18) mrft_opt_ise_second');

functchc=input('Choose test function ? ');

            % immer eigene Function wählen
            % functchc=18;                                                 % <--------------
            
functname = functnames{functchc};

disp(' ');
disp('1) Intense graphics, shows error topology and surfing particles');
disp('2) Default PSO graphing, shows error trend and particle dynamics');
disp('3) no plot, only final output shown, fastest');
plotfcn=input('Choose plotting function ? ');

            % immer default wählen
            % plotfcn=2;                                                   % <--------------
            
if plotfcn == 1
   plotfcn = 'goplotpso4demo';
   shw     = 1;   % how often to update display
elseif plotfcn == 2
   plotfcn = 'goplotpso';
   shw     = 1;   % how often to update display
else
   plotfcn = 'goplotpso';
   shw     = 0;   % how often to update display
end
   

% set flag for 'dynamic function on', only used at very end for tracking plots
dyn_on = 0;
if functchc==15 | functchc == 16 | functchc == 17
   dyn_on = 1;
end

%xrng=input('Input search range for X, e.g. [-10,10] ? ');
%yrng=input('Input search range for Y ? ');
% xrng=[-30,30];                                                           % auskommentiert
% yrng=[-40,40];                                                           % auskommentiert
disp(' ');
% if =0 then we look for minimum, =1 then max
  disp('0) Minimize')
  disp('1) Maximize')
  minmax=input('Choose search goal ?');
  
            % immer minimieren
            % minmax=0;                                                    % <--------------
            
  disp(' ');
  mvden = input('Max velocity divisor (2 is a good choice) ? ');
  
            % immer zu 2 gewählt
            % mvden = 2;                                                   % <--------------
            
  disp(' ');
  ps    = input('How many particles (24 - 30 is common)? ');
  
            % immer 24 Particel wählen
            % ps = 24;                                                     % <--------------
            
  disp(' ');
  disp('0) Common PSO - with inertia');
  disp('1) Trelea model 1');
  disp('2) Trelea model 2');
  disp('3) Clerc Type 1" - with constriction');
  modl  = input('Choose PSO model ? ');
  
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
%   minx = xrng(1);                                                        % auskommentiert
%   maxx = xrng(2);                                                        % auskommentiert
%   miny = yrng(1);                                                        % auskommentiert
%   maxy = yrng(2);                                                        % auskommentiert
  
            % zu untersuchender Intervall für die Parameter angeben
              minx(1) = -30;                                               % <--------------
              maxx(1) = 30;

              minx(2) = -40;
              maxx(2) = 40;

%--------------------------------------------------------------------------
            % Anzahl der Parameter festlegen
              dims = 2;                                                    % <--------------
              
  varrange=[];
  mv=[];
  for i=1:dims
      varrange=[varrange;minx(i) maxx(i)];
      mv=[mv;(varrange(i,2)-varrange(i,1))/mvden];
  end
  
  ac      = [2.1,2.1];% acceleration constants, only used for modl=0
  Iwt     = [0.9,0.6];  % intertia weights, only used for modl=0
  epoch   = 400; % max iterations
  wt_end  = 100; % iterations it takes to go from Iwt(1) to Iwt(2), only for modl=0
  errgrad = 1e-99;   % lowest error gradient tolerance
  errgraditer=100; % max # of epochs without error change >= errgrad
  PSOseed = 0;    % if=1 then can input particle starting positions, if= 0 then all random
  % starting particle positions (first 20 at zero, just for an example)
   PSOseedValue = repmat([0],ps-10,1);
  
  psoparams=...
   [shw epoch ps ac(1) ac(2) Iwt(1) Iwt(2) ...
    wt_end errgrad errgraditer errgoal modl PSOseed];

 % run pso
 % vectorized version
  [pso_out,tr,te]=pso_Trelea_vectorized(functname, dims,...
      mv, varrange, minmax, psoparams,plotfcn,PSOseedValue);


%-------------------------------------------------------------------------- 
% display best params, this only makes sense for static functions, for dynamic
% you'd want to see a time history of expected versus optimized global best
% values.
disp(' ');
disp(' ');
disp(['Best fit parameters: ']);
disp([' cost = ',functname,'( [ input1, input2, ... ] )']);
disp(['---------------------------------']);
for i=1:(dims)                                                             % geändert für beliebig viele Parameter                         
    disp(['      input',num2str(i),' = ',num2str(pso_out(i))]);
end
% disp(['      input1 = ',num2str(pso_out(1))]);                           % auskommentiert
% disp(['      input2 = ',num2str(pso_out(2))]);                           % auskommentiert
disp(['        cost = ',num2str(pso_out(dims+1))]);
disp(['   mean cost = ',num2str(mean(te))]);
disp([' # of epochs = ',num2str(tr(end))]);

%% optional, save picture
%set(gcf,'InvertHardcopy','off');
%print -dmeta
%print('-djpeg',['demoPSOBehavior.jpg']);