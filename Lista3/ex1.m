clc
clear all
close all

%% Gerando o sinal de informação:
% Sinal:
info_bin = [0 1 1 0 1 0 1 1 0 1 0];

% Parâmetros da transmissão:
N = 10; % Número de amostras por símbolo
M = 2;  % Número de níveis
A = 1; % Amplitude máxima
dist_nivel = 1; %Distancia entre níveis
num_simb = length(info_bin); % Número de símbolos
Amax = A; % Maior amplitude
Amin = A -dist_nivel; % Menor amplitude

% Dados temporais:
t_final = 1; % em segundos
Rb = 1e3; % taxa de transmissão

% Número de bits por nível
l = log2(M); 

Rs = Rb/l; % taxa de símbolos
fs = Rb*N; % Frequência de amostragem
t = [0:1/fs:t_final-((1/(Rb*N)))]; % Criando o eixo do tempo

info_bin = transpose(reshape(info_bin, l , num_simb)); % Fazendo o reshape para o bi2de

info = bi2de(info_bin, 'left-msb')*dist_nivel-A; % transformando código binário em decimal
info_up = upsample(info,N);  % Dando o upsample considerando o número de amostras por símbolo

%% Criando o filtro NRZ para a padronização do sinal
filtro_tx = ones(1, N); % Criando um filtro para padronização NRZ
info_tx = filter(filtro_tx, 1, info_up)+1;  % Criando o sinal na saída

%% Primeiro plot: Características do sinal na saída: 

figure(1);
subplot(2,1,1);
stem(info_bin);
title('Bits de entrada');
legend('Informação');
ylim([0 1.5]);
grid

subplot(2,1,2);
plot(info_tx);
ylim([0 1.5]);
title('Características do sinal transmitido no padrão NRZ unipolar');
grid
legend('Sinal NRZ na transmissão');

%% Criando o ruído e colocando no sinal:

SNR = 10-10*log10(N); % Relação sinal ruído

%% Recebendo o sinal sem filtro casado:

limiar_est = (Amax - Amin)/2;   % Definindo limiar de comparação ótimo
info_rx = awgn(info_tx, SNR, 'measured');   % Aplicando ruído no sinal
info_est = info_rx(N/2:N:end)>limiar_est; % Só é feita a comparação

%% Plotando a informação na chegada sem filtro casado:

figure(2);

subplot(3,1,1);
stem(info_bin);
title('Dados de entrada');
legend('Informação');
ylim([0 1.5]);
grid

subplot(3,1,2);
plot(info_rx);
grid
title('Sinal recebido sem utilização de filtro casado');
legend('Sinal recebido');

subplot(3,1,3);
stem(info_est);
title('Sinal após a comparação sem utilização de filtro casado');
legend('Informação recebida');
ylim([0 1.5]);
grid

%% Fazendo a recepção do sinal com filtro casado:

filtro_rx = fliplr(filtro_tx);  % Filtro casado
info_rx_filtered = filter(filtro_rx,1,info_rx)/N; % Criando o sinal filtrado
info_est = info_rx_filtered(N/2:N:end)>limiar_est;  % Comparando agora o sinal filtrado

%% Plotando o sinal recebido com a técnica da utilização de filtros casados

figure(3)

subplot(3,1,1);
stem(info_bin);
title('Dados de entrada');
legend('Informação');
xlim([0 13]);
ylim([0 1.5]);
grid

subplot(3,1,2);
plot(info_rx);
grid
title('Sinal recebido');
legend('Sinal recebido');

subplot(3,1,3);
plot(info_est);
title('Sinal após a comparação utilizando filtro casado');
legend('Informação recebida');
xlim([0 13]);
ylim([0 1.5]);
grid



















