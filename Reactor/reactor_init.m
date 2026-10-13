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


nx = 3;
nu = 1;
ny = 2;
nz = 1;
ntheta = 1;

%% Stochastic State space model
Rv = diag([1, 1, 1e-8]);
Re = diag([0.1, 0.1]);

G = chol(Rv, 'lower');
F = chol(Re, 'lower');
C = [1 0 0;
    0 1 0];

D = zeros(ny, nu);
M = zeros(ny, ntheta);
Co = [1 0 0];
