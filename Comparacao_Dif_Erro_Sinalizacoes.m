%% Variando valores de SNR na recepção de sinais

% Formatando em vários níveis

%% Nível 1:
% S1(t) = v
% S2(t) = -v

clear all
close all
clc

V1 = 2;

% Formatando em mais de 1 nível

N = 100; %Amostras por pulso
M = 2;  % Número de níveis
A = V1; % Amplitude máxima
dist_nivel = 2*V1; %Distancia entre níveis

% Número de bits por nível
l = log2(M);

% Gerando número de símbolos:
num_simb = 50000;

% Informação de entrada
info_bin = randint(1, num_simb*l);

% Fazendo o reshape para o bi2de
info_bin = transpose(reshape(info_bin, l , num_simb));

% Transformando em decimal à cada 2 bits:
info = bi2de(info_bin, 'left-msb')*dist_nivel-A;%----- Mapeamento: 00 --> 0 --> -3
info_up = upsample(info,N);                 %             01 --> 1 --> -1
                                            %             10 --> 2 -->  2
                                            %             11 --> 3 -->  3
% Filtrando
filtro = ones(1, N);
info_tx = filter(filtro, 1, info_up);
                                                     
% plotando
plot(info_tx)
grid
xlim([0 20*N])
ylim([-4 4])
title('Sinal na transmissão');

SNRmin = 0;
SNRmax = 15;

limiar_est = 0;

% Variando relação sinal/ruído 
for SNR = SNRmin:SNRmax
    info_rx = awgn(info_tx,SNR, 10*log10(V1^2));
    info_est = info_rx(N/2:N:end)>limiar_est;
    num_err(SNR+1) = sum(xor(info_bin, info_est)); %Verificando o erro
    taxa_erro(SNR+1) = num_err(SNR+1)/num_simb;
end

% Plotando a taxa de erros:

figure(2)
semilogy([SNRmin:1:SNRmax], taxa_erro);
xlim([0 15])
grid

title('Dependência da Taxa de erro pelo SNR');
xlabel('SNR[dB]');
ylabel('Bit Error Rate');



%% Nível 2:
% S1(t) = 2v
% S2(t) = 0

V2 = V1*sqrt(2);

% Formatando em mais de 1 nível

N = 100; %Amostras por pulso
M = 2;  % Número de níveis
A = V2; % Amplitude máxima
dist_nivel = V2; %Distancia entre níveis

% Número de bits por nível
l = log2(M);

% Gerando número de símbolos:
num_simb = 50000;

% Informação de entrada
info_bin = randint(1, num_simb*l);

% Fazendo o reshape para o bi2de
info_bin = transpose(reshape(info_bin, l , num_simb));

% Transformando em decimal à cada 2 bits:
info = bi2de(info_bin, 'left-msb')*A;%----- Mapeamento: 00 --> 0 --> -3
info_up = upsample(info,N);                 %             01 --> 1 --> -1
                                            %             10 --> 2 -->  2
                                            %             11 --> 3 -->  3
% Filtrando
filtro = ones(1, N);
info_tx = filter(filtro, 1, info_up);
                                                     
% plotando
figure(3)
plot(info_tx)
grid
xlim([0 20*N])
ylim([-4 4])
title('Sinal na transmissão');

SNRmin = 0;
SNRmax = 15;

limiar_est = V2/2;

% Variando relação sinal/ruído 
for SNR = SNRmin:SNRmax
    info_rx = awgn(info_tx,SNR, 10*log10(V2^2));
    info_est = info_rx(N/2:N:end)>limiar_est;
    num_err(SNR+1) = sum(xor(info_bin, info_est)); %Verificando o erro
    taxa_erro(SNR+1) = num_err(SNR+1)/num_simb;
end

% Plotando a taxa de erros:

figure(4)
semilogy([SNRmin:1:SNRmax], taxa_erro);
grid

title('Dependência da Taxa de erro pelo SNR');
xlabel('SNR[dB]');
ylabel('Bit Error Rate');

%% Nível 3:
% S1(t) = 2v
% S2(t) = 0

V2 = V1;

% Formatando em mais de 1 nível

N = 100; %Amostras por pulso
M = 2;  % Número de níveis
A = V2; % Amplitude máxima
dist_nivel = V2; %Distancia entre níveis

% Número de bits por nível
l = log2(M);

% Gerando número de símbolos:
num_simb = 50000;

% Informação de entrada
info_bin = randint(1, num_simb*l);

% Fazendo o reshape para o bi2de
info_bin = transpose(reshape(info_bin, l , num_simb));

% Transformando em decimal à cada 2 bits:
info = bi2de(info_bin, 'left-msb')*A;%----- Mapeamento: 00 --> 0 --> -3
info_up = upsample(info,N);                 %             01 --> 1 --> -1
                                            %             10 --> 2 -->  2
                                            %             11 --> 3 -->  3
% Filtrando
filtro = ones(1, N);
info_tx = filter(filtro, 1, info_up);
                                                     
% plotando
figure(5)
plot(info_tx)
grid
xlim([0 20*N])
ylim([-4 4])
title('Sinal na transmissão');

SNRmin = 0;
SNRmax = 15;

limiar_est = V2/2;

% Variando relação sinal/ruído 
for SNR = SNRmin:SNRmax
    info_rx = awgn(info_tx,SNR, 10*log10(V2^2));
    info_est = info_rx(N/2:N:end)>limiar_est;
    num_err(SNR+1) = sum(xor(info_bin, info_est)); %Verificando o erro
    taxa_erro(SNR+1) = num_err(SNR+1)/num_simb;
end

% Plotando a taxa de erros:

figure(6)
semilogy([SNRmin:1:SNRmax], taxa_erro);
grid

title('Dependência da Taxa de erro pelo SNR');
xlabel('SNR[dB]');
ylabel('Bit Error Rate');