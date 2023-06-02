%p, d, i
ideal = [0.00037384, 0.000116446, 0.00688731];
%%
mdl = 'GA_pendulo';
pid_block  = 'GA_pendulo/C2';
load_system(mdl);

set_param(mdl, 'StopTime', num2str(1000));
set_param(pid_block, 'P', num2str(ideal(1)), 'I', num2str(ideal(3)), 'D', num2str(ideal(2)));

constants = [0.1, 0.5, 1.0];
%%
count = 0;
figure
for i = constants
    count = count + 1;
    set_param('GA_pendulo/Constant2','Value', num2str(i)); % Change the value of the Constant block
    simout = sim(mdl); % Simular o modelo

    t1_results = simout.xout.Time;
    y1_results = simout.xout.Data;

    plot(t1_results, y1_results, 'LineWidth', 2);
    if count < 3
        hold on;
    end
end

legend('Ref = 0.1', 'Ref = 0.5', 'Ref = 1.0');
legend("Position", [0.15681,0.61039,0.17894,0.075058]);
title('Posição linear');
xlabel('Tempo (s)');
ylabel('x (m)', 'Interpreter', 'latex');
grid on;

%%
count = 0;
figure
for i = constants
    count = count + 1;
    set_param('GA_pendulo/Constant2','Value', num2str(i)); % Change the value of the Constant block
    simout = sim(mdl); % Simular o modelo

    t1_results = simout.tetaout.Time;
    y1_results = simout.tetaout.Data;

    plot(t1_results, y1_results, 'LineWidth', 2);
    if count < 3
        hold on;
    end
end

legend('Ref = 0.1', 'Ref = 0.5', 'Ref = 1.0');
xlim([0 100])
legend("Position", [0.15681,0.61039,0.17894,0.075058]);
title('Posição angular');
xlabel('Tempo (s)');
ylabel('$\theta$ (rad)', 'Interpreter', 'latex');
grid on;

%%
count = 0;
figure
for i = constants
    count = count + 1;
    set_param(mdl, 'StopTime', num2str(6000));
    set_param('GA_pendulo/Pulse Generator', 'Amplitude', num2str(i));
    simout = sim(mdl); % Simular o modelo

    t1_results = simout.xout.Time;
    y1_results = simout.xout.Data;

    plot(t1_results, y1_results, 'LineWidth', 2);
    if count < 3
        hold on;
    end
end

legend('Amp = 0.1', 'Amp = 0.5', 'Amp = 1.0');
legend("Position", [0.15681,0.61039,0.17894,0.075058]);
title('Posição linear');
xlabel('Tempo (s)');
ylabel('x (m)', 'Interpreter', 'latex');
grid on;
%%
count = 0;
figure
for i = constants
    count = count + 1;
    set_param(mdl, 'StopTime', num2str(6000));
    set_param('GA_pendulo/Pulse Generator', 'Amplitude', num2str(i));
    simout = sim(mdl); % Simular o modelo

    t1_results = simout.tetaout.Time;
    y1_results = simout.tetaout.Data;

    plot(t1_results, y1_results, 'LineWidth', 2);
    if count < 3
        hold on;
    end
end

legend('Amp = 0.1', 'Amp = 0.5', 'Amp = 1.0');
legend("Position", [0.15681,0.61039,0.17894,0.075058]);
title('Posição angular');
xlabel('Tempo (s)');
ylabel('$\theta$ (rad)', 'Interpreter', 'latex');
grid on;

%%
simout = sim(mdl); % Simular o modelo

t1_results = simout.xout.Time;
t2_results = simout.dout.Time;
y1_results = simout.xout.Data;
teta_results = simout.tetaout.Data;
d_results = simout.dout.Data;

plot(t1_results, y1_results, 'LineWidth', 2);
legend('Ref = 1.0');
legend("Position", [0.15681,0.61039,0.17894,0.075058]);
title('Resposta linear com distúrbio');
xlabel('Tempo (s)');
ylabel('x (m)', 'Interpreter', 'latex');
grid on;

plot(t1_results, teta_results, 'LineWidth', 2);
title('Resposta angular com distúrbio');
xlabel('Tempo (s)');
ylabel('$\theta$ (rad)', 'Interpreter', 'latex');
grid on;

plot(t2_results, d_results, 'LineWidth', 2);
title('Função do distúrbio');
xlabel('Tempo (s)');
xlim([0, 100])
ylabel('Amplitude (m)', 'Interpreter', 'latex');
grid on;
%%
simout = sim(mdl); % Simular o modelo

t1_results = simout.xout.Time;
teta_results = simout.tetaout.Data;
y1_results = simout.xout.Data;

plot(t1_results, y1_results, 'LineWidth', 2);
title('Resposta linear com distúrbio');
xlabel('Tempo (s)');
ylabel('x (m)', 'Interpreter', 'latex');
grid on;

plot(t1_results, teta_results, 'LineWidth', 2);
title('Resposta angular com distúrbio');
xlabel('Tempo (s)');
ylabel('$\theta$ (rad)', 'Interpreter', 'latex');
grid on;
%%
settling_time(y1_results, t1_results)
%% 
% Comparação do modelo antes e após o tunning com o algoritmo genético

