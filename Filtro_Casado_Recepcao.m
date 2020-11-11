%% Melhorando o desempenho: Aplicando filtro NRZ (ones) no receptor

% Formatando em vários níveis

clear all
close all
clc

% Formatando em mais de 1 nível

N = 1000; % Amostras por símbolo
M = 2;  % Número de níveis
A = 1; % Amplitude máxima
dist_nivel = 2; %Distancia entre níveis

% Dados temporais:
t_final = 2; % em segundos
Rb = 2e3; % taxa de transmissão

% Número de bits por nível
l = log2(M);

Rs = Rb/l; % taxa de símbolos
fs = Rb*N; % Frequência de amostragem
t = [0:(1/(Rb*N)):t_final-((1/(Rb*N)))]; % Criando o eixo do tempo
f = [-(Rs*N)/2:(1/t_final):(Rs*N)/2-(1/t_final)];  % Eixo da frequência

% Gerando número de símbolos:
num_simb = Rs*t_final;

% Informação de entrada
info_bin = randint(1, num_simb*l);

% Fazendo o reshape para o bi2de
info_bin = transpose(reshape(info_bin, l , num_simb));

% Transformando em decimal à cada 2 bits:
info = bi2de(info_bin, 'left-msb')*dist_nivel-A;%----- Mapeamento: 00 --> 0 --> -3
info_up = upsample(info,N);                 %             01 --> 1 --> -1
                                            %             10 --> 2 -->  2
                                            %             11 --> 3 -->  3

% Filtrando NRZ ---> Este filtro que será casado depois
filtro_tx = ones(1, N);
info_tx = filter(filtro_tx, 1, info_up);
                                                     
% plotando: Sinal TX **************************

figure(1)
subplot(2,1,1);
plot(info_tx)
xlim([0 20*N])
ylim([-4 4])
title('Sinal na transmissão no tempo');
grid

subplot(2,1,2)
info_TX = fftshift(fft(info_tx));
plot(f, abs(info_TX).^2);
xlim([-5*Rs 5*Rs]);
title('Sinal na transmissão na frequência');
grid
 % ************************************************

SNRmin = 0;
SNRmax = 10;

limiar_est = 0;

SNR = SNRmax;
info_rx = awgn(info_tx,SNR - log10(N));
info_est = info_rx(N/2:N:end)>limiar_est;
num_err(SNR+1) = sum(xor(info_bin, info_est)); %Verificando o erro
taxa_erro(SNR+1) = num_err(SNR+1)/num_simb;

figure (2);
subplot(2,1,1);
plot(t, info_rx);
xlim([0 10/Rs])
grid on

subplot(2,1,2);
plot(f, fftshift(fft(info_rx)/length(info_rx)))
xlim([-5*Rs 5*Rs]);
ylim([0 0.05]);

% Fazendo o filtro casado ----------------------- MAIS IMPORTANTE DESSA AULA

filtro_rx = fliplr(filtro_tx);

% Variando relação sinal/ruído com filtro
SNR = 1
info_rx = awgn(info_tx,SNR, 'measured');
info_rx_filtered = filter(filtro_rx,1,info_rx)/N; %% Filtrando com o filtro casado
info_est = info_rx_filtered(N/2:N:end)>limiar_est;
num_err(SNR+1) = sum(xor(info_bin, info_est)); %Verificando o erro
taxa_erro(SNR+1) = num_err(SNR+1)/num_simb;

% Plotando a taxa de erros:

figure(3);
subplot(3,1,1);
plot(t, info_tx);
title('Sinal transmitido');
xlim([0 10e-3]);
ylim([-2 2]);
grid

subplot(3,1,2);
plot(t, info_rx);
title('Sinal na entrada da recepção');
xlim([0 10e-3]);
grid

subplot(3,1,3);
plot(t, info_rx_filtered);
title('Sinal efetivamente recebido');
xlim([0 10e-3]);
ylim([-2 2]);
grid

