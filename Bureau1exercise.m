clear; clc; close all;

%% -------------------------------------------------------
%   PART I – ZERO ORDER HOLD (ZOH) APPROXIMATION
%% -------------------------------------------------------

%% 1. Continuous plant G(p) and sampled plant G(z)

Ts = 0.01;                     % Sampling period
s  = tf('s');

Gp = 2/(1 + 0.1*s);            % Continuous plant G(p)
Gz = c2d(Gp, Ts, 'zoh');       % Discrete-time plant G(z) with ZOH

% (Optional) Bode of G(p) vs G(z)
figure;
bode(Gp); hold on;
bode(Gz);
grid on;
title('Comparison between G(p) and G(z)');
legend('G(p)','G(z)','Location','Best');

%% 2. Zero-Order Hold transfer function in Laplace domain

Bzoh = (1 - exp(-Ts*s))/s;     % ZOH: B(s) = (1 - e^{-sTs})/s


%% 3. Frequency-domain representation B(j\omega)

w = linspace(1, 2000, 400)';   % Frequency vector (rad/s), column vector

% ZOH frequency response (normalized so that |B(j0)| = 1):
% B(jw) = (1 - e^{-jwTs}) / (jwTs)
Bjw = (1 - exp(-1j*w*Ts)) ./ (1j*w*Ts);  % N x 1 complex vector

magB_db = 20*log10(abs(Bjw));
phaseB  = angle(Bjw);          % radians

figure;
subplot(2,1,1);
plot(w, magB_db, 'LineWidth', 1.3);
grid on;
title('Magnitude of B(j\omega)');
xlabel('\omega (rad/s)'); ylabel('|B(j\omega)| (dB)');

subplot(2,1,2);
plot(w, phaseB, 'LineWidth', 1.3);
grid on;
title('Phase of B(j\omega)');
xlabel('\omega (rad/s)'); ylabel('Phase (rad)');


%% 4. Compare G(z) and G(j\omega)B(j\omega) using Bode and Nichols

% Continuous G(jw) on the same frequency grid
Gjw_array = freqresp(Gp, w);   % size: 1 x 1 x N
Gjw       = squeeze(Gjw_array);% N x 1

% Continuous plant after ZOH in frequency domain:
Gjw_B = Gjw .* Bjw;            % N x 1 complex vector: G(jw)*B(jw)

% Bode of G(z) evaluated on same frequency grid
[magZ, phaseZ] = bode(Gz, w);  % magZ, phaseZ: 1 x 1 x N
magZ   = squeeze(magZ);        % N x 1
phaseZ = squeeze(phaseZ);      % N x 1 in degrees

% ---- BODE COMPARISON ----
figure;

subplot(2,1,1);
semilogx(w, 20*log10(abs(Gjw_B)), 'LineWidth', 1.3); hold on;
semilogx(w, 20*log10(magZ), '--', 'LineWidth', 1.3);
grid on;
title('Bode Magnitude: G(j\omega)B(j\omega) vs G(z)');
xlabel('\omega (rad/s)'); ylabel('Magnitude (dB)');
legend('G(j\omega)B(j\omega)', 'G(z)', 'Location', 'Best');

subplot(2,1,2);
semilogx(w, angle(Gjw_B), 'LineWidth', 1.3); hold on;
semilogx(w, phaseZ*pi/180, '--', 'LineWidth', 1.3);
grid on;
title('Bode Phase: G(j\omega)B(j\omega) vs G(z)');
xlabel('\omega (rad/s)'); ylabel('Phase (rad)');
legend('G(j\omega)B(j\omega)', 'G(z)', 'Location', 'Best');


%% 5. Nichols comparison

% Build FRD model from frequency-response data of G(jw)B(jw)
Gjw_B_frd = frd(reshape(Gjw_B, 1, 1, []), w);   % 1 x 1 x N

figure;
nichols(Gjw_B_frd, 'b'); hold on;
nichols(Gz, 'r--');
grid on;
title('Nichols Plot: G(j\omega)B(j\omega) vs G(z)');
legend('G(j\omega)B(j\omega)', 'G(z)', 'Location', 'Best');
