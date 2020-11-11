clc;
clear all;
close all;

%% Lendo o sinal
fs = 11461;
xaudt = audioread('/home/aluno/Downloads/Dog-Bark.wav');
xaud = transpose(xaudt(:,1));

%% Plotando o sinal no domínio do tempo
subplot(2,1,1)
t = linspace(0, 1, 11462);
plot(t, xaud);
title('Sinal no domínio do tempo');
xlim([0 0.6]);

%% Gerando e plotando o sinal no domínio da frequência
subplot(2,1,2);
Yaud = fft(xaud);
Y = fftshift(Yaud)/length(Yaud);

f = -fs/2:1:fs/2;
plot(f, Y);
title('Sinal no domínio da frequência');
xlim([-1000 1000]);
ylim([-0.02 0.02]);

%% Criando a portadora:
fct = fs/10;
ct = cos(2*pi*fct*t);

figure(2);
subplot(2,1,1)
plot(t, ct);
xlim([0 0.05]);
title('Portadora no tempo');

%% Multiplicando a portadora:

st = xaud.*ct;
subplot(2,1,2);
plot(t, st);
title('Portadora multiplicada pelo sinal');
xlim([0 0.5]);

Sfaux = fft(st);
Sf = fftshift(Sfaux)/length(Sfaux);

plot(f, Sf);
xlim([-3000 3000]);
title('Portadora multiplicada pelo sinal na frequência');

%% Aplicando o filtro e recuperando o sinal
strec = st.*ct;
figure(3);
subplot(3,1,1);
plot(t, strec);
title('Sinal multiplicado de novo pela portadora');

Strecaux = fft(strec);
Stref = fftshift(Strecaux)/length(Strecaux);
subplot(3,1,2);
plot(f, Stref);
title('Sinal pronto para ter o filtro aplicado');

fm = 1172;
fil = fir1(50, (2*fm)/fs);
mfil = filter(fil, 1, st);

subplot(3,1,3);

plot(t, mfil);
xlim([0 0.6]);
title('Sinal recuperado após o filtro');


figure(4);
plot(t, xaud);
hold on;
plot(t, mfil, 'r');
title('Comparação do sinal antes e depois da modulação');
xlim([0 0.5]);


