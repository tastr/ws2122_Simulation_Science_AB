%% init_model_parameter
% all the model parameters are used for the multibody blocks. Here the
% sized of the body and transformation vectors are listed. Also are defined
% the sized and transformations of the stuff like wall, ball and floor.
% The stiffness and damping coeficient are also to be defined here in
% bodyparam.stiffness.<bodypart> or bodyparam.damping.<bodypart>. 
% 
% The structures collected here: 
% bodyparam: the parameters used for the body assembling; 
%            contains the sub structures 
%            bodyparam.size:     the sized of the body elements,
%            bodyparam.position: the information for the trafos for the
%            model assembling
%            bodyparam.weight:   the weight of the body elements
%            bodyparam.stiffness and body.damping: the stiffnes and damping
%            parameters for the joints
%            bodyparam.d1: distance proximal joint to the bodys center of mass
%            bodyparam.sp and bodyparam.inertia: the center of mass and
%            inertia
%            bodyparam.r: muscle laverage
%            bodyparam.maxlim and bodyparam.minlim: the minimal and maximal
%            limit for the according joints 
%            
%            
% staffparam: the parameters of the surrounding objects; 
%             contains the substurctures:
%             staffparam.dimensions and staffparam.position: the the size and
%             transformation infos 



%%


%% dimensions

% head
bodyparam.size.head  = [.0993 .0778 .278194];%
bodyparam.size.neck = [.01 .01 .1];

%arms
bodyparam.size.upperarm = [.0495 .0495 .3065];%[.32 .01 .01];
bodyparam.size.lowerarm = [.0477 .0477 .2725];
bodyparam.size.hand     = [.028 .089 .0192];

% body
bodyparam.size.body = [.1224 .1643 .4166];

% hip 
bodyparam.size.hip = [.1224 .1643 .18783];

%legs   
bodyparam.size.upperleg = [.0947 .0947 0.4347];
bodyparam.size.lowerleg = [.0597 .0597  0.4239];
bodyparam.size.foot = [0.0398, 0.0398, 0.272];


bodyparam.size.leg = [bodyparam.size.lowerleg(1:2), bodyparam.size.lowerleg(3) + bodyparam.size.upperleg(3)];


bodyparam.size.bodyheight = bodyparam.size.head(3) + bodyparam.size.body(3) + bodyparam.size.leg(3); 
bodyparam.size.lowerbodyheight = bodyparam.size.leg(3) + 1/2*bodyparam.size.hip(3);

% balls for the joints visualizations
bodyparam.size.jointballs = .02; 
bodyparam.size.jointballs_hip = .04; 

%% weights
bodyparam.weight.pelvis   = 10.2516; %[kg] 
bodyparam.weight.upperleg = 8.1719;  %[kg]
bodyparam.weight.lowerleg = 3.3541;  %[kg]
bodyparam.weight.foot     = 1.0172;  %[kg] 

%% Transormations:

% UPPER BODY

% head
bodyparam.position.head = [0 0 bodyparam.size.head(3)/2];
bodyparam.position.neck = [0 0 -bodyparam.size.neck(3)/2];
%neck
bodyparam.position.neck = [0 0 bodyparam.size.body(3)/2];
% arms
bodyparam.position.right.lowerarm = [0 0 bodyparam.size.upperarm(3)/2 + bodyparam.size.lowerarm(3)/2];
bodyparam.position.left.lowerarm = [0 0 bodyparam.size.upperarm(3)/2 + bodyparam.size.lowerarm(3)/2];

bodyparam.position.right.upperarm = [0 0 bodyparam.size.upperarm(3)/2];
bodyparam.position.left.upperarm = [0 0 bodyparam.size.upperarm(3)/2];

% body
bodyparam.position.body = [0, 0, bodyparam.size.body(3)/2];


% LOWER BODY 

% hip
bodyparam.position.hip  = [0, 0,  bodyparam.size.body(3)/2];

% upper legs
bodyparam.position.right.upperleg.joint = [0, bodyparam.size.hip(1)/2, bodyparam.size.upperleg(1)/2];
bodyparam.position.right.upperleg.item =  [0, 0, bodyparam.size.upperleg(3)/2];

bodyparam.position.left.upperleg.joint = [0, -bodyparam.size.hip(1)/2, bodyparam.size.upperleg(1)/2];
bodyparam.position.left.upperleg.item =  [0, 0, bodyparam.size.upperleg(3)/2];


% lower legs
bodyparam.position.right.lowerleg.joint  = [0, 0, bodyparam.size.upperleg(3)/2];
bodyparam.position.right.lowerleg.item   = [0, 0, bodyparam.size.lowerleg(3)/2];

bodyparam.position.left.lowerleg.item    = [0, 0, bodyparam.size.upperleg(3)/2];
bodyparam.position.left.lowerleg.joint   = [0, 0, bodyparam.size.lowerleg(3)/2];

% foot 
bodyparam.position.right.foot.joint   = [0, 0, bodyparam.size.lowerleg(3)/2];
bodyparam.position.right.foot.item   = [bodyparam.size.foot(3)/2,0, bodyparam.size.foot(1)/2];

bodyparam.position.left.foot.joint   = [0, 0, bodyparam.size.lowerleg(3)/2];
bodyparam.position.left.foot.item   = [bodyparam.size.foot(3)/2,0, bodyparam.size.foot(1)/2];

% toes
bodyparam.position.right.toes = [0 0 bodyparam.size.foot(3)/2];
bodyparam.position.left.toes = [0 0 bodyparam.size.foot(3)/2];

