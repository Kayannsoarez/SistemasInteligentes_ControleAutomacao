function u = input_type(t, type)

    u = [];
    if type == "sin"
        F = 10*sin(t);
    elseif type == "ramp"
        F = 10*t;
    else
        F = [];
        for i = 1:length(t)
            if t(i) < 0 
                F(end+1) = 0;
            else
                F(end+1) = 5.9;
            end
        end    
    end

    for i = 1:length(t)
        if F(i) > 0
            u(end+1) = max([0, F(i)-4.9]);
        else
            u(end+1) = min([0, F(i)+4.9]);
        end
    end   
end