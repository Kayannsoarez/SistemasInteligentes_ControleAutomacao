%% Funções de Transferência

% Transformação do espaço de estados para função de transferência
G = tf(sys);
G

figure()
stepplot(G);
%% Polos e Zeros

figure;
subplot(2,1,1);
pzplot(G(1));
set(gca, 'XGrid', 'on','XMinorGrid', 'on', 'XMinorTick', 'on');

subplot(2,1,2);
pzplot(G(2));
%% Estabilidade

% Return: 1 se o modelo de sistema dinâmico for estável ou 0 se o modelo não for estável.
% Verifica se o sistema é estável em termos da sua resposta ao degrau unitário
Est = isstable(G)
syms s;

sI = s*(eye(4));
d = (det(sI-A))
S = simplify(d)
solve(d, s)
%% Controlabilidade e Observabilidade

Co = ctrb(A,B)
Ob = obsv(A,C)