%% distance proximal joint to the bodys center of mass
bodyparam.d1.hip = [0 0 0];

bodyparam.d1.right.upperleg = [0,0.0188,0.1782];
bodyparam.d1.right.lowerleg =  [0, 0.0059, 0.1865];
bodyparam.d1.right.foot = [-0.0656, 0, 0.0402];

bodyparam.d1.left.upperleg = [0,-0.0188,0.1782];
bodyparam.d1.left.lowerleg =  [0, -0.0059, 0.1865];
bodyparam.d1.left.foot = [-0.0656, 0, 0.0402];





%% Center of mass

bodyparam.sp.hip = [0 0 0]; 

bodyparam.sp.right.upperleg = 1/2*bodyparam.size.upperleg - [0,0.0188,0.1782];
bodyparam.sp.right.lowerleg = 1/2*bodyparam.size.lowerleg - [0, 0.0059, 0.1865]; 
bodyparam.sp.right.foot = 1/2*bodyparam.size.foot - [-0.0656, 0, 0.0402];


bodyparam.sp.left.upperleg  = 1/2*bodyparam.size.upperleg - [0,-0.0188,0.1782];
bodyparam.sp.left.lowerleg  = 1/2*bodyparam.size.lowerleg - [0, -0.0059, 0.1865];
bodyparam.sp.left.foot = 1/2*bodyparam.size.foot - [-0.0656, 0, 0.0402];

%%



%% [max min] angle 

bodyparam.maxlim.hip.ef = 10;
bodyparam.minlim.hip.ef = -120;

bodyparam.maxlim.hip.abd = 70;%70;
bodyparam.minlim.hip.abd = -10;%-10;

bodyparam.maxlim.knee = 120;
bodyparam.minlim.knee = -1;

bodyparam.maxlim.ankle = 40;
bodyparam.minlim.ankle = -20;

% left
bodyparam.maxlim.left.hip.ef = 0;
bodyparam.minlim.left.hip.ef = -0.01;

bodyparam.maxlim.left.hip.abd = 0;%70;
bodyparam.minlim.left.hip.abd = -0.01;%-10;

bodyparam.maxlim.left.knee = 0;
bodyparam.minlim.left.knee = -0.01;

bodyparam.maxlim.left.ankle = 0;
bodyparam.minlim.left.ankle = -0.01;

%% Muscle leverage

bodyparam.r.hip.ef = 1/3*bodyparam.size.hip(3); % [m]
bodyparam.r.hip.abd = 0.09; % [m]
bodyparam.r.knee = 0.05; % [m]
bodyparam.r.foot = 0.08; % [m]





%% weights
bodyparam.weight.pelvis = 10.2516; %[kg] 
bodyparam.weight.upperleg = 8.1719; %[kg]
bodyparam.weight.lowerleg = 3.3541; %[kg]


%% stiffness and damping

% hip
bodyparam.stiffness.hip = 1000;%[Nm/rad] No ref
bodyparam.damping.hip = .1;%[Nms/rad]

% knee
bodyparam.stiffness.knee = 100000;%[Nm/rad] according to jospt.2006.2320
bodyparam.damping.knee = .001;%[Nms/rad]

% pelvis
bodyparam.stiffness.ankle = 100000;%[Nm/rad] parameter to be defined...
bodyparam.damping.ankle = .001;%[Nms/rad]


% pelvis
bodyparam.stiffness.pelvis = 100000;%[Nm/rad] parameter to be defined...
bodyparam.damping.pelvis = .001;%[Nms/rad]

%% Inertia 1/2*(a^2 + b^2)*m

bodyparam.inertia.hip = get_inertia(bodyparam.size.hip, bodyparam.d1.hip, bodyparam.weight.pelvis);
bodyparam.inertia.right.upperleg = get_inertia(bodyparam.size.upperleg, bodyparam.d1.right.upperleg, bodyparam.weight.upperleg);
bodyparam.inertia.right.lowerleg = get_inertia(bodyparam.size.lowerleg, bodyparam.d1.right.lowerleg, bodyparam.weight.lowerleg);
bodyparam.inertia.right.foot = get_inertia(bodyparam.size.foot, bodyparam.d1.right.foot, bodyparam.weight.foot);

bodyparam.inertia.left.upperleg = get_inertia(bodyparam.size.upperleg, bodyparam.d1.left.upperleg, bodyparam.weight.upperleg);
bodyparam.inertia.left.lowerleg = get_inertia(bodyparam.size.lowerleg, bodyparam.d1.left.lowerleg, bodyparam.weight.lowerleg);
bodyparam.inertia.left.foot = get_inertia(bodyparam.size.foot, bodyparam.d1.left.foot, bodyparam.weight.foot);




%% Init stuff parameters

stuffparam.dimensions.wall = [0.01,6,6]; 
stuffparam.dimensions.ball = .1; %[m] radius
stuffparam.dimensions.floor = [12,12,.01];


staffparam.position.ball  = [.5,bodyparam.size.hip(1)/2, -stuffparam.dimensions.ball-stuffparam.dimensions.floor(3)/2];%[.5,bodyparam.size.hip(1)/2,  bodyparam.size.lowerbodyheight-stuffparam.dimensions.ball-stuffparam.dimensions.floor(3)/2];
stuffparam.position.wall = [6 0 bodyparam.size.lowerbodyheight-stuffparam.dimensions.wall(3)/2];
stuffparam.position.floor = [0 0 bodyparam.size.lowerbodyheight];

















