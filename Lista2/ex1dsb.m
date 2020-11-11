clc
clear all
close all

Ao = 3;

fs = 30000;
f = -fs/2:fs/2;
t = 0:1/fs:1;

f1 = 50;
fc = 1000;

w1 = 2*pi*f1;
wc = 2*pi*fc;

% Sinal de informação:

xin = Ao + 1*cos(w1*t);


% Sinal da portadora:

xc = 1*cos(wc*t);

figure(1);
subplot(2,2,1);

plot(t, xin);
xlim([0 10/w1]);
title('Sinal de informação no tempo');

subplot(2,2,3);

plot(t, xc);
xlim([0 10/w1]);
title('Sinal da portadora no tempo');


Yin = fftshift(fft(xin))/length(fft(xin));

subplot(2,2,2);
plot(f, abs(Yin));
title('Sinal de informação na frequência');
xlim([-150 150]);

Yc = fftshift(fft(xc))/length(fft(xc));

subplot(2,2,4);
plot(f, abs(Yc));
title('Sinal da portadora na frequência');
xlim([-1500 1500]);

%% Fazendo a modulação DSB

xmod = xin.*xc;

figure(2);

subplot(2,1,1);

plot(t, xmod);
title('Sinal modulado no tempo junto com o sinal de informação');
xlim([0 10/w1]);
hold on;
plot(t, xin);
hold off;

subplot(2,1,2);

plot(f, abs(fftshift(fft(xmod))/length(fft(xmod))));
title('Sinal modulado na frequência');
xlim([-1500 1500]);

%% Fazendo a demodula��o DSB

% remultiplicando
xremult = xmod.*xc;

figure(3)
plot(t, xremult, 'b');
xlim([0 10/w1]);
title('Sinal remultiplexado no tempo Ao = 3');
hold on;
plot(t, xin, 'r');
hold off;



