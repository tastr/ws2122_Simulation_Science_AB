addpath(".\Sam\sdnchen-psomatlab-b4c4a1e")

costFunc = @(x) cost_function(x)
nvars = 16;

Aineq = zeros(16);
bineq = zeros(16,1);
Aeq = zeros(16);
beq = zeros(16,1);

LB = zeros(16,1);
UB = ones(16,1);

nonlcon = [];
options = psooptimset('ConstrBoundary','soft','PlotFcns',{@psoplotbestf,@psoplotswarmsurf},...
	'Generations',50,'PopulationSize',40,'TolFun',1);
target_position = [0,0,-1]
res_nb = 0;
[x,fval,exitflag,output,population,scores] = pso(costFunc,nvars,Aineq,bineq,Aeq,beq,LB,UB,nonlcon,options);
