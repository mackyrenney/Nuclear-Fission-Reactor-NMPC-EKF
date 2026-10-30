% Deterministic one-step prediction of the discrete model
%
% x_{t+1} = phid(x_t;theta) + psid(x_t;theta)*u_t
%
% This is the noise-free part
% f(xbar,u,wbar) = [ phid + psid*u + G*w ; theta + H*eta ]
% This is used for the EKF time update (mean prediction) and the NMPC (nominal trajectory for the semilinearization)

function xnext = reactor_step(x, u, theta, par)

[phid, psid] = reactor_fields(x, theta, par);
xnext = phid + psid*u;
end
