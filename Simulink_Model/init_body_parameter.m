%% dimensions

%head 
bodyparam.dimensions.head = .15; %[m] radius
bodyparam.dimensions.neck = [.1 .1 .2]; %[m m m]

% arms 
bodyparam.dimensions.upperarm = [0.01 0.335 0.01]; 
bodyparam.dimensions.lowerarm = [0.01 0.263 0.01];

% body 
bodyparam.dimensions.body = [.1 .3 .6]; 

% legs
bodyparam.dimensions.upperleg = [0.01 .01 0.45];
bodyparam.dimensions.lowerleg = [0.01 0.01  0.3];

%% Transformations 

% head and body 
bodyparam.transformation.head_neck_trans = [0 0 .15]; %[m m m]
bodyparam.transformation.neck_body_trans = [0 0 .4]; %[m m m]

% body and arms
bodyparam.transformation.body_upperarmleft_trans = [0 .3 -.3]; %[m m m]
bodyparam.transformation.body_lowerarmleft_trans = [0,0.299,0]; %[m m m]
bodyparam.transformation.body_upperarmright_trans = [0 -.3 -.3]; %[m m m]
bodyparam.transformation.body_lowerarmright_trans = [0,-0.299,0]; %[m m m]

%% Init stuff parameters

stuffparam.dimensions.wall = [.2,3,3]; 
stuffparam.transformation.body_wall_trans = [4 0 0];













