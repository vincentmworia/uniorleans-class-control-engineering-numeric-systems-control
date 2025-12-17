clear; clc; close all;

%% -------------------------------------------------------
%   PART I – ZERO ORDER HOLD (ZOH) APPROXIMATION
%% -------------------------------------------------------

%% 1. Compute the sampled transfer function G(z)
Ts = 0.01;                       % Sampling period
p  = tf('s');
Gp = 2/(1 + 0.1*p);              % Continuous plant G(p)
Gz = c2d(Gp, Ts, 'zoh');         % Discrete-time model using ZOH

%% 2. Zero-Order Hold transfer function (Laplace domain)
Bzoh = (1 - exp(-Ts*p)) / p;     % (not strictly needed later, but nice to keep)

%% 3. Frequency-domain representation B(jw)
w = logspace(0, 3.3, 400)';      % 10^0 to ~2000 rad/s, column vector

% Normalized ZOH frequency response:
% B(jw) = (1 - e^{-jwTs}) / (jwTs) = sinc * delay, DC gain = 1
Bjw = (1 - exp(-1j*w*Ts)) ./ (1j*w*Ts);    % Nx1

magB_db = 20*log10(abs(Bjw));
phaseB  = angle(Bjw);                       % radians

figure;
subplot(2,1,1);
semilogx(w, magB_db, 'LineWidth', 1.3); hold on;
semilogx(w, zeros(size(w)), 'r--', 'LineWidth', 1);  % 0 dB reference
grid on;
title('Magnitude of B(j\omega)');
xlabel('\omega (rad/s)'); ylabel('|B(j\omega)| (dB)');
legend('Exact','0 dB','Location','SouthWest');

subplot(2,1,2);
semilogx(w, phaseB, 'LineWidth', 1.3); hold on;
semilogx(w, -w*Ts/2, 'r--', 'LineWidth', 1);         % -ωTs/2 approximation
grid on;
title('Phase of B(j\omega)');
xlabel('\omega (rad/s)'); ylabel('Phase (rad)');
legend('Exact','- \omega T_s / 2','Location','SouthWest');

%% 4. Compare G(z) and G(jw)*B(jw) using Bode and Nichols

% Continuous G(jw) on same grid
Gjw  = squeeze(freqresp(Gp, w));          % Nx1
GjwB = Gjw .* Bjw;                         % G(jw) * B(jw), Nx1

% Bode of G(z) on same grid
[magZ, phaseZ] = bode(Gz, w);             % 1x1xN
magZ   = squeeze(magZ);                   % Nx1
phaseZ = squeeze(phaseZ);                 % Nx1, degrees

% ---- BODE COMPARISON ----
figure;

subplot(2,1,1);
semilogx(w, 20*log10(abs(GjwB)), 'LineWidth', 1.3); hold on;
semilogx(w, 20*log10(magZ), '--', 'LineWidth', 1.3);
grid on;
title('Bode Magnitude: G(j\omega)B(j\omega) vs G(z)');
xlabel('\omega (rad/s)'); ylabel('Magnitude (dB)');
legend('G(j\omega)B(j\omega)', 'G(z)', 'Location', 'Best');

subplot(2,1,2);
semilogx(w, angle(GjwB), 'LineWidth', 1.3); hold on;
semilogx(w, phaseZ*pi/180, '--', 'LineWidth', 1.3);
grid on;
title('Bode Phase: G(j\omega)B(j\omega) vs G(z)');
xlabel('\omega (rad/s)'); ylabel('Phase (rad)');
legend('G(j\omega)B(j\omega)', 'G(z)', 'Location', 'Best');

%% ---- NICHOLS COMPARISON ----
GjwB_frd = frd(reshape(GjwB,1,1,[]), w);   % 1x1xN -> FRD model

figure;
nichols(GjwB_frd, 'b'); hold on;
nichols(Gz, 'r--');
grid on;
title('Nichols Plot: G(j\omega)B(j\omega) vs G(z)');
legend('G(j\omega)B(j\omega)', 'G(z)', 'Location', 'Best');
