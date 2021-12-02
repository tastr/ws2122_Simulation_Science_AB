clear all

%% dimensions

% foots
bodyparam.size.foot = [.1 .15 .01]; 

%legs
bodyparam.size.upperleg = [.01 .01 0.45];
bodyparam.size.lowerleg = [.01 .01  0.3];
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
                                       
% foots
bodyparam.position.foot_right_trans.joint     = [-bodyparam.size.hip(1)/2, 0, -bodyparam.size.foot(3)/2];
bodyparam.position.foot_right_trans.item     =  [-bodyparam.size.foot(1)/2, 0, 0];

bodyparam.position.foot_left_trans.joint      = [0, 0, -bodyparam.size.lowerleg(3)/2];
bodyparam.position.foot_left_trans.item       = [-bodyparam.size.foot(1)/2, 0, 0]


% lower legs
bodyparam.position.lowerleg_right_trans.item   = [0, 0, -bodyparam.size.lowerleg(3)/2]
bodyparam.position.lowerleg_right_trans.joint  = [0, 0, -bodyparam.size.lowerleg(3)/2];

bodyparam.position.lowerleg_left_trans.item    = [0, 0, bodyparam.size.lowerleg(3)/2];
bodyparam.position.lowerleg_left_trans.joint   = [0, 0, bodyparam.size.upperleg(3)/2];

% upper legs
bodyparam.position.upperleg_right_trans.item =  [0, 0, -bodyparam.size.upperleg(3)/2];
bodyparam.position.upperleg_right_trans.joint = [0, 0, -bodyparam.size.upperleg(3)/2];

bodyparam.position.upperleg_left_trans.joint =  [bodyparam.size.hip(1)/2 - bodyparam.size.upperleg(1)/2, 0, 0];
bodyparam.position.upperleg_left_trans.item =   [0, 0, bodyparam.size.upperleg(3)/2];


bodyparam.jointspos.upperleg_hip = [0, 0, -bodyparam.size.upperleg(3)/2];

% hip
bodyparam.position.hip_trans  = [bodyparam.size.hip(1)/2 -  bodyparam.size.lowerleg(1)/2, 0, -bodyparam.size.hip(3)/2];

% body
bodyparam.position.body_trans = [0 0 -bodyparam.size.body(3)/2];

% arms
bodyparam.position.upperarms_right_trans = [0 0 bodyparam.size.body(3)/2-bodyparam.size.neck(3)]
bodyparam.position.upperarms_left_trans = [0 0 bodyparam.size.body(3)/2-bodyparam.size.neck(3)]
bodyparam.position.lowerarms_right_trans = [bodyparam.size.upperarms(1)/2 0 -bodyparam.size.lowerarms(3)/2]
bodyparam.position.lowerarms_left_trans = [-bodyparam.size.upperarms(1)/2 0 -bodyparam.size.lowerarms(3)/2]


% head
bodyparam.position.head = [0 0 .5*bodyparam.size.body(3) + .5*bodyparam.size.head];



%% Init stuff parameters

stuffparam.dimensions.wall = [.2,3,3]; 
stuffparam.dimensions.ball = .1; %[m] radius
stuffparam.transformation.body_wall_trans = [4 0 0];

stuffparam.dimensions.floor = [4,4,.0001];
stuffparam.transformation.floor = [0 0 .5*stuffparam.dimensions.floor(3)];














