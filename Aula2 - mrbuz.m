clc;
clear all;
close all;

s = wavread('mr.bubz (short meme).wav');
st = s(:,1);

t = linspace(0,7,311296); %Mesmo pontos da fs
fs = 1/311297;

figure(1)
subplot(2,1,1);
plot(t, s, 'r');
title('Sinal no domínio do tempo');
xlim([0 0.1]);

subplot(2,1,2);
Sy = fft(st);
Sy = Sy';
S = fftshift(Sy)/length(Sy);
f = [-fs/2:fs/2];

plot(f,S);
xlim([-500 500]);
title('Sinal no domínio da frequência');

