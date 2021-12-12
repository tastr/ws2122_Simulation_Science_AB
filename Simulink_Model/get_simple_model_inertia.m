%% get_simple_model_inertia(length, d1, weight)
% Inertia for thin sticks in the simplified model
% The inertia is calculated as
%  1/2*weight*length^2 + 1/2*d1^2*weight, where 1/2*d1^2*weight is the term
%  from steiner's satz with d1: the distance to the center of masses

function inertia = get_simple_model_inertia(length, d1, weight)

    
    % middle
    inertia(1) = 0;
    inertia(2) = 0;
    inertia(3) = 1/12*weight*length^2; 
    
    inertia(3) = inertia(3) + d1^2*weight;
    
end