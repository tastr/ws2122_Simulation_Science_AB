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
% staffparam: the parameters of the surrounding objects; 
%             contains the substurctures:
%             staffparam.dimensions and staffparam.position: the the size and
%             transformation infos 





%% dimensions

% head
bodyparam.size.head  = .1;% radius
bodyparam.size.neck = [.01 .01 .1];

%arms
bodyparam.size.upperarm = [.15 .01 .01];%[.32 .01 .01];
bodyparam.size.lowerarm = [.01 .01 .35];

% body
bodyparam.size.body = [.01 .01 .7];

% hip 
bodyparam.size.hip = [.1643 .1224 .18783];

%legs   
bodyparam.size.upperleg = [.0947 .0947 0.4347];
bodyparam.size.lowerleg = [.0597 .0597  0.4239];
bodyparam.size.foot = [0.0398, 0.0398, 0.272];
bodyparam.size.leg = [bodyparam.size.lowerleg(1:2), bodyparam.size.lowerleg(3) + bodyparam.size.upperleg(3)];


bodyparam.size.bodyheight = bodyparam.size.head + bodyparam.size.body(3) + bodyparam.size.leg(3); 
bodyparam.size.lowerbodyheight = bodyparam.size.leg(3) + 1/2*bodyparam.size.hip(3);

% balls for the joints visualizations
bodyparam.size.jointballs = .02; 
bodyparam.size.jointballs_hip = .04; 


%% Transormations:

% UPPER BODY

% head
bodyparam.position.head = [0 0 bodyparam.size.head/2+bodyparam.size.neck(3)];

%neck
bodyparam.position.neck = [0 0 bodyparam.size.body(3)/2 - bodyparam.size.neck(3)];
% arms
bodyparam.position.upperarm_right_trans = [bodyparam.size.upperarm(1)/2 0 0];
bodyparam.position.upperarm_left_trans = [-bodyparam.size.upperarm(1)/2 0 0];
bodyparam.position.lowerarm_right_trans = [bodyparam.size.upperarm(1)/2 0 bodyparam.size.lowerarm(3)/2];
bodyparam.position.lowerarm_left_trans = [-bodyparam.size.upperarm(1)/2 0 bodyparam.size.lowerarm(3)/2];

% body
bodyparam.position.body_trans = [0, 0, bodyparam.size.body(3)/2];


% LOWER BODY 

% hip
bodyparam.position.hip_trans  = [0, 0,  bodyparam.size.body(3)/2];

% upper legs
bodyparam.position.upperleg_right_trans.joint = [bodyparam.size.hip(1)/2 , 0, bodyparam.size.upperleg(1)/2];
bodyparam.position.upperleg_right_trans.item =  [0, 0, bodyparam.size.upperleg(3)/2];

bodyparam.position.upperleg_left_trans.joint = [-bodyparam.size.hip(1)/2 , 0, bodyparam.size.upperleg(1)/2];
bodyparam.position.upperleg_left_trans.item =  [0, 0, bodyparam.size.upperleg(3)/2];


% lower legs
bodyparam.position.lowerleg_right_trans.joint  = [0, 0, bodyparam.size.upperleg(3)/2];
bodyparam.position.lowerleg_right_trans.item   = [0, 0, bodyparam.size.lowerleg(3)/2];

bodyparam.position.lowerleg_left_trans.item    = [0, 0, bodyparam.size.upperleg(3)/2];
bodyparam.position.lowerleg_left_trans.joint   = [0, 0, bodyparam.size.lowerleg(3)/2];

% centering
bodyparam.position.centering_right = [-bodyparam.size.hip(1)/2 + bodyparam.size.upperleg(1)/2, 0, bodyparam.size.lowerleg(3)/2];
bodyparam.position.centering_left = [-bodyparam.size.hip(1)/2 + bodyparam.size.upperleg(1)/2, 0, bodyparam.size.lowerleg(3)/2];

%
bodyparam.position.foot_left_trans.joint   = [0, 0, bodyparam.size.lowerleg(3)/2];
bodyparam.position.foot_left_trans.item   = [-bodyparam.size.foot(1)/2, bodyparam.size.foot(2)/2, bodyparam.size.foot(3)/2];

bodyparam.position.foot_right_trans.joint   = [0, 0, bodyparam.size.lowerleg(3)/2];
bodyparam.position.foot_right_trans.item   = [-bodyparam.size.foot(1)/2, bodyparam.size.foot(2)/2, bodyparam.size.foot(3)/2];


%% Init stuff parameters

stuffparam.dimensions.wall = [3,0.01,3]; 
stuffparam.dimensions.ball = .1; %[m] radius
stuffparam.dimensions.floor = [8,8,.01];


%staffparam.position.ball = [bodyparam.size.hip(1)/2, -.3, -.5*stuffparam.dimensions.ball];
staffparam.position.ball  = [bodyparam.size.hip(1)/2, -.3,  bodyparam.size.lowerbodyheight-stuffparam.dimensions.ball]
stuffparam.position.wall = [0 -4 bodyparam.size.lowerbodyheight-stuffparam.dimensions.wall(3)/2];
stuffparam.position.floor = [0 0 bodyparam.size.lowerbodyheight + stuffparam.dimensions.wall(2)/2];



%% weights
bodyparam.weight.pelvis = 10.2516; %[kg] 
bodyparam.weight.upperleg = 8.1719; %[kg]
bodyparam.weight.lowerleg = 3.3541; %[kg]

%% radius
bodyparam.rx.pelvis = 0.1224; %[m]
bodyparam.ry.pelvis = 0.1643; %[m]
bodyparam.hz.pelvis = 0.18783; %[m]

bodyparam.rx.upperleg = 0.0947; %[m]
%bodyparam.ry.upperleg = 0.1643; %[m] % no data in the sheet
bodyparam.hz.upperleg = 0.4347; %[m]

bodyparam.rx.lowerleg = 0.0597; %[m]
%bodyparam.ry.lowerleg = 0.1643; %[m] % no data in the sheet
bodyparam.hz.lowerleg = 0.4239; %[m]

%% stiffness and damping

% hip
bodyparam.stiffness.hip = 100;%[Nm/rad] No ref
bodyparam.damping.hip = .001;%[Nms/rad]

% knee
bodyparam.stiffness.knee = 100;%[Nm/rad] according to jospt.2006.2320
bodyparam.damping.knee = .001;%[Nms/rad]

% pelvis
bodyparam.stiffness.pelvis = 100;%[Nm/rad] parameter to be defined...
bodyparam.damping.pelvis = .001;%[Nms/rad]



%% Target 

target_position = [.1, 0, .3];











