
clc
clear all
close all


%% Formatação QAM e transmissão:

M = 16;
info = randi([1 15], 1, 100);   % 3, 10 e 8
%info_mod = exp(1j*2*pi*info/M);
info_mod_qam = qammod(info,M);

scatterplot(info_mod_qam);
title('Constelação QAM dos dados à serem transmitidos');

I = real(info_mod_qam);
Q = imag(info_mod_qam);

N = 100;
Ma = 4;
dist_n = 2;
Amax = 3;

Ipam = upsample(I,N);
Qpam = upsample(Q,N);

filtro_format = ones(1, N);
I_info_format = filter(filtro_format, 1, Ipam);
Q_info_format = filter(filtro_format, 1, Qpam);

figure(2);
subplot(2,1,1);
plot(I_info_format);
grid;
subplot(2,1,2);
plot(Q_info_format);
grid;

fc = 10000;
wc = 2*pi*fc;
% t = linspace(0,1,length(I_info_format));
passo = ((2*length(info))/fc)/(length(info)*N);
t = [0:passo:((2*length(info))/fc)-passo];

Rs = 100/max(t);

I_tx = I_info_format.*cos(wc*t);
Q_tx = Q_info_format.*sin(wc*t);

S_trans = I_tx - Q_tx;

figure(3);
subplot(4,1,2);
plot(t, I_tx);
xlim([0 0.005]);
title('Informação real modulada');

subplot(4,1,1);
plot(t, I_info_format);
xlim([0 0.005]);
title('Informação real formatada');

subplot(4,1,4);
plot(t, Q_tx);
xlim([0 0.005]);
title('Informação complexa modulada');

subplot(4,1,3);
plot(t, Q_info_format);
xlim([0 0.005]);
title('Informação complexa formatada');

% Sinal transmitido
figure(4);
grid
plot(t,S_trans);
title('Informação transmitida');
%ylim([0 5])

%% Recepção e demodulação QAM na recepção:

% Fazendo a multiplicação pelos cossenos

I_rx = S_trans.*cos(wc.*t);
Q_rx = S_trans.*(-sin(wc.*t));

figure(5);
grid
subplot(2,1,1);
plot(t, I_rx);
title('Sinal real após demodulação')
subplot(2,1,2);
plot(t, Q_rx);
title('Sinal imaginário após demodulação')

% Fazendo um filtro passa baixa para eliminar frequências mais altas

% I_info_format = filter(filtro_format, 1, Ipam);

filterRx = ones(1, ceil(1.5*Rs)); 
%filterRx = fir1(50, 1, 1, 0.3);

I_rx_f = filter(filterRx, 1, I_rx)/N;
Q_rx_f = filter(filterRx, 1, Q_rx)/N;

figure(6);
grid;
subplot(2,1,1);
plot(t, I_rx_f);
title('Sinal real após filtragem');
subplot(2,1,2);
plot(t, Q_rx_f);
title('Sinal imaginário após filtragem');

% Recriando amostras originais:

I_rx_Am = I_rx_f(N/2:N:end);
Q_rx_Am = Q_rx_f(N/2:N:end);

figure(7);
subplot(2,1,1);
stem(I_rx_Am);
title('Sinal real após amostragem');
subplot(2,1,2);
stem(Q_rx_Am);
title('Sinal imaginário após filtragem');

% Recriando os valores complexos:

S_rx = I_rx_Am + 1i*Q_rx_Am;
scatterplot(S_rx);

S_rx_Demod = qamdemod(S_rx, M);







