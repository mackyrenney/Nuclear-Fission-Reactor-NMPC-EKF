%% reactor_init.m
% simulink set-up: Joint NMPC + EKF control of the nuclear fission reactor
%
% run this script to initialize the simulink model (reactor_nmpc_ekf.slx)
%
% This script creates workspace variables for the model including:
%      plant, x0_true         --> Reactor S-function and Sensor
%      ekf, xbar0, Pbar0      --> EKF blocks and unit delay signals
%      
%



%% User settings
cfg.Tend = 1.0; # simulation in length (seconds)
cfg.loop_mode = 1; 
cfg.proc_noise = 1;
cfg.meas_noise = 1;
cfg.seed = 42;
cfg.r_ref = 1e4;
cfg.r_final = 1e4;
cfg.t_step = 0.5;



%% Physical and time parameters
par.kappa0 = 5e-5;
par.lambda = 3;
par.Lambda = 5e-5;
par.beta = 0.0065;
par.Hth = 0.05;
par.dt = 1e-3;
dt = par.dt;


nx = 3;                     % x = [Cn; Cp; rho_th]
nu = 1;                     % u = rho_ext
ny = 2;                     % y = [Cn; Cp] measured outputs
nz = 1;                     % z = Cn controlled ouput 
ntheta = 1;

%% Stochastic state space model
Rv = diag([1, 1, 1e-8]);    % process noise covariance
Re = diag([0.1, 0.1]);      % measurement noise covariance

G = chol(Rv, 'lower');
F = chol(Re, 'lower');
C = [1 0 0;
    0 1 0];

D = zeros(ny, nu);
M = zeros(ny, ntheta);
Co = [1 0 0];

theta0 = 1;                % nominal parameter (kappa = kappa0)
if cfg.est_theta
    H       = 1e-4;        % random-walk std of theta per step
    P0thth  = 0.3^2;       % prior uncertainty of theta (30 %)
else
    H       = zeros(ntheta);   % frozen parameter: H = 0, P_thth = 0
    P0thth  = zeros(ntheta);   % plain 3-state EKF
end


%% Discritization (explicit Euler)

x0_true = [1000; 0; par.beta];
x_ss = [cfg.r_ref; par.beta/(par.Lambda*par.lambda)*cfg.r_ref; 0];

%% S-function and Sensor
plant.kappa = par.kappa0;
plant.lambda = par.lambda;
plant.Lambda = par.Lambda;
plant.Hth = par.Hth;
plant.beta = par.beta;
plant.dt = par.dt;
plant.G = G;
plant.C = C;
plant.D = D;
plant.F = F;

%% EKF (joint state  and parameter estimation)
ekf.par    = par;          % model parameters (theta scales kappa0)
ekf.C      = C;
ekf.D      = D;
ekf.F      = F;
ekf.M      = M;
ekf.G      = G;
ekf.H      = H;
ekf.joseph = 0;            % 1 = Joseph-form covariance update

switch cfg.est_case
    case 1   % true initial state, small prior covariance
        x0_est = x0_true;
        P0xx   = diag([1, 1, 1e-8]);
    otherwise   % wrong initial state, prior covariance that covers the error
        x0_est = [800; 200; 0];
        P0xx   = diag([200^2, 200^2, (2*par.beta)^2]);
end
xbar0 = [x0_est; theta0];                      % Unit Delay for xbar_{0|-1}
Pbar0 = blkdiag(P0xx, P0thth);                 % Unit Delay for P_{0|-1}
nxbar = nx + ntheta;

%% Simulation data
Tend = cfg.Tend;
Nsim = round(Tend/dt);
t_vec = (0:Nsim)'*dt;

rng(cfg.seed);                                   % reproducible noise
W = cfg.proc_noise*randn(nx, Nsim+1);            % w_t ~ N(0, I3)
V = cfg.meas_noise*randn(ny, Nsim+1);            % v_t ~ N(0, I2)
