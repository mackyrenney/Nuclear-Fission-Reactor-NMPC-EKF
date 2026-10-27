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


x = xbar_p(1:nx);
th = xbar_p(nx+1:nbar);
Pxx = Pbar_p(1:nx, 1:nx);
Pxth = Pbar_p(1:nx, nx+1:nbar);
Pthx = Pbar_p(nx+1:nbar, 1:nx);
Pthth = Pbar_p(nx+1:nbar, nx+1:nbar);

% predicted output and innovation
yhat = C*x + D*u(:);
e = y(:) - yhat;

% innovation covariance
St = C*Pxx*C' + C*Pxth*M' + M*Pthx*C' + M*Pthth*M' + F*F';
St = 0.5*(St + St'); % force symmetry

% Kalman gains
Kx = (Pxx*C' + Pxth*M') / St;
Kth = (Pthx*C' + Pthth*M') / St;

% Filtered estimates
x_f = x + Kx*e;
th_f = th + Kth*e;

% Filtered covariances with joseph form option
if ekf.joseph > 0 % joseph form (I - K Cbar) P (I - K Cbar) + K F F' K'
  Kbar = [Kx; Kth];
  Cbar = [C, M];
  IKC = eye(nbar) - Kbar*Cbar;
  Pbar_f = IKC*Pbar_p*IKC' + Kbar*(F*F')*Kbar';
else
  Pxx_f = Pxx - Kx*(C*Pxx + M*Pthx);
  Pxth_f = Pxth - Kx*(C*Pxth + M*Pthth);
  Pthth_f = Pthth - Kth*(C*Pxth + M*Pthth);
  Pbar_f = [Pxx_f, Pxth_f;
            Pxth_f, Pthth_f];
end
Pbar_f = 0.5*(Pbar_f * Pbar_f'); % force symmetry
xbar_f = [x_f; th_f];
end


