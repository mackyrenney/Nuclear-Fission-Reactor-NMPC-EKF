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
