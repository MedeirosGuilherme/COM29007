clc
clear all;
close all;

%% Sinal:

A = 1;
fm = 1000;
fs = 200000;

wm = 2*pi*fm;
t = 0:1/fs:1;

mt = A*cos(wm*t);

figure(1);
subplot(2,3,1);
plot(t, mt);
title('Sinal no domínio do tempo: cos(40000.pi.t)');
xlabel('t');
xlim([0 0.01]);

subplot(2,3,4);

faxis = -fs/2:1:fs/2;

Maux = fft(mt);
Mw = fftshift(Maux)/length(Maux);
plot(faxis, abs(Mw));
title('Sinal no domínio da frequência');
xlabel('f');
xlim([-0.5*10^5 0.5*10^5]);

%% Portadora:

ac = 1;
fc = 10000;
fcs = 200000;
wc = 2*pi*fc;
tc = 0:1/fcs:1;

ct = ac*cos(wc*tc);

subplot(2,3,2);
plot(tc, ct);
title('Portadora no domínio do tempo: cos(400000.pi.t)');
xlabel('t');
xlim([0 0.001]);

subplot(2,3,5);
fcaxis = -fcs/2:1:fcs/2;

Caux = fft(ct);
Cw = fftshift(Caux)/length(Caux);

plot(faxis, Cw);
title('Portadora no domínio da frequência:');
xlabel('f');
ylim([0 0.45]);

%% Modulando o sinal:

subplot(2,3,3);

st = mt.*ct;
plot(t, st);
xlim([0 0.001]);
title('Sinal modulado no tempo');

Saux = fft(st);
Sw = fftshift(Saux)/length(Saux);
subplot(2,3,6);

plot(faxis, abs(Sw));
title('Sinal modulado na frequência');
xlim([-0.2*10^5 0.2*10^5]);


%% Recuperando o sinal:

figure(2);
subplot(2,2,1);
mrec = st.*ct;

plot(t, mrec);
xlim([0 0.001]);
title('Sinal reportado no tempo');

MrecAux = fft(mrec);
Mrecw = fftshift(MrecAux)/length(MrecAux);

subplot(2,2,3);
plot(faxis, Mrecw);
ylim([0 0.25]);
title('Sinal reportado na frequência');

fil = fir1(40, (2*fm)/fs);
mfil = filter(fil, 1, mrec);

subplot(2,2,2);
plot(t, mfil);
xlim([0 0.01]);
title('Sinal recuperado no tempo');

MfilAux = fft(mfil);
Mfilw = fftshift(MfilAux)/length(MfilAux);

subplot(2,2,4);
plot(faxis, Mfilw);
title('Sinal recuperado na frequência');
ylim([0 0.2]);






