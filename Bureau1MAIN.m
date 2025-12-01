close all; clc; clear;
%% ZOH Approximation
%% 1. Continuous Plant Gp and Sampled Plant Gz
Ts = 0.01;
s=tf('s');
Gp = 2/(1+0.1*s);
Gz=c2d(Gp, Ts, 'zoh');

figure;
bode(Gp);
hold on;
bode(Gz);
title('Comparison between G(p) and G(z)');
legend('Gp','Gz', 'Location','best');

%% 2. ZOH Transfer Function
Bzoh = (1-exp(-Ts*s))/s;

%% 3. Frequency-domain representation B(j\omega)
w = linspace(1, 2000, 400)';    

Bjw = (1 - exp(-1j*w*Ts)) ./ (1j*w*Ts);  
magB_db = 20*log10(abs(Bjw));
phaseB  = angle(Bjw);           

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
Gjw_array = freqresp(Gp, w);  
Gjw       = squeeze(Gjw_array);
Gjw_B = Gjw .* Bjw;            

[magZ, phaseZ] = bode(Gz, w);  
magZ   = squeeze(magZ);         
phaseZ = squeeze(phaseZ);       

% ---- BODE COMPARISON ----
figure;
% --- Magnitude ---
subplot(2,1,1);
semilogx(w, 20*log10(abs(Gjw_B)), 'b', 'LineWidth',1.2); 
hold on;
semilogx(w, 20*log10(magZ), 'r--', 'LineWidth',1.2);
grid on;
title('Bode Magnitude');
legend('G(j\omega)B(j\omega)','G(z)');
xlabel('\omega (rad/s)'); ylabel('dB');

% --- Phase ---
subplot(2,1,2);
semilogx(w, angle(Gjw_B), 'b', 'LineWidth',1.2); 
hold on;
semilogx(w, phaseZ*pi/180, 'r--', 'LineWidth',1.2);
grid on;
title('Bode Phase');
legend('G(j\omega)B(j\omega)','G(z)');
xlabel('\omega (rad/s)'); ylabel('rad');

% ---- Nichols COMPARISON ----
Gjw_B_frd = frd(reshape(Gjw_B, 1, 1, []), w);   % 1 x 1 x N

figure;
nichols(Gjw_B_frd, 'b'); hold on;
nichols(Gz, 'r--');
grid on;
title('Nichols Plot: G(j\omega)B(j\omega) vs G(z)');
legend('G(j\omega)B(j\omega)', 'G(z)', 'Location', 'Best');
