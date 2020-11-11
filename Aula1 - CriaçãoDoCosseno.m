
clc;
clear all;
close all;
f = 1000;
T = 1/f;
t = 0:0.00001:0.01;

y = 10*sin(2.*pi.*f.*t);

subplot(2,1,1);
plot(t,y,'r');
xlim([0 1e-3]);
ylim([-11 11]);
xlabel('t');
ylabel('Sin(t)');
title('Sinal no tempo');

subplot(2,1,2);
Y = fft(y);
Ys = fftshift(Y);
plot(abs(Ys));
title('Sinal na frequencia');
xlabel('f');
ylabel('F(Sin(t))');
