% script: simulate_effect_of_the_inertia_moment_of_wheel
% goal: Shows the effect of the inertia moment of wheel, J2
% const parameter = Vm = 20 !
% used Simulink file: 'pendulum_iwp_cube_v2'
%
% last edit 22.10.2021  (TL RT-Lab)

clear;
% clf(1); 
% clf(2);  % can uncommanded after first run

J1 = 0.0010;    % Inertia moment pendulum complete
J2 = 0.00001;  % Inertia moment wheel - 0.0005711
m1 = 0.52;      % Mass of pendulum + stator
m2 = 0.195;      % Mass of wheel + rotor
c1 = 0.004;       % Friction factor of pendulum
c2 = 0.0007;     % Friction factor of wheel
% l1 = 0.135;        % length from orig to COG of pendulum
l2 = 0.12;      % length from orig to COG of wheel
Kb = 0.0987;     % Back-emf constant
Kt = 0.0987;     % Motor torque constant
% Ra = 1.556;      % Motor armature winding resistance
Ra = 32.6;
l1 = l2 *0.85;
g  = 9.81;

% helpfull variables
a = m1*l1^2 + m1*l2^2 + J1 + J2;
b = m1*l1 + m2*l2;

% init variables
theta_0 = 14.94*pi/180 + pi;   % init angle
dcm_on = 0;     % start time dcm voltage
Vm = 12;        % const parameter


% sim("pendulum_rwp_v2")
% xtime1 = simout_u4.time;             % get time vector
% u1a = simout_u1.signals.values(:);   % get angle
% u4a = simout_u4.signals.values(:);   % get wheel velocity
% load('encVal.mat')
% figure(1)   % --- phi / pendulum angle [degree] ---
% plot(xtime1,u1a,'LineWidth',1.0)  % plot phi #1
% grid on; hold on
% plot(t-3.6, pendulumAngle_deg+180);
% % plot(xtime2,u1b,'LineWidth',1.0)      % plot phi #2
% % plot(xtime3,u1c,'m','LineWidth',1.0)  % plot phi #3
% axis([0 10 160 200])                   % set (better) range
% xlabel('Time (s)');
% legend('Simulation','Experiment');
% title('Pendulum angle - $\theta$ [deg]','Interpreter','Latex');