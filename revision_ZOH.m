clc;
clear;
close all;

k = 5;
tau = 10;
Ts = 1/tau;
p = tf('s');

Gp = k/(1+tau*p);
display(Gp);
Gz = c2d(Gp,Ts,'zoh');
display(Gz);

figure;
step(Gp,'b',Gz,'r--');
legend('Continuous','ZOH Discrete')
grid on;