clc;
clear all;
close all;

%% Exercício 1:
%% Criando as variáveis de frequência e tempo: 
f1 = 1000;
f2 = 3000;
f3 = 5000;
fs = 15000;

t = 0:1/fs:1;

%% Criando as senóides no tempo: 
x1 = 6*cos(f1*t);
x2 = 2*cos(f2*t);
x3 = 4*cos(f3*t);

xt = x1 + x2 + x3;

%% Plotando as funções no tempo: 
figure(1);
plot(t,xt);
xlim([0 0.05]);
title('Sinal no domínio do tempo');
xlabel('t');
ylabel('x(t)');


Yaux = fft(xt);
Yw = fftshift(Yaux)/length(Yaux); 
f = [-fs/2:1:fs/2];

%% Plotando os sinais no domínio da frequência: 

figure(2)
plot(f, abs(Yw));
xlim([-1000 1000]);
title('Sinal no domínio da frequência');
xlabel('f');
ylabel('Y(f)');

%% Calculando a potência média do sinal:

P = (norm(xt)^2)/length(xt);
fprintf('Potência média do sinal: %f\n', P);

%% Calculando e plotando a densidade espectral de potência do sinal:

figure(3);
pwelch(xt,[],[],[],fs);

