function I = get_inertia(size, d1, weight)
    
    % middle
    inertia(1) = 1/5*weight*(size(2)^2 + size(3)^2); 
    inertia(2) = 1/5*weight*(size(1)^2 + size(3)^2); 
    inertia(3) = 1/5*weight*(size(2)^2 + size(1)^2); 
    
    vol = size(1)*size(2)*size(3);
    
    % in the mass center (steinersche Satz)
    I(1) = inertia(1) + d1(1)^3*weight;
    I(2) = inertia(2) + d1(2)^3*weight;
    I(3) = inertia(3) + d1(3)^3*weight;




    
    
end