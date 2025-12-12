clc;
clear;
close all;

%% 1. Digital Transfer Function

k = 2;
tau = 0.1;
Ts = 0.01;
p = tf('s');

Gp = k/(1+tau*p);
display(Gp);
Gz = c2d(Gp,Ts,'zoh'); 
display(Gz);

%% 2. Nichol's chart
function plotNichols(sys,ttle)
    figure;
    nichols(sys);
    grid on;
    title(ttle);
end

plotNichols(Gp,'Black-Nichols chart of Gp');


%% 3. Estimate Kp
lamda = 0.42;
Q = 1 / (2*lamda*sqrt(1-lamda^2));
Q_squared = Q^2; 

omega_c = 1 / tau;
[mag_g,phase_g_degrees] = bode (Gp, omega_c);
mag_g = squeeze(mag_g);
phase_g = squeeze(phase_g_degrees) * pi/180;

a = Q_squared - 1;
b = 2 * Q_squared * cos(phase_g);
c = Q_squared;
discriminant = b^2-4*a*c;

if(discriminant<0)
    error('No real roots');
end

G1 = (-b + sqrt(discriminant))/(2*a);
G2 = (-b - sqrt(discriminant))/(2*a);

G = min(abs([G1,G2]));
kp = G/mag_g;
fprintf("\nThe estimated value of Kp is %.3f\n",kp) ;
%% 4. Estimate Ti
Ti = 5/omega_c;
fprintf("\nThe estimated value of Integral Time is is %.3f\n",Ti) ;


%% 5. TF of the continuous controller
Cp = kp * (1+(1/(Ti*p)));
display(Cp);
plotNichols(Cp,'Black-Nichols chart of Cp');

%% 6. TF of the digital controller
Cz =c2d(Cp,Ts, 'tustin');
display(Cz);