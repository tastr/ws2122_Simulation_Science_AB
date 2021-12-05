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
%             staffparam.size and staffparam.position: the the size and
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
bodyparam.size.hip = [.25 .01 .01];

%legs   
bodyparam.size.upperleg = [.01 .01 0.41];
bodyparam.size.lowerleg = [.01 .01  0.415];
bodyparam.size.leg = [bodyparam.size.lowerleg(1:2), bodyparam.size.lowerleg(3) + bodyparam.size.upperleg(3)];

bodyparam.size.bodyheight = bodyparam.size.head + bodyparam.size.body(3) + bodyparam.size.leg(3); 




%% Transormations:

% UPPER BODY

% head
bodyparam.position.head = [0 0 .5*bodyparam.size.head];

% arms
bodyparam.position.upperarm_right_trans = [bodyparam.size.upperarm(1)/2 0 bodyparam.size.head/2+bodyparam.size.neck(3)];
bodyparam.position.upperarm_left_trans = [-bodyparam.size.upperarm(1)/2 0 bodyparam.size.head/2+bodyparam.size.neck(3)];
bodyparam.position.lowerarm_right_trans = [bodyparam.size.upperarm(1)/2 0 bodyparam.size.lowerarm(3)/2];
bodyparam.position.lowerarm_left_trans = [-bodyparam.size.upperarm(1)/2 0 bodyparam.size.lowerarm(3)/2];

% body
bodyparam.position.body_trans = [0 0 bodyparam.size.head/2 + bodyparam.size.body(3)/2];


% LOWER BODY 

% hip
bodyparam.position.hip_trans  = [0, 0,  bodyparam.size.body(3)/2];

% upper legs
bodyparam.position.upperleg_right_trans.joint = [bodyparam.size.hip(1)/2 - bodyparam.size.upperleg(1)/2, 0, bodyparam.size.upperleg(1)/2];
bodyparam.position.upperleg_right_trans.item =  [0, 0, bodyparam.size.upperleg(3)/2];

bodyparam.position.upperleg_left_trans.item =  [-bodyparam.size.hip(1)/2 + bodyparam.size.upperleg(1)/2, 0, bodyparam.size.upperleg(1)/2];
bodyparam.position.upperleg_left_trans.joint = [0, 0, bodyparam.size.upperleg(3)/2];


% lower legs
bodyparam.position.lowerleg_right_trans.joint  = [0, 0, bodyparam.size.upperleg(3)/2];
bodyparam.position.lowerleg_right_trans.item   = [0, 0, bodyparam.size.lowerleg(3)/2];

bodyparam.position.lowerleg_left_trans.item    = [0, 0, bodyparam.size.upperleg(3)/2];
bodyparam.position.lowerleg_left_trans.joint   = [0, 0, bodyparam.size.lowerleg(3)/2];

% centering
bodyparam.position.centering_right = [-bodyparam.size.hip(1)/2 + bodyparam.size.upperleg(1)/2, 0, bodyparam.size.lowerleg(3)/2];
bodyparam.position.centering_left = [-bodyparam.size.hip(1)/2 + bodyparam.size.upperleg(1)/2, 0, bodyparam.size.lowerleg(3)/2];



%% Init stuff parameters

stuffparam.dimensions.wall = [0.01,3,3]; 
stuffparam.dimensions.ball = .1; %[m] radius
stuffparam.dimensions.floor = [8,8,.01];


staffparam.position.ball = [bodyparam.size.hip(1)/2, -.2, -stuffparam.dimensions.ball];
stuffparam.position.wall = [0 -4 bodyparam.size.bodyheight-stuffparam.dimensions.wall(3)/2];
stuffparam.position.floor = [0 0 bodyparam.size.bodyheight];



%% weights according to https://exrx.net/Kinesiology/Segments for total 62kg
tw = 62; %total weight
bodyparam.weight.total = tw; %[kg]
bodyparam.weight.head = .0826*tw; 
bodyparam.weight.upperarm = .0325*tw;
bodyparam.weight.lowerarm = 0.0252*tw; 
bodyparam.weight.hip = .1366*tw; 
bodyparam.weight.upperleg = .105*tw;
bodyparam.weight.lowerleg = 0.0475*tw; 

bodyparam.weight.body = bodyparam.weight.total - bodyparam.weight.head...
                                   - bodyparam.weight.upperarm...
                                   - bodyparam.weight.lowerarm...
                                   - bodyparam.weight.hip...
                                   - bodyparam.weight.upperleg...
                                   - bodyparam.weight.lowerleg;

%% stiffness and damping

% femur
bodyparam.stiffness.hip = 7;%[Nm/rad] No ref
bodyparam.damping.hip = .2;%[Nms/rad]

bodyparam.stiffness.knee = 10.72;%[Nm/rad] according to jospt.2006.2320
bodyparam.damping.knee = 0.29;%[Nms/rad]



% TODO: 
% pelvis (just random paprameters so far)
bodyparam.stiffness.pelvis = 10e4;%[Nm/rad] parameter to be defined...
bodyparam.damping.pelvis = 1000;%[Nms/rad]















