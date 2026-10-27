% EKF Step 2: Time Update (joint x/th)
%
% Inputs
% xbar_f = [xhat_{t|t}; thetahat_{t|t}]
% Pbar_f = P_{t|t}
% u      = u_t (control move from previous NMPC output) 
% ekf    = struct with A, B, S, G, H etc.
%
% Outputs
% xbar_f = [xhat_{t+1|t}; thetahat_{t+1|t}
% Pbar_f = P_{t+1|t}
%
% Equations
% x_{t+1|t}     = phid(x;theta) + psid(x;theta) u
% theta_{t+1|t} = theta
% Pxx = A Pxx A' + A Pxth S' + S Pthx A' + S Pthth S' + G G'
% Pxth = A Pxth + S Pthth
% Pthth = Pthth + H H'
%
% where S = jacobian of the state dynamics with respect the theta (df/dtheta) evaluated at (xhat_{t|t}, thetahat_{t|t}, u_t)
%
%
function [xbar_p, Pbar_p] = ekf_time_update(xbar_f, Pbar_f, u, ekf)

G = ekf.G;
H = ekf.H;
nx = size(G,1);
nbar = numel(xbar_f);

% augmentation
x = xbar_f(1:nx);
th = xbar_f(nx+1:nbar);
Pxx = Pbar_f(1:nx, 1:nx);
Pxth = Pbar_f(1:nx, nx+1;nbar);
Pthx = Pbar_f(nx+1:nbar, 1:nx);
Pthth = Pbar_f(nx+1:nbar, nx+1:nbar);

% Jacobians at the filtered estimate
[A, ~, S] = reactor_jacobians(x, u, th, ekf.par);

% state and parameter prediction
x_p = reactor_step(x, u, th, ekf.par);
th_p = th;

% covariance prediction
Pxx_p = A*Pxx*A' + A*Pxth*S' + S*Pthx*A' + S*Pthth*S' + G*G';
Pxth_p = A*Pxth + S*Pthth;
Pthth_p = Pthth + H*H';
Pbar_p = [Pxx_p, Pxth_p; Pxth_p', Pthth_p];
Pbar_p = 0.5*(Pbar_p + Pbar_p'); % force symmetry
xbar_p = [x_p; th_p];
end
