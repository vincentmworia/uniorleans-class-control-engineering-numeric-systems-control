clear; clc; close all;

%% Qn1: Digital transfer function of the system
Ts = 0.01;                    % sampling time (s)

Gp = tf(2, [0.1 1]);          % continuous plant G(s) = 2 / (0.1 s + 1)
Gz = c2d(Gp, Ts, 'zoh');      % discrete plant with ZOH

disp('Qn1: Digital plant Gz(z) with ZOH:');
Gz

% Justify sampling time using Shannon (from continuous bandwidth)
figure;
bode(Gp);
grid on;
title('Bode plot of G(p)');

wmax       = 100;             % rad/s (chosen from Bode plot)
fmax       = wmax/(2*pi);     % Hz
fe_shannon = 2 * fmax;        % minimal sampling frequency
Te_shannon = 1 / fe_shannon;  % maximal sampling period

fprintf('fmax       = %.3f Hz\n', fmax);
fprintf('fe_shannon = %.3f Hz\n', fe_shannon);
fprintf('Te_shannon = %.5f s\n', Te_shannon);
fprintf('Chosen Ts  = %.5f s\n', Ts);

%% Qn2: Continuous transfer function on a Black–Nichols chart
figure;
nichols(Gp);
grid on;
title('Black-Nichols Chart of G(p)');

%% Qn3: Estimate proportional gain Kp from damping factor lambda = 0.42
lambda = 0.42;

% Resonance factor Q from damping lambda
Q  = 1 / (2*lambda*sqrt(1 - lambda^2));
Q2 = Q^2;
fprintf('\nQn3: lambda = %.2f  ->  Q = %.3f\n', lambda, Q);

% "Resonance" frequency for this 1st-order system ≈ 1/tau = 10 rad/s
omega_r = 10;                 % rad/s

% Frequency response of plant at omega_r
[mag_r, phase_deg_r] = bode(Gp, omega_r);
mag_r = squeeze(mag_r);                 % |G(j*omega_r)|
phi_r = squeeze(phase_deg_r)*pi/180;    % phase in radians

% Quadratic in X = Kp * |G(j*omega_r)|:
% Q^2 = X^2 / (1 + 2 X cos(phi_r) + X^2)
% -> (Q^2 - 1) X^2 + 2 Q^2 cos(phi_r) X + Q^2 = 0

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

Kp = X / mag_r;               % proportional gain

fprintf('Estimated proportional gain  Kp ≈ %.3f\n', Kp);

% Nichols plot with and without Kp
figure;
nichols(Gp, Kp*Gp);
grid on;
legend('Gp','Kp*Gp','Location','Best');
title(sprintf('Nichols chart: Gp and Kp*Gp (Kp ≈ %.3f)', Kp));

%% Qn4: Compute Ti
Ti = 5 / omega_r;             % Ti = 5 / omega_r
fprintf('Qn4: Ti = %.4f seconds\n', Ti);

%% Qn5: Continuous TF of the controller (PI)
s  = tf('s');
Cs = Kp * (1 + 1/(Ti*s));     % C(s) = Kp(1 + 1/(Ti s))

fprintf('\nQn5: Continuous PI Controller:\n');
fprintf('C(s) = %.3f + %.3f/s\n', Kp, Kp/Ti);
disp('Transfer function C(s):');
Cs

%% Qn6: Digital transfer function of the controller (Tustin)
Cz = c2d(Cs, Ts, 'tustin');

fprintf('\nQn6: Digital PI Controller C(z) (Tustin, Ts = %.5f s):\n', Ts);
Cz
