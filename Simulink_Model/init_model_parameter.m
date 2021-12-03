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



%legs   
bodyparam.size.upperleg = [.01 .01 0.41];
bodyparam.size.lowerleg = [.01 .01  0.415];
bodyparam.size.leg = [bodyparam.size.lowerleg(1:2), bodyparam.size.lowerleg(3) + bodyparam.size.upperleg(3)];

% hip 
bodyparam.size.hip = [.25 .01 .01];

% body
bodyparam.size.body = [.01 .01 .7];

% neck
bodyparam.size.neck = [.01 .01 .1];

%arms
bodyparam.size.upperarms = [.32 .01 .01];
bodyparam.size.lowerarms = [.01 .01 .35];


% head
bodyparam.size.head  = .1;% radius


%% Transormations:
                                       
% LOWER BODY 

% lower legs
bodyparam.position.lowerleg_right_trans.item   = [0, 0, -bodyparam.size.lowerleg(3)/2 ];
bodyparam.position.lowerleg_right_trans.joint  = [0, 0, -bodyparam.size.lowerleg(3)/2];

bodyparam.position.lowerleg_left_trans.item    = [0, 0, -bodyparam.size.lowerleg(3)/2];
bodyparam.position.lowerleg_left_trans.joint   = [0, 0, -bodyparam.size.upperleg(3)/2];

% upper legs
bodyparam.position.upperleg_right_trans.item =  [0, 0, -bodyparam.size.upperleg(3)/2];
bodyparam.position.upperleg_right_trans.joint = [0, 0, -bodyparam.size.upperleg(3)/2 - bodyparam.size.hip(3)/2];

bodyparam.position.upperleg_left_trans.item =  [0, 0, -bodyparam.size.upperleg(3)/2];
bodyparam.position.upperleg_left_trans.joint = [0, 0, -bodyparam.size.upperleg(3)/2 - bodyparam.size.hip(3)/2];

% hip
bodyparam.position.hip_trans_right  = [bodyparam.size.hip(1)/2 - bodyparam.size.lowerleg(1)/2, 0, 0];
bodyparam.position.hip_trans_left  =  [-bodyparam.size.hip(1)/2 + bodyparam.size.lowerleg(1)/2, 0, 0];

% UPPER BODY 
% body
bodyparam.position.body_trans = [0 0 -bodyparam.size.body(3)/2];

% arms
bodyparam.position.upperarms_right_trans = [0 0 bodyparam.size.body(3)/2-bodyparam.size.neck(3)];
bodyparam.position.upperarms_left_trans = [0 0 bodyparam.size.body(3)/2-bodyparam.size.neck(3)];
bodyparam.position.lowerarms_right_trans = [bodyparam.size.upperarms(1)/2 0 bodyparam.size.lowerarms(3)/2];
bodyparam.position.lowerarms_left_trans = [-bodyparam.size.upperarms(1)/2 0 bodyparam.size.lowerarms(3)/2];


% head
bodyparam.position.head = [0 0 .5*bodyparam.size.body(3) + .5*bodyparam.size.head];


%% Init stuff parameters

stuffparam.dimensions.wall = [0.01,3,3]; 
stuffparam.dimensions.ball = .1; %[m] radius
staffparam.position.ball = [1,0,-0.1];
stuffparam.position.body_wall_trans = [4 0 -stuffparam.dimensions.wall(3)/2];

stuffparam.dimensions.floor = [8,8,.01];
stuffparam.position.floor = [0 0 stuffparam.dimensions.floor(3)];

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















