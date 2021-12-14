syms q0 q1 q2 q3 % angles
syms l_ul l_ll l_f % lengths

T0 = [cos(q0) 0 sin(q0) 0; 
      0       1      0  0;
      -sin(q0) 0 cos(q0) 0;
      0 0 0 1] * ...
      [1      0      0  0; 
       0 cos(q3) sin(q3) 0;
       0 -sin(q3) cos(q3) 0; 
       0  0        0      1];

T1 = [cos(-q1) 0 sin(-q1) sin(q0)*l_ul; 
      0       1      0  sin(q3)*l_ul;
      -sin(-q1) 0 cos(-q1) cos(q0)*l_ul;
      0 0 0 1];

T2 = [cos(q2) 0 sin(q2) cos(q1)*l_ll; 
      0       1      0  0;
      -sin(q2) 0 cos(q2) sin(q1)*l_ll;
      0 0 0 1];

T3 = [eye(3) [sin(q2)*l_f; 0 ; cos(q2)*l_f]; [0 0 0 1]];


T_end = T0*T1*T2*T3;
T_end = simplify(T_end);


% output: 
% [  cos(q2)*(cos(q0)*cos(q1) + cos(q3)*sin(q0)*sin(q1)) + sin(q2)*(cos(q0)*sin(q1) - cos(q1)*cos(q3)*sin(q0)), -sin(q0)*sin(q3), sin(q2)*(cos(q0)*cos(q1) + cos(q3)*sin(q0)*sin(q1)) - cos(q2)*(cos(q0)*sin(q1) - cos(q1)*cos(q3)*sin(q0)), (l_ul*sin(2*q0))/2 - l_ll*cos(q0) - l_ul*sin(q0) + l_f*cos(q0)*sin(q1) + 2*l_ll*cos(q0)*cos(q1)^2 + l_ul*cos(q3)^2*sin(q0) - l_f*cos(q1)*cos(q3)*sin(q0) + l_ul*cos(q0)*cos(q3)*sin(q0) - 2*l_f*cos(q0)*cos(q2)^2*sin(q1) + 2*l_f*cos(q0)*cos(q1)*cos(q2)*sin(q2) + 2*l_ll*cos(q1)*cos(q3)*sin(q0)*sin(q1) + 2*l_f*cos(q1)*cos(q2)^2*cos(q3)*sin(q0) + 2*l_f*cos(q2)*cos(q3)*sin(q0)*sin(q1)*sin(q2)]
% [                                                                                       sin(q1 - q2)*sin(q3),          cos(q3),                                                                                      cos(q1 - q2)*sin(q3),                                                                                                                                                                                                                                                                                                                          sin(q3)*(l_ll*sin(2*q1) + l_ul*cos(q0) + l_ul*cos(q3) + l_f*cos(q1 - 2*q2))]
% [- cos(q2)*(cos(q1)*sin(q0) - cos(q0)*cos(q3)*sin(q1)) - sin(q2)*(sin(q0)*sin(q1) + cos(q0)*cos(q1)*cos(q3)), -cos(q0)*sin(q3), cos(q2)*(sin(q0)*sin(q1) + cos(q0)*cos(q1)*cos(q3)) - sin(q2)*(cos(q1)*sin(q0) - cos(q0)*cos(q3)*sin(q1)),    l_ll*sin(q0) - l_ul*cos(q0) - l_ul + l_ul*cos(q0)^2 - l_f*sin(q0)*sin(q1) + l_ul*cos(q0)*cos(q3)^2 + l_ul*cos(q0)^2*cos(q3) - 2*l_ll*cos(q1)^2*sin(q0) - l_f*cos(q0)*cos(q1)*cos(q3) + 2*l_f*cos(q2)^2*sin(q0)*sin(q1) + 2*l_ll*cos(q0)*cos(q1)*cos(q3)*sin(q1) - 2*l_f*cos(q1)*cos(q2)*sin(q0)*sin(q2) + 2*l_f*cos(q0)*cos(q1)*cos(q2)^2*cos(q3) + 2*l_f*cos(q0)*cos(q2)*cos(q3)*sin(q1)*sin(q2)]
% [                                                                                                          0,                0,                                                                                                         0,                                                                                                                                                                                                                                                                                                                                                                                                    1]