% semi-linearization

function [u, U, Zpred, info] = nmpc_semilinear(xbar_hat, r, u_prev, U_prev, mpc)
nx = size(mpc.Co, 2);
nu = numel(u_prev);
NU = numel(U_prev);
nbar = numel(xbar_hat);

