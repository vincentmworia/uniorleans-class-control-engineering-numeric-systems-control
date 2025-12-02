clc; clear all; close all;
%% 1. Nichols 
Gp = tf(10,[1/100 0.1 1])

figure;
nichols(Gp);
grid on;
title('Black-Nichols Chart of G(p)');

%% 2. Kp Estimation
lambda = 0.7;

% Resonance factor Q from damping lambda
Q  = 1 / (2*lambda*sqrt(1 - lambda^2));
Q2 = Q^2;
fprintf('\nQn3: lambda = %.2f  ->  Q = %.3f\n', lambda, Q); 

omega_r = 7.07;

[mag_r, phase_deg_r] = bode(Gp, omega_r);
mag_r = squeeze(mag_r);                 % |G(j*omega_r)|
phi_r = squeeze(phase_deg_r)*pi/180;    % phase in radians

% Q^2 = X^2 / (1 + 2 X cos(phi_r) + X^2) 
a = Q2 - 1;
b = 2*Q2*cos(phi_r);
c = Q2;

disc = b^2 - 4*a*c;
if disc < 0
    error('No real solution for X at this frequency.');
end

X1 = (-b + sqrt(disc)) / (2*a);
X2 = (-b - sqrt(disc)) / (2*a);

% X is a magnitude, so take absolute values and choose the smaller one
X_candidates = abs([X1, X2]);
X = min(X_candidates);

Kp = X / mag_r;           

fprintf('Estimated proportional gain  Kp ≈ %.3f\n', Kp);

%% Qn4: Compute Ti
Ti = 5 / 7.07;           
fprintf('Qn4: Ti = %.4f seconds\n', Ti);

%% Qn5: Continuous TF of the controller (PI)
s  = tf('s');
Cs = Kp * (1 + 1/(Ti*s)) 

%% Qn6: Digital transfer function of the controller (Tustin)
Cz = c2d(Cs, 0.04, 'tustin')