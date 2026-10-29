% vector fields for input affine reactor model
%
% CONTINUOUS TIME
% xdot = phi(x;theta) + psi(x;theta)*u
% phi analgous to F(x) drift
% psi analgous to G(x) input
%
% DISCRETE TIME (Explicit EULER)
% x_{t+1} = phid(x_t;theta) + psid(x_t;theta)*u_t
% phid = x + dt*phi   (analogous to f(x))
% psid = dt*psi       (analogous to g(x))
%
% state x = [Cn; Cp; rho_th]
% paramater theta = kappa/kappa0 (dimensionless thermal-feedback factor)
% input u = rho_ext
% parameter fields: kappa0, lambda, Lambda, beta, Hth, dt
%
function [phid, psid, phi, psi] = reactor_fields(x, theta, par)

Cn = x(1);
Cp = x(2);
rth = x(3);
kappa = par.kappa0*theta(1); 

lam  = par.lambda;
Lam  = par.Lambda;
beta = par.beta;
Hth  = par.Hth;
dt   = par.dt;

phi = [(rth - beta)/Lam*Cn + lam*Cp ; beta/Lam*Cn - lam*Cp ; -kappa*Hth*Cn];
psi = [Cn/Lam;   0; 0];
phid = x + dt*phi;
psid = dt*psi;
end
