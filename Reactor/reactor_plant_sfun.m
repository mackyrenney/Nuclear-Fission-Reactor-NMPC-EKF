%   Discrete-time process (Euler step plant.dt):
%       x_{t+1} = x_t + dt*phi(x_t) + dt*psi(x_t)*u_t + G*w_t,  w_t ~ N(0,I3)
%
%   S-function block settings:
%       S-function name       : reactor_plant_sfun
%       S-function parameters : x0_true, plant
%
%   Input  (one in-port):  [ u_t ; w_t(3) ]
%   Output (one out-port):  x_t = [Cn; Cp; rho_th]
% 
%   Generla Loop Idea
%   plant -> sensor -> EKF -> NMPC -> plant


function [sys,x0,str,ts] = reactor_plant_sfun(t,x,u,flag,x0_true,plant)

switch flag
    case 0
        [sys,x0,str,ts] = mdlInitializeSizes(x0_true, plant);
    case 2
        sys = mdlUpdate(t,x,u,plant);
    case 3
        sys = mdlOutputs(t,x,u);
    case {1,4,9}
        sys = [];
    otherwise
        error(['Unhandled flag = ', num2str(flag)]);
end
end


function [sys,x0,str,ts] = mdlInitializeSizes(x0_true, plant)
sizes = simsizes;
sizes.NumContStates  = 0;   % the plant is already discrete (Euler)
sizes.NumDiscStates  = 3;   % Cn, Cp, rho_th
sizes.NumOutputs     = 3;   % Cn, Cp, rho_th (true states)
sizes.NumInputs      = 4;   % u = rho_ext, w1, w2, w3
sizes.DirFeedthrough = 0;  
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);
x0  = x0_true(:);           % initial true state from the block parameter
str = [];
ts  = [plant.dt 0];         % discrete sample time dt, offset 0
end


function sys = mdlUpdate(~,x,u,plant)
kappa  = plant.kappa;
lam    = plant.lambda;
Lam    = plant.Lambda;
beta   = plant.beta;
Hth    = plant.Hth;
dt     = plant.dt;
G      = plant.G;           

% controller design inputs
rho_ext = u(1);             % manipulated input u_t
w       = u(2:4);           % gaussian process noise

% controlled states
Cn  = x(1);
Cp  = x(2);
rth = x(3);

% continuous-time vector fields  phi(x) + psi(x)*u
dCn  = (rth - beta)/Lam*Cn + lam*Cp + Cn/Lam*rho_ext;
dCp  =  beta/Lam*Cn        - lam*Cp;
drth = -kappa*Hth*Cn;

% explicit eurler step including process noise
sys = x(:) + dt*[dCn; dCp; drth] + G*w(:);
end

function sys = mdlOutputs(~,x,~)
%  true state x_t (measurement noise is added in the Sensor block)
sys = x(:);
end
