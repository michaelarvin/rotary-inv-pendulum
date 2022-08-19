function c = Constants()
c.J1 = 0.0013;    % Inertia moment pendulum complete
c.J2 = 0.0001;  % Inertia moment wheel - 0.0005711
c.m1 = 0.52;      % Mass of pendulum + stator
c.m2 = 0.195;      % Mass of wheel + rotor
c.c1 = 0.004;       % Friction factor of pendulum
c.c2 = 0.0007;     % Friction factor of wheel     
c.l2 = 0.12;      % length from orig to COG of wheel
c.Kb = 0.0987;     % Back-emf constant
c.Kt = 0.0987;     % Motor torque constant
c.Ra = 1.556;      % Motor armature winding resistance
c.l1 = c.l2 *0.85; % length from orig to COG of pendulum
c.g  = 9.81;

% helpfull variables
c.a = c.m1*c.l1^2 + c.m1*c.l2^2 + c.J1 + c.J2;
c.b = c.m1*c.l1 + c.m2*c.l2;
end

