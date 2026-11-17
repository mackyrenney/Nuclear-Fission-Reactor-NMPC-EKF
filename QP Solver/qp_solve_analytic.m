function [U, exitflag] = qp_solve_unconstrained(H, g, U0)
H = 0.5*(H + H');
U = -(H \ g);

if all(isfinite(U))
    exitflag = 1;
else
    U = U0;
    exitflag = -2;
end
end
