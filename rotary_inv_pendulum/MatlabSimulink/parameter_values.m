% script: parameter_values
% goal: Balance a rotary inverted pendulum
% const parameter = Vm = 12 !
% used Simulink file: 'LinearModelWithObserver' & 'NonLinearModelWithObserver'
%
% last edit 08.08.2022  (TL RT-Lab)
% clc
% clear
% clf(1);    % can uncommanded after first run
% clf(2);  % can uncommanded after first run

J1 = 0.0013;    % Inertia moment pendulum complete
J2 = 0.0001;  % Inertia moment wheel - 0.0005711
m1 = 0.52;      % Mass of pendulum + stator
m2 = 0.195;      % Mass of wheel + rotor
c1 = 0.004;       % Friction factor of pendulum
c2 = 0.0007;     % Friction factor of wheel
% l1 = 0.135;        % length from orig to COG of pendulum
l2 = 0.12;      % length from orig to COG of wheel

Kb = 0.0987;     % Back-emf constant
Kt = 0.0987;     % Motor torque constant
Ra = 1.556;      % Motor armature winding resistance
l1 = l2 *0.85;
g  = 9.81;

% helpful variables
a = m1*l1^2 + m1*l2^2 + J1 + J2;
b = m1*l1 + m2*l2;
p = [-50 -50 -10 -2];                   % wanted pole

% init variables
theta_0 = 2*pi/180 ;   % initial angle
dcm_on = 0;     % start time dcm voltage
Vm = 12;        % const parameter

% initial condition

x0 = [deg2rad(0.1); 0; 0; 0];

%%
% Insert calculated state space model from "StateSpaceModel.mlx"
load iwp_utilities.mat
%A = [0 1 0 0; (b*g)/(a-J2) -c1/(a-J2) 0 c2/(a-J2); 0 0 0 1; -(b*g)/(a-J2) c1/(a-J2) 0 (a*c2)/(J2*(a-J2))];
A = A_lin;
%B = [0; 1/(a-J2); 0; a/(J2*(a-J2))];
B = B_lin;
C1 = [1 0 0 0];
C2 = [0 0 0 1];
D = 0;
%%
% LQR
Q = [1 0 0 0; 0 1 0 0; 0 0 10 0; 0 0 0 1];
R = 1;
K = lqr(A,B,Q,R);
%%
% Calculations for model with observer
C_obs = [1 0 0 0; 0 0 1 0];
x_hat_0 = [0 0 0 0];
K_lmi = calc_LMI_Controller(A,B,3);
L = calc_LMI_Observer(A,C_obs,10);
%%
sys = ss((A-B*K), B, C1, D);
sys_lmi = ss((A-B*K_lmi), B, C1, D);
% t = 0:0.1:10;
% [y, t, x] = initial (sys, x0, t);

%%
% Check for controllability 
Co = ctrb(sys);
unco = length(A) - rank(Co); % if 0 then controllable
% Check for observability
Ob = obsv(sys);
unob= length(A) - rank(Ob); % if 0 then observable
%%
% Simulated output
sim("ModelWithObserver")

xtime1 = theta_sim.time;             % get time vector
u1a = theta_sim.signals.values(:);   % get angle
figure(1)
plot(xtime1,u1a,'LineWidth',1.0)
grid on; hold on
xlabel('Time (s)');
axis([0 10 -2 2])
title('Simulated Pendulum angle - $\theta$ [deg]','Interpreter','Latex');

%%

% xtime2 = theta_real.time;             % get time vector
% u2a = theta_real.signals.values(:) * 180 / pi;   % get angle
% % u2a = abs(u2a);
% n = length(u2a);
% for i = 1:n
%     if (u2a(i)<-25)
%         u2a(i) = u2a(i) + 360;
%     end
% end
% figure(1)
% plot(xtime2,u2a,'LineWidth',1.0)
% grid on; hold on
% xlabel('Time (s)');
% % axis([0 10 -2 2])
% title('Real Pendulum angle - $\theta$ [deg]','Interpreter','Latex');