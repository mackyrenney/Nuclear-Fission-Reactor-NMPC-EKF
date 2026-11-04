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
