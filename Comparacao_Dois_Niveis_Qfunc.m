%% Encontrando os valores

clc;
clear all;
close all;

% Definindo os dois sinais

N1 = 1000; % Amostra por símbolo
M1 = 2;   % número de níveis
A1 = 5; % Amplitude máxima
dist_nivel1 = 5; % Distância entre níveis

N2 = 1000;
M2 = 2;
A2 = 5;
dist_nivel2 = 10; 

% Dados temporais:
t_final = 1; % em segundos
Rb = 1e3; % taxa de transmissão

% Número de bits por nível
l = log2(M1);

Rs = Rb/l; % taxa de símbolos
fs = Rb*N1; % Frequência de amostragem
t = [0:1/fs:t_final-((1/(Rb*N1)))]; % Criando o eixo do tempo

% Gerando número de símbolos:
num_simb = Rs*t_final;

% Informação de entrada
info_bin = randint(1, num_simb*l);
info_bin = transpose(reshape(info_bin, l , num_simb));

% Criando os dois sinais
info1 = bi2de(info_bin, 'left-msb')*dist_nivel1-A1;
info_up1 = upsample(info1,N1);

info2 = bi2de(info_bin, 'left-msb')*dist_nivel2-A2;
info_up2 = upsample(info2,N2);

% Filtrando NRZ ---> Este filtro que será casado depois
filtro_tx = ones(1, N1);

info_tx1 = filter(filtro_tx, 1, info_up1);
info_tx2 = filter(filtro_tx, 1, info_up2);

% Plotando
figure(1)

subplot(2,1,1);
plot(info_tx1)
title('Sinal na transmissão');
grid
ylim([-6 1]);

subplot(2,1,2);
plot(info_tx2)
title('Sinal na transmissão');
grid
ylim([-6 6]);

% Calculando as energias: Eb PARA CASO ESPECÍFICO
No = 2;

Eb1 = (A1^2).*t(end)/2;
Eb2 = (2*A2^2).*t(end)/2;

Qp1 = sqrt(Eb1/No);     % Polar
Qp2 = sqrt(2*(Eb2/No)); % Bipolar

Pb1 = qfunc(Qp1)
Pb2 = qfunc(Qp2)

%% Testando para N níveis

figure(2);
Eb_No = 0:15;
Pb1 = qfunc(sqrt(db2pow(Eb_No)));
Pb2 = qfunc(sqrt(2*db2pow(Eb_No)));
semilogy(Pb1);
hold on
semilogy(Pb2);
title('Comparação da taxa de erro entre unipolar x bipolar');
legend('Unipolar', 'Bipolar');
grid

    