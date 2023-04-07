function X = inverted_pend(t, x, type)

    %Cria o vetor que receberá as 4 saídas
    X = zeros(4,1);

    %Define a entrada
    if type == "sin"
        F = 10*sin(t);
    elseif type == "ramp"
        F = 10*t;
    else
        if t < 0 
            F = 0;
        else
            F = 5.9;
        end
    end    
    
    if F > 0
       u = max([0, F-4.9]);
    else
       u = min([0, F+4.9]);
    end

    
    %F = 5*t;

    %Define o valor das constantes
    m = 0.356;
    M = 4.8;
    l = 0.56;
    g = 9.81;
    L = 2;
    Fc = min(F, 4.9);
    
    %Aplica as equações e atribui os resultados à saída X
    X(1) = x(2);
    X(2) = ( g*(M+m)*sin(x(1)) - (u)*cos(x(1)) - m*(x(2).^2)*sin(x(1))  )/( l*(M+m - m*cos(x(1))) );
    X(3) = x(4);
    X(4) = ( u - m*g*cos(x(1))*sin(x(1)) + m*l*(x(2).^2)*sin(x(1)) )/( M+m - m*(cos(x(1))).^2 );
end