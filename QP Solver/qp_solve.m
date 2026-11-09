function [U, exitflag, iters, tsolve] = qp_solve(H, g, A, lbA, ubA, lb, ub, U0, solver, qp_alg)

coder.extrinsic('qp_solve_quadprog');
n = numel(g);

% pre-declare outputs (required for extrinsic calls in MATLAB Function blocks)
U        = zeros(n, 1);
exitflag = 0;
iters    = 0;
tsolve   = 0;

switch solver
    case 0
        [U, exitflag] = qp_solve_unconstrained(H, g, U0);
        iters = 1;

    case 1
    [U, exitflag, iters, tsolve] = qp_solve_quadprog(H, g, A, lbA, ubA, lb, ub, U0, qp_alg);


    case 2
    % Hook for the custom optimization kernel

        U        = U0;
        exitflag = -99;
        
    otherwise
        U        = U0;
        exitflag = -98;
end
end

