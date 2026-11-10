function qp = nmpc_build_qp(x0, theta, Ubar, r, u_prev, mpc)


nx = size(mpc.Co, 2);
nz = size(mpc.Co, 1);
nu = numel(u_prev);
NU = numel(Ubar);
N  = NU/nu;
par = mpc.par;
