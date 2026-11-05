% semi-linearization


nx = size(mpc.Co, 2);
nu = numel(u_prev);
NU = numel(U_prev);
nbar = numel(xbar_hat);

x0 = xbar_hat(1:nx);
if mpc.use_theta > 0
    theta = xbar_hat(nx+1:nbar);
else
    theta = mpc.theta0;
end

Ubar = [U_prev(nu+1:NU); U_prev(NU-nu+1:NU)];
[Jbar, ~] = nl_cost(x0, theta, Ubar, r, u_prev, mpc);

for it = 1:mpc.n_sl
    qp = nmpc_build_qp(x0, theta, Ubar, r, u_prev, mpc);

    [Ut, flag, nit, tsol] = qp_solve(qp.H, qp.g, qp.A, qp.lbA, qp.ubA, ...
                                     qp.lb, qp.ub, Ubar/qp.su, ...
                                     mpc.solver, mpc.qp_alg);
    exitflag = flag;
    qp_iters = qp_iters + nit;
    qp_time  = qp_time  + tsol;
    sl_iters = it;

    if flag <= 0
        break;                          % QP failed: keep the current plan
    end

    Ustar = qp.su*Ut;                   % unscale
    dUfull = Ustar - Ubar;
    dU     = max(abs(dUfull));


function [J, Z] = nl_cost(x0, theta, U, r, u_prev, mpc)
nz = size(mpc.Co, 1);
nu = numel(u_prev);
N  = numel(U)/nu;
Z  = zeros(N*nz, 1);
xk = x0;
uk_prev = u_prev;
Rz = r(:);
J  = 0;
for k = 1:N
    uk = U((k-1)*nu + (1:nu));
    xk = reactor_step(xk, uk, theta, mpc.par);
    zk = mpc.Co*xk;
    Z((k-1)*nz + (1:nz)) = zk;
    du = uk - uk_prev;
    J  = J + 0.5*((zk - Rz)'*mpc.Qz*(zk - Rz)) + 0.5*(uk'*mpc.Ru*uk) ...
           + 0.5*(du'*mpc.Sdu*du);
    uk_prev = uk;
end
if ~isfinite(J)
    J = Inf;
end
end
