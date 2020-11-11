clear all
close all
clc

%% Gerando os cossenos em 1kHz, 2kHz e 3kHz

fs = 200000;
t = [0:1/fs:1];

f1 = 1000;
f2 = 2000;
f3 = 3000;

w1 = 2*pi*f1;
w2 = 2*pi*f2;
w3 = 2*pi*f3;

x1 = cos(w1*t);
x2 = cos(w2*t);
x3 = cos(w3*t);

figure(1)
% Sinais no domínio do tempo
subplot(311);

plot(t,x1);
title('cosseno em 1kHz no tempo');
xlim([0 0.02])

subplot(312);
plot(t,x2);
title('cosseno em 2kHz no tempo');
xlim([0 0.02])

subplot(313);
plot(t,x3);
title('cosseno em 3kHz no tempo');
xlim([0 0.02])

% Sinais no domínio da frequência 

f =  -fs/2:fs/2;
Y1 = fftshift(fft(x1))/length(fft(x1));
Y2 = fftshift(fft(x2))/length(fft(x2));
Y3 = fftshift(fft(x3))/length(fft(x3));

figure(2)

subplot(311)
plot(f, abs(Y1));
title('cosseno em 1kHz na frequência');
xlim([-1500 1500])

subplot(312);
plot(f, abs(Y2));
title('cosseno em 2kHz na frequência');
xlim([-2500 2500])

subplot(313);
plot(f, abs(Y3));
title('cosseno em 3kHz na frequência');
xlim([-3500 3500])

%% Modulando os sinais

fc1 = 10000;
fc2 = 12000;
fc3 = 13000;

wc1 = 2*pi*fc1;
wc2 = 2*pi*fc2;
wc3 = 2*pi*fc3;

xc1 = cos(wc1*t);
xc2 = cos(wc2*t);
xc3 = cos(wc3*t);

Yc1 = fftshift(fft(xc1))/length(fft(xc1));
Yc2 = fftshift(fft(xc2))/length(fft(xc2));
Yc3 = fftshift(fft(xc3))/length(fft(xc3));

figure(3);

subplot(311);
plot(f, abs(Yc1));
xlim([-12000 12000]);
title('Sinal de modulação em 10kHz');

subplot(312);
plot(f, abs(Yc2));
xlim([-15000 15000]);
title('Sinal de modulação em 12kHz');

subplot(313);
plot(f, abs(Yc3));
xlim([-16000 16000]);
title('Sinal de modulação em 13kHz');

%% Fazendo a modulação de sinal pra sinal:

xm1 = x1.*xc1;
xm2 = x2.*xc2;
xm3 = x3.*xc3;

Ym1 = fftshift(fft(xm1))/length(xm1);
Ym2 = fftshift(fft(xm2))/length(xm2);
Ym3 = fftshift(fft(xm3))/length(xm3);

figure(4);

subplot(311);
plot(f, abs(Ym1));
xlim([-13000 13000]);
title('Sinal 1 modulado');

subplot(312);
plot(f, abs(Ym2));
xlim([-15000 15000]);
title('Sinal 2 modulado');

subplot(313);
plot(f, abs(Ym3));
xlim([-18000 18000]);
title('Sinal 3 modulado');

%% Filtrando os sinais para evitar sobreposição:

% Criando filtros ideais:

% Sinal 1

fi1 = [zeros(1, 89000) ones(1, 2000) zeros(1, 9001) zeros(1, 10000) ones(1, 2000) zeros(1, 88000)];

figure(5);
Ym1f = fi1.*Ym1;

subplot(3,1,1);
plot(f, abs(Ym1f));
title('Sinal 1 filtrado em 11kHz');

% Sinal 2

fi2 = [zeros(1, 85000) ones(1, 2000) zeros(1, 13001) zeros(1, 13000) ones(1, 2000) zeros(1, 85000)];
Ym2f = fi2.*Ym2;

subplot(3,1,2);
plot(f, abs(Ym2f));
title('Sinal 2 filtrado em 14kHz');

% Sinal 3

fi3 = [zeros(1, 83000) ones(1, 2000) zeros(1, 15001) zeros(1, 15000) ones(1, 2000) zeros(1, 83000)];
Ym3f = fi3.*Ym3;

subplot(3,1,3);
plot(f, abs(Ym3f));
title('Sinal 3 filtrado em 16kHz');

%% Somando os sinais para transmissão:

Ysum = Ym1f + Ym2f + Ym3f;
figure(6);

plot(f, abs(Ysum));
title('Sinais somados');
xlabel('Frequência');
ylabel('Amplitude');
xlim([-17000 17000]);

%% Aplicando os mesmos filtros para poder recuperar os sinais.

Ypf1 = Ysum.*fi1;
Ypf2 = Ysum.*fi2;
Ypf3 = Ysum.*fi3;

%% Demodulando os sinais:

% Sinal 1:

figure(6);

fa = -fs:fs;
Y1remult = conv(Ypf1,Yc1);

subplot(3,1,1);
plot(fa, abs(Y1remult));
xlim([-22000 22000])
title('Sinal 1 remultiplexado');

% Sinal 2:

Y2remult = conv(Ypf2,Yc2);

subplot(3,1,2);
plot(fa, abs(Y2remult));
xlim([-27000 27000])
title('Sinal 2 remultiplexado');

% Sinal 3:

Y3remult = conv(Ypf3,Yc3);

subplot(3,1,3);
plot(fa, abs(Y2remult));
xlim([-29000 29000])
title('Sinal 3 remultiplexado');

%% Passando um filtro passa baixas para recuperar os sinais originais:

figure(7);

% Frequência de corte dos filtros:
fm1 = 3000;
fm2 = 4000;
fm3 = 5000;

% Criando os filtros:

fil1 = fir1(50, 2*fm1/fs);
fil2 = fir1(50, 2*fm2/fs);
fil3 = fir1(50, 2*fm3/fs);

%Recuperando os sinais demodulados no tempo:

x1remult = ifft(Y1remult);
x2remult = ifft(Y2remult);
x3remult = ifft(Y3remult);

ta = 0:1/2*fs:1;
plot(ta, x1remult);
















