clear all; close all; clc;

%% Linear Regression Method (2 data points)
fprintf('--- Linear Regression Method ---\n');

k = 0:9;
s = [0 0.52 0.9 1.2 1.4 1.55 1.67 1.73 1.82 1.86];
e = [0 1 1 1 1 1 1 1 1 1];

% Identification with 2 data points (k = 3 and 4)
F = [s(2)   1;
     s(3)   1];

S = [s(3);
     s(4)];

theta = F \ S;

a_2pt  =- theta(1);
b0_2pt = theta(2);

fprintf('a_2pt  = %.4f\n', a_2pt);
fprintf('b0_2pt = %.4f\n', b0_2pt);

Gz_2pt = tf(b0_2pt, [1 a_2pt], 1, 'variable', 'z');

%% Least Squares Method
fprintf('\n--- Least Squares Method ---\n');

Ts = 1;    % sampling time

% same data
k = 0:9;
s = [0 0.52 0.9 1.2 1.4 1.55 1.67 1.73 1.82 1.86];
e = [0 1 1 1 1 1 1 1 1 1];

s_prev = s(1:end-1).';   % column: s(k-1)
e_prev = e(1:end-1).';   % column: e(k-1)
s_next = s(2:end).';     % column: s(k)  (this is Y)

% LS formula: theta_LS = (Phi' * Phi)^(-1) * Phi' * Y
Phi      = [s_prev  e_prev];
theta_LS = (Phi' * Phi) \ (Phi' * s_next);

a_LS  = -theta_LS(1);
b0_LS = theta_LS(2);

fprintf('a_LS  = %.4f\n', a_LS);
fprintf('b0_LS = %.4f\n', b0_LS);

Gz_LS = tf(b0_LS, [1 a_LS], Ts )
