%Define as variáveis que serão utilizadas
syms F Fc x1 x2 x3 x4 m M l g x1_s x2_s x3_s x4_s F_s;

%Definie as funções do espaço de estados e as posiciona em um vetor f
f1 = x2;
f2 = ( g*(M+m)*sin(x1) - (F-Fc)*cos(x1) - m*(x2.^2)*sin(x1)  )/( l*(M+m - m*cos(x1)) );
f3 = x4;
f4 = ( F-Fc - m*g*cos(x1)*sin(x1) + m*l*(x2.^2)*sin(x1) )/( M+m - m*(cos(x1)).^2 );

fs = [f1,f2,f3,f4];

%Instancia um contador
count = 0;

%O algoritmo a seguir será executado para cada uma das funções em f
for f = fs
    %Incrementa um contador
    count = count + 1;

    %Aplica a derivada parcial em relação a cada variável
    dx1 = diff(f, x1);
    dx2 = diff(f, x2);
    dx3 = diff(f, x3);
    dx4 = diff(f, x4);
    dF = diff(f, F);

    %Aplica a fórmula da expansão de Taylor em posse
    disp(['g', count])
    g = dx1*(x1-x1_s) + dx2*(x2-x2_s) + dx3*(x3-x3_s) + dx4*(x4-x4_s) + dF*(F-F_s);
    disp(g)

    %Define os valores de cada variável
    m = 0.356; M = 4.8; l = 0.56; g = 9.81; L = 2; Fc = 0.0;
    x1 = 0.0; x2 = 0.0; x3 = 0.0; x4 = 0.0; x1_s = 0.0; x2_s = 0.0;
    x3_s = 0.0; x4_s = 0.0; F_s = 0.0;

    %Deriva novamente em relação a cada variável
    Dx1 = eval(dx1);
    Dx2 = eval(dx2);
    Dx3 = eval(dx3);
    Dx4 = eval(dx4);
    DF = eval(dF);

    syms x1 x2 x3 x4 F

    %Aplica a expansão de Taylor, com os valores das constantes já definidos
    disp(['G', count])
    G = Dx1*(x1-x1_s) + Dx2*(x2-x2_s) + Dx3*(x3-x3_s) + Dx3*(x4-x4_s) + DF*(F-F_s);
    disp(G)
end
