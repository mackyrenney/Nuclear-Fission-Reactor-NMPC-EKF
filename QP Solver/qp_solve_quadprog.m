function [U, exitflag, iters, tsolve] = qp_solve_quadprog(H, g, A, lbA, ubA, lb, ub, U0, qp_alg)
