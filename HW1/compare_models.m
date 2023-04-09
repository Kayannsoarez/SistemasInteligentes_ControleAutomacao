clc

% Modelo não linear do pêndulo invertido
func = @inverted_pend;

% Modelo linear do pêndulo invertido
x0 = [0, 0, 0, 0];

A = [0 1 0 0;
     17.52 0 0 0;
     0 0 0 1;
     0 0 0 0];
B = [0;
     -0.372;
     0;
     0.2083];
C = [1 0 0 0;
     0 0 1 0];
D = [0;
     0];
sys = ss(A, B, C, D);

% Definifição do tempo
tspan = 0:0.01:10;

for type = ["step", "sin", "ramp"]
    [t, x] = ode45 (@(t,y) inverted_pend(t,y,type) , tspan , x0);
    u = input_type(tspan, type);
    y_linear = lsim(sys, u, t);
    
    % Gráficos das saídas
    figure;
    subplot(2,1,1);
    plot(t, x(:,1), 'LineWidth', 2);
    hold on;
    plot(t, y_linear(:,1), 'LineWidth', 2);
    legend('Não linear', 'Linear');
    legend("Position", [0.15681,0.61039,0.17894,0.075058])
    title('Posição angular');
    xlabel('Tempo (s)');
    ylabel('$\theta$ (rad)', 'Interpreter', 'latex');
    grid on;
    
    subplot(2,1,2);
    plot(t, x(:,2), 'LineWidth', 2);
    hold on;
    plot(t, y_linear(:,2), 'LineWidth', 2);
    legend('Não linear', 'Linear');
    legend("Position", [0.15366,0.13464,0.17894,0.075058]);
    title('Posição horizontal');
    xlabel('Tempo (s)');
    ylabel('$x$ (m)', 'Interpreter', 'latex');
    grid on; 
end
