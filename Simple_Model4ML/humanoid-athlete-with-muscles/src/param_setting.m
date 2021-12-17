%% Parameter Setting

%% Dimensions
% Floor
param.floor.x = 8; % [m]
param.floor.y = 8; % [m]
param.floor.z = 0.05; % [m]
param.floor.dim = [param.floor.x param.floor.y param.floor.z];

% Wall
param.wall.x = 8; % [m]
param.wall.y = 0.05; % [m]
param.wall.z = 8; % [m]
param.wall.dim = [param.wall.x param.wall.y param.wall.z];
param.wall.pos = [0 param.floor.y/2 param.wall.z/2]; % Floor2Wall


% Ball
param.ball.r = 0.15; % [m]
param.ball.pos = [0 0 param.ball.r+param.floor.z/2]; % Floor2ball
param.ball.mass = 0.1; % [kg]


%% Dimensions: Skeleton
param.bone.w = 0.05;

% Hip
param.hip.l = 0.18783;
param.hip.dim = [param.hip.l param.bone.w param.bone.w];
param.hip.mass = 10.2516; % [kg]

% Upper leg
param.ul.l = 0.4347;
param.ul.dim = [param.bone.w param.bone.w param.ul.l];
param.ul.mass = 8.1719; % [kg]

% Lower leg
param.ll.l = 0.4239;
param.ll.dim = [param.bone.w param.bone.w param.ll.l];
param.ll.mass = 3.3541; % [kg]

% Foot
param.foot.x = 0.15;
param.foot.y = 0.272;
param.foot.z = param.bone.w;
param.foot.dim = [param.foot.x param.foot.y param.foot.z];
param.foot.pos.ball = 0.25;
param.foot.mass = 1.0172; % [kg]



%% Position
% Root
param.root.pos.hip = [-param.hip.l 0 0];

% Hip
param.hip.pos.ul = [-(param.bone.w/2+param.hip.l/2) 0 -(param.bone.w/2+param.ul.l/2)]; % Left
param.hip.pos.ul_x = param.hip.pos.ul(1);
param.hip.pos.ul_z = param.hip.pos.ul(3);

% Upper leg
param.ul.pos.ll = [0 0 -(param.ul.l/2+param.ll.l/2)]; % Left
param.ul.pos.hip = [(param.bone.w/2+param.hip.l/2) 0 -(param.bone.w/2+param.ul.l/2)]; % Right
param.ul.pos.knee = [0 0 -param.ul.l/2];

% Lower leg
param.ll.pos.foot = [0 param.foot.y/2 -(param.foot.z/2+param.ll.l/2)]; % Left
param.ll.pos.knee = [0 0 -param.ll.l/2]; % Right

% Foot
param.foot.pos.floor = [(param.bone.w+2*param.hip.l) 
    param.foot.pos.ball 
    -(param.floor.z/2+param.foot.z/2)]; % Left

