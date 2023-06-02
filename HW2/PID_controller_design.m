% *Definição das funções de transferência*

syms s kp1 kd1 ki1 kp2 kd2 ki2 tc w z real;

format short

M = 4.8; g = 9.81; l = 0.56;

G1= -1/(M*l*s^2 - g*M);
H = 1/(M*s^2);
G2 = H/G1;

PD1 = kp1 + kd1*s;
PD2 = kp2 + kd2*s;
% Teste individaul dos cpntroladores

cl1 = (PD1*G1)/(1+PD1*G1);
simplify(cl1);
[nl1, dl1] = numden(cl1);
routh(dl1,s)

cl2 = (PD2*H)/(1+PD2*H);
simplify(cl2);
[nl2, dl2] = numden(cl2);
routh(dl2,s)
% Definição da Função de transferência do Loop interno

Tii = G1/(1+G1*PD1);
[nii, dii] = numden(Tii);
routh(dii, s)
% Para que a função seja estável, temos que kd1 < 0 e kp1 < -47.088.
% Escolhemos kd1 = -3 e kp1 = -50

PD1 = subs(PD1, [kd1, kp1], [-3, -50]);
PD1 = simplify(PD1);

Tii = subs(Tii, [kd1, kp1], [-3, -50]);
Tii = simplify(Tii)
% Para obter a equação do controlador fazemos:

response_1 = 1/(tc*s+1);

C1 = (response_1/(Tii*(1-response_1)));
C1 = simplify(C1)
% Vemos que C1 é um PID dado por:
% $$ kd_{1} = \frac{-2.688}{t_{c}} \; ; \; kp_{1} = \frac{-3}{t_{c}} \; ; \;  
% ki_{1} = \frac{-2.912}{t_{c}}$$

G2
% Obtendo a equação de malha fechada para o loop externo

closed_1 = simplify(C1*Tii/(1+C1*Tii));
To = closed_1*G2;

Too = simplify(To/(1 + To*PD2));
[noo, doo] = numden(Too);
routh(doo, s)
% Pelas condições retornadas, temos:
% $$0 < kp2 < \frac{100}{56}\\kp2 \cdot t_{c} < kd2 < \frac{100 \cdot t_{c}}{56}$$
% Escolhemos kp2 = 0.9 e kd2 = 1.4*tc

PD2 = subs(PD2, [kd2, kp2], [1.4*tc, 0.9]);
PD2 = simplify(PD2);

Too = subs(Too, [kd2, kp2], [1.4*tc, 0.9]);
Too = simplify(Too)
% Para obter a  função do controlador, fazemos

response_2 = (w^2)*(1 - 0.239*s)/(s^2 + 2*z*w*s + w^2);
C2 = (response_2/(Too*(1-response_2)));
C2 = simplify(C2)
% Ecolhendo o valor de tc
% Fazemos tc = 0.5

PD2 = subs(PD2, tc, 0.5);
PD2 = simplify(PD2);

C2 = subs(C2, tc, 0.5);
C2 = simplify(C2)
C1 = subs(C1, tc, 0.5);
C1 = simplify(vpa(C1))
% Refatorando C2
% $$-\frac{w^2 \cdot (108s^3 + 496s^2 + 6867s + 8829)}{10s \cdot (s + 2wz) \cdot 
% (56s^2 - 981)} = -\frac{w^2 \cdot (s+1.3822)\cdot(s+1.6052 - 7.5213 i)\cdot(s+1.6052 
% + 7.5213 i)}{10s \cdot (s + 2wz) \cdot (56s^2 - 981)}\\= \left[\frac{s+1.3822}{ 
% (s + 2wz) \cdot (56s^2 - 981)} \right] \cdot \left[ \frac{w^2}{10} \cdot \frac{s^2 
% + 3.2104 s + 59.1466}{s} \right]$$
% 
% Obtemos, portanto, a função de um filtro de ruído multiplicada pela função 
% de um PID
%% 
% Os valores de w e z são definidos pelo usuário, escolheremos os valores de 
% z e Ts, pois assim é mais fácil ober w através da equação $w=\frac{2\ldotp 5}{z\;\cdot 
% \textrm{Ts}}$ , onde Ts é o tempo de acomodação. Logo, para uma ultrapassagem 
% percentual de 2% e um  tempo de acomodação de 3 segundos

z = -log(2/100)/sqrt(pi^2 + (log(2/100))^2)
w = 2.5/(z*3)
% Substituindo em C2

C2 = w^2*(s^2 + 3.2104*s + 59.1461)/(9810*s);
digits(4);
C2 = simplify(vpa(C2))
%%
PD1
PD2
C1
C2
%%
function M = routh(eq, var)
    coeff = coeffs(eq, var, "All");
    l = length(coeff);
    M = sym(zeros(l, ceil(l/2)));
    
    j = 1;
    k = 1;
    
    for i = 1:l
        if mod(i,2) == 1  
            M(1,j) = coeff(i);
            j = j + 1;
        else
            M(2,k) = coeff(i);
            k = k + 1;
        end
    end    
    
    if l > 2
        for i = 3:l
            for j = 1:ceil(l/2)
                if j < ceil(l/2)
                    A = [M(i-2, 1) M(i-2, j+1); M(i-1, 1) M(i-1, j+1)];
                else
                    A = [M(i-2, 1) 0; M(i-1, 1) 0];
                end
            
                M(i,j) = -1*det(A)/M(i-1, 1);
            end
        end
    end
end