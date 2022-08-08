% script: simulate_effect_of_the_inertia_moment_of_wheel
% goal: Shows the effect of the inertia moment of wheel, J2
% const parameter = Vm = 20 !
% used Simulink file: 'pendulum_iwp_cube_v2'
%
% last edit 22.10.2021  (TL RT-Lab)

clear;
%clf(1); clf(2);  % can uncommanded after first run

J1 = 0.01186;    % Inertia moment pendulum complete
J2 = 0.0005711;  % Inertia moment wheel - 0.0005711
m1 = 0.826;      % Mass of pendulum + stator
m2 = 0.583;      % Mass of wheel + rotor
c1 = 0.04;       % Friction factor of pendulum
c2 = 0.0001;     % Friction factor of wheel
l1 = 0.1053;     % length from orig to COG of pendulum
l2 = 0.25;       % length from orig to COG of wheel
Kb = 0.0987;     % Back-emf constant
Kt = 0.0987;     % Motor torque constant
Ra = 1.556;      % Motor armature winding resistance

g  = 9.82;

% helpfull variables
a = m1*l1^2 + m1*l2^2 + J1 + J2;
b = m1*l1 + m2*l2;

% init variables
theta_0 = pi;   % init angle
dcm_on = 0;     % start time dcm voltage
Vm = 20;        % const parameter

% % sim #1
% J2 = 0.0005;                         % set para #1
% sim ('pendulum_rwp_v2')         % call simulation #1
% xtime1 = simout_u4.time;             % get time vector
% u1a = simout_u1.signals.values(:);   % get angle
% u4a = simout_u4.signals.values(:);   % get wheel velocity
% % sim #2
% J2 = 0.002;                          % set para #2
% sim ('pendulum_rwp_v2')         % call simulation #2
% xtime2 = simout_u4.time;             % get time vector
% u1b = simout_u1.signals.values(:);   % get angle
% u4b = simout_u4.signals.values(:);   % get wheel velocity
% % sim #3
% J2 = 0.005;                          % set para #3
% sim ('pendulum_rwp_v2')         % call simulation #3
% xtime3 = simout_u4.time;             % get time vector
% u1c = simout_u1.signals.values(:);   % get angle
% u4c = simout_u4.signals.values(:);   % get wheel velocity
% 
% figure(1)   % --- phi-dot / wheel velocity [rpm !] ---
% plot(xtime1,u4a,'LineWidth',1.0)  % plot phi_dot #1
% grid on; hold on
% plot(xtime2,u4b,'LineWidth',1.0)      % plot phi_dot #2
% plot(xtime3,u4c,'m','LineWidth',1.0)  % plot phi_dot #3
% axis([0 5 0 250])                     % set (better) range
% xlabel('Time (s)');
% legend('J_2 = 0.0005','J_2 = 0.002','J_2 = 0.005','Location','southeast');
% title('a) Wheel velocity - $\varphi$ [ras/s]','Interpreter','Latex');
% 
% figure(2)   % --- phi / pendulum angle [degree] ---
% plot(xtime1,u1a,'LineWidth',1.0)  % plot phi #1
% grid on; hold on
% plot(xtime2,u1b,'LineWidth',1.0)      % plot phi #2
% plot(xtime3,u1c,'m','LineWidth',1.0)  % plot phi #3
% axis([0 5 100 220])                   % set (better) range
% xlabel('Time (s)');
% legend('J_2 = 0.0005','J_2 = 0.002','J_2 = 0.005','Location','southeast');
% title('d) Pendulum angle - $\theta$ [deg]','Interpreter','Latex');
