vincent-mwenda.mworia@etu.univ-orleans.fr 

% Practice TP 1
clc; 
%% Exercise 1
% Linear Regression Method
k = 0:9;
s = [0 0.52 0.9 1.2 1.4 1.55 1.67 1.73 1.82 1.86];
e = [0,ones(1,9)];
phi = [
 s(2) e(2);
 s(3) e(3)];
fprintf('\n............Linear Regression..................\n')
theta_lreg = phi \ [s(3) ; s(4)];
a_reg = -theta_lreg(1);
b_reg = theta_lreg(2);
fprintf('a: %.4f\n',a_reg);
fprintf('b: %.4f\n',b_reg);
fprintf('\n............Least Squares..................\n')
s_next = s(2:end)';
s_prev = s(1:end-1);
e_prev = e(1:end-1);
phi_ls = [s_prev' e_prev'];
theta_ls = (phi_ls' * phi_ls) \ (phi_ls' * s_next);
a_ls = -theta_ls(1);
b_ls =theta_ls(2);
fprintf('a: %.4f\n',a_ls);
fprintf('b: %.4f\n',b_ls);
Gp = tf(b_ls, [1 a_ls]) ;

%Compute sampling time
tau = 1/abs(a_ls); % Time constant
Ts = tau/10; % Sampling time = 10x faster than pole time constant

Gz = c2d(Gp,Ts,'zoh') ;