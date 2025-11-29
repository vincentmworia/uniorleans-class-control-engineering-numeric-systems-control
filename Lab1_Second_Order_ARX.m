clear;
clc;
% Linear Regression Method

k = 0:4;
s = [0, 0.2, 0.55, 0.77, 0.74];
e = [1, 0.8, 0.45, 0.23, 0.26];

s_next = s(2:end)';

s_prev_1 = s(1:end-1)';
e_prev_1 = e(1:end-1)';
s_prev_2 = [0, s(1:end-2)]';
e_prev_2 = [0, e(1:end-2)]';

phi = [s_prev_1 e_prev_1 s_prev_2 e_prev_2];

theta_regression = phi \ s_next;

a1_regression = -theta_regression(1);
a0_regression = -theta_regression(2);
b1_regression =  theta_regression(3);
b0_regression =  theta_regression(4);

fprintf('.........Linear Regression Values.................\n');
fprintf('a1: %.4f\n', a1_regression);
fprintf('a0: %.4f\n', a0_regression);
fprintf('b1: %.4f\n', b1_regression);
fprintf('b0: %.4f\n', b0_regression);

% Least Squares Method
theta_ls = (phi' * phi) \ (phi' * s_next);

a1_ls = -theta_ls(1);
a0_ls = -theta_ls(2);
b1_ls = theta_ls(3);
b0_ls = theta_ls(4);

fprintf('\n.........Least Squaure Values.................\n');
fprintf('a1: %.4f\n', a1_ls);
fprintf('a0: %.4f\n', a0_ls);
fprintf('b1: %.4f\n', b1_ls);
fprintf('b0: %.4f\n', b0_ls);