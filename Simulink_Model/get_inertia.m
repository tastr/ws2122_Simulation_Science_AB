%% get_inertia(size, d1, weight)
% Calculates the inertia of the ellipsoid with dimensions size [m m m] and according weight [kg]
% d1: distance proximal joint to the bodys center of mass and [m m m]
% 
% Th result is the inertia of the body, calculated as the inertia of the
% ellibsoid 1/5(a^2 + b^2)*m, and adjusted with Steiner'sche Satz as
% d1^2*weight

function I = get_inertia(size, d1, weight)

    
    % middle
    inertia(1) = 1/5*weight*((size(2)/2)^2 + (size(3)/2)^2); 
    inertia(2) = 1/5*weight*((size(1)/2)^2 + (size(3)/2)^2); 
    inertia(3) = 1/5*weight*((size(2)/2)^2 + (size(1)/2)^2); 
    
    vol = size(1)*size(2)*size(3);
    
    % in the mass center (steinersche Satz)
    I(1) = inertia(1) + d1(1)^2*weight;
    I(2) = inertia(2) + d1(2)^2*weight;
    I(3) = inertia(3) + d1(3)^2*weight;




    
    
end