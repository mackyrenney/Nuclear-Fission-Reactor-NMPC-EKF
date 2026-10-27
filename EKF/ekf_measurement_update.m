%% EKF Step 1: measurement update (joint x & theta)
% 
% Inputs
% xbar_p = [xhat_{t|t-1}; thetahat_{t|t-1}
% Pbar_p = [Pxx Pxth; Pthx Pthth]_{t|t-1}
% y      = y_t measurement
% u      = input for direct feedthrough (u_{t-1}
% ekf    = struct with C, D, F, M and Joseph cfg option
%
%
% Outputs
% xbar_f = [xhat_{t|t}; thetahat_{t|t}
% Pbar_f = filtered covariance
% yhat   = yhat_{t|t-1} = C xhat + D u
% e      = innovation y - yhat
% St     = innovation covariance (S_t)
%
%
% Equations
% yhat = C xhat + D u
% St = C Pxx C' + C Pxth M' + M Pthx C' + M Pthth M' + F F'
% Kx = (Pxx C' + Pxth M') St^-1
% Kth = (Pthx C' + Pthth M') St^-1
% x = x + Kx (y - yhat)
% th = th + Kth (y - yhat)
% Pxx = Pxx - Kx (C Pxx + M Pthx)
% Pxth = Pxth - Kx (C Pxth + M Pthth)
% Pthth = Pthth - Kth(C Pxth + M Pthth)
% 
% Joseph form is avaiable with ekf.joseph = 1 within reactor_init.m


function [xbar_p, Pbar_p, yhat, e, St] = ekf_measurement_update(xbar_p, Pbar_p, y, u, ekf)

C  = ekf.C;
D  = ekf.D;
F  = ekf.F;
M  = ekf.M;
nx   = size(C, 2);
nbar = numel(xbar_p);
