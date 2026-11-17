% Jacobians for the discrete reactor model
%      f(x,u;theta) = phid(x;theta) + psid(x;theta)*u
%      A   = df/dx  = I + dt*(dphi/dx + sum_i dpsi/dx_i * u)
%      B   = df/du  = psid(x;theta) = dt*psi(x)
%      S   = df/dtheta  = dt*(dphi/dtheta + dpsi/dtheta*u)
%      Asl = dphid/dx   = I + dt*dphi/dx
%
%
function [A,B,S,Asl] = reactor_jacobians(x, u, theta, par)

Cn = x(1);
rth = x(3);
kappa = par.kappa0*theta(1);

lam = par.lamda;
Lam = par.Lamda;
beta = par.beta;
Hth = par.Hth;
dt = par.dt;

dphidx = [ (rth - beta)/Lam, lam, Cn/Lam; beta/Lam, -lam, 0; -kappa*Hth, 0, 0];
dpsidx_u = [u/Lam, 0, 0; 0, 0, 0; 0, 0, 0];
Asl = eye(3) + dt*dphidx;
A = Asl + dt*dpsidx_u;
B = dt*{Cn/Lam; 0; 0];
S = dt*[0;0; -par.kappa0*Hth*Cn];
