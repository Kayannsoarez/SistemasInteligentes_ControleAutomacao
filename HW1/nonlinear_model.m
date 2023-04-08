clc

%chama a função de espaço de estados do pêndulo
func = @inverted_pend;

%Define o intervalo de tempo a ser considerado
tspan = [0:0.01:10];

%Define os valores iniciais das variáveis
x0 = [0, 0, 0, 0];

%Aplica a função de espaço de estados e gera as saídas
[t, x] = ode45 (@(t,y) inverted_pend(t,y,"step") , tspan , x0);

%Plots das saídas
figure()
subplot(2,2,1)
plot(t, x(:,1))
tiy=get(gca,'ytick')';
set(gca,'yticklabel',num2str(tiy,'%.4f'))
title('$\theta$', "Interpreter", "latex")
grid

subplot(2,2,2)
plot(t, x(:,2))
title('$\dot{\theta}$', "Interpreter", "latex")
grid

subplot(2,2,3)
plot(t, x(:,3))
title('$x$', "Interpreter", "latex")
grid

subplot(2,2,4)
plot(t, x(:,4))
title('$\dot{x}$', "Interpreter", "latex")
grid