%p, d, i
ideal = [0.00037384, 0.000116446, 0.00688731];
genetic = [0.0001, 0.0586, 0.0959];

%open_system('GA_pendulo.slx');
mdl = 'GA_pendulo';
load_system(mdl);

set_param(mdl, 'StopTime', num2str(1000));

% Set the PID parameters
pid_block = 'GA_pendulo/C2';

set_param(pid_block, 'P', num2str(ideal(1)), 'I', num2str(ideal(3)), 'D', num2str(ideal(2)));

simout = sim(mdl); % Simular o modelo
t1 = simout.xout.Time; % Tempo da simulação
y1 = simout.xout.Data; % Saída do sistema ideal

set_param(pid_block, 'P', num2str(genetic(1)), 'I', num2str(genetic(3)), 'D', num2str(genetic(2)));

simout = sim(mdl); % Simular o modelo
t2 = simout.xout.Time; % Tempo da simulação
y2 = simout.xout.Data; % Saída do sistema ideal


figure;
plot(t1, y1, 'LineWidth', 2);
hold on;
plot(t2, y2, 'LineWidth', 2);
legend('Orininal', 'Genetic');
legend("Position", [0.15681,0.61039,0.17894,0.075058])
title('Posição linear');
xlabel('Tempo (s)');
ylabel('x (m)', 'Interpreter', 'latex');
grid on;
%%
%p, d, i
ideal = [0.00037384, 0.000116446, 0.00688731];

%open_system('GA_pendulo.slx');
mdl = 'GA_pendulo';
load_system(mdl);

set_param(mdl, 'StopTime', num2str(1000));

% Set the PID parameters
pid_block = 'GA_pendulo/C2';
gcb = 'GA_pendulo/Manual Switch2';

set_param(pid_block, 'P', num2str(ideal(1)), 'I', num2str(ideal(3)), 'D', num2str(ideal(2)));
set_param(gcb, 'sw', '0');

simout = sim(mdl); % Simular o modelo
t1 = simout.xout.Time; % Tempo da simulação
y1 = simout.xout.Data; % Saída do sistema ideal
teta1 = simout.tetaout.Data;
u1 = simout.uout.Data;

set_param(gcb, 'sw', '1');

simout = sim(mdl); % Simular o modelo
t2 = simout.xout.Time; % Tempo da simulação
y2 = simout.xout.Data; % Saída do sistema ideal
teta2 = simout.tetaout.Data;
u2 = simout.uout.Data;

figure;
plot(t1, u1, 'LineWidth', 2);
hold on
plot(t2, u2, 'LineWidth', 2);
legend('Com saturação', 'Sem saturação');
legend("Position", [0.15681,0.61039,0.17894,0.075058])
title('Sinal de controle');
xlabel('Tempo (s)');
xlim([-0.00001, 0.001])
ylabel('u (N)', 'Interpreter', 'latex');
grid on;
figure;
plot(t1, y1, 'LineWidth', 2);
hold on;
plot(t2, y2, 'LineWidth', 2);
legend('Com saturação', 'Sem saturação');
legend("Position", [0.15681,0.61039,0.17894,0.075058])
title('Posição linear');
xlabel('Tempo (s)');
ylabel('x (m)', 'Interpreter', 'latex');
grid on;

figure;
plot(t1, teta1, 'LineWidth', 2);
hold on;
plot(t2, teta2, 'LineWidth', 2);
legend('Com saturação', 'Sem saturação');
legend("Position", [0.15681,0.61039,0.17894,0.075058])
title('Posição angular');
xlabel('Tempo (s)');
xlim([-0.01, 10])
ylabel('$\theta$ (rad)', 'Interpreter', 'latex');
grid on;
%%

set_param('GA_pendulo/Constant2','Value', num2str(1));
set_param(mdl, 'StopTime', num2str(1));

simout = sim(mdl); % Simular o modelo
t2 = simout.xout.Time; % Tempo da simulação
y2 = simout.xout.Data; % Saída do sistema ideal

figure;
plot(t2, y2, 'LineWidth', 2);
title('Posição linear');
xlabel('Tempo (s)');
ylabel('x (m)', 'Interpreter', 'latex');
grid on;
%%
genetic = [0.0001, 0.0586, 0.0959];

%open_system('GA_pendulo.slx');
mdl = 'GA_pendulo';
load_system(mdl);

set_param(mdl, 'StopTime', num2str(1000));

% Set the PID parameters
pid_block = 'GA_pendulo/C2';

set_param(pid_block, 'P', num2str(genetic(1)), 'I', num2str(genetic(3)), 'D', num2str(genetic(2)));

simout = sim(mdl); % Simular o modelo
t2 = simout.uout.Time; % Tempo da simulação
y2 = simout.uout.Data; % Saída do sistema ideal


figure;
plot(t2, y2, 'LineWidth', 2, 'color', 'r');
legend('Genetic');
legend("Position", [0.15681,0.61039,0.17894,0.075058])
title('Sinal de controle');
xlabel('Tempo (s)');
xlim([-0.00001, 0.001])
ylabel('u (N)', 'Interpreter', 'latex');
grid on;