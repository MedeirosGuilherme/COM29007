clc;
clear all;
close all;

%% Exercício2
%% Gerando a frequência de amostragem e tempo de amostragem:

fs = 10000;
t = 0:1/fs:1;

%% Gerando o ruído gaussiano: 

rt = randn(1,length(t));

%% Tratando o ruído: Plotando histograma, domínio no tempo, frequência e autocorrelação:

figure(1);
subplot(2,2,1);
histogram(rt);
title('Histograma do ruído gaussiano');
xlabel('Valor');
ylabel('Frequência do valor obtido');

%Ruído no tempo:
subplot(2,2,2);
plot(t, rt);
title('Ruído gaussiano')
xlabel('t');
ylabel('R(t)');

% Ruído na frequência:
Yrt = fft(rt);
Yw = fftshift(rt)/length(rt);
f = [-fs/2:fs/2];

subplot(2,2,3);
plot(f, Yw);
title('Ruído na frequência');

% Autocorreçação 

tx = linspace(-15000,15000, 20001);
Rx = xcorr(rt);
subplot(2,2,4);
plot(tx, Rx);
title('Autocorrelação do ruído');

%% Filtrando o ruído e o plotando:

filtro=fir1(50,(1000*2)/fs);
figure(2);
freqz(filtro);
rfil = filter(filtro, 1, rt);

figure(3);
subplot(3,1,1);
plot(t, rfil);
title('Ruído filtrado no domínio do tempo');

Rfilws = fft(rfil);
Rfilw = fftshift(Rfilws)/length(Rfilws);

subplot(3,1,2);
plot(f, Rfilw);
title('Ruído filtrado no domínio da frequência');

subplot(3,1,3);
histogram(rfil);
title('Histograma do ruído filtrado'); 



