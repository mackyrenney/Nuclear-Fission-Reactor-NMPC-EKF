**Nuclear Fission Reactor: Multivariable Control Design and State Estimation**
---
Nuclear Fission Reactor implementation and design of nonlinear optimal model predictive controller (NMPC) and Extended Kalman Filter (EKF) for state estimation was built in MATLAB/Simulink.
  * Semi-linearization Approach to NMPC
  * State Estimation using EKF

**Usage**
---
This implementation uses MATLAB's Control System ToolBox, ran using MATLAB_R2025b and Simulink

**Process Model**
---
The continuous-time model equations are given by:

$$
\begin{aligned}
\dot{C}_n(t) &= \frac{\rho(t) - \beta}{\Lambda} C_n(t) + \lambda C_p(t) \\
\dot{C}_p(t) &= \frac{\beta}{\Lambda} C_n(t) - \lambda C_p(t) \\
\dot{\rho}_{th}(t) &= -\kappa H C_n(t)
\end{aligned}
$$

Where $C_n$ is the concentration of neutrons, $C_p$ is the concentration of neutron precursors (neutron emitting fission product), and $\rho_{th}$ is the thermal reactivity incorporated via the equation $$\rho(t) = \rho_{th}(t) + \rho_{ext}(t)$$. 


``` matlab
% Parameter variables
par.kappa0 = 5e-5;         % thermal feedback coefficient
par.lambda = 3;            % precursor decay constant   [1/s]
par.Lambda = 5e-5;         % neutron generation time    [s]
par.beta   = 0.0065;       % delayed neutron fraction   [-]
par.Hth    = 0.05;         % heating coefficient        
par.dt     = 1e-3;         % Euler step = sample time   [s]
dt         = par.dt;
```

The fission differential equations are then represented as a control-affine system:

$$\dot{x}(t) = \varphi(x(t); \theta) + \psi(x(t); \theta)\, u(t)$$

where $\varphi(x(t); \theta)$ defines the state dynamics of the system wrt model parameters and $\psi(x(t); \theta)$ maps the controlled output dynamics wrt model parameters.

$$
x(t) = \begin{bmatrix} C_n(t) \\ 
C_p(t) \\ 
\rho_{th}(t) 
\end{bmatrix} \\ \qquad u(t) = \rho_{ext}(t)
\\ \qquad
\varphi(x(t);\theta) = \begin{bmatrix}
\frac{\rho_{th}(t) - \beta}{\Lambda} C_n(t) + \lambda C_p(t) \\
\frac{\beta}{\Lambda} C_n(t) - \lambda C_p(t) \\
-\kappa H C_n(t)
\end{bmatrix}
\\ \qquad
\psi(x(t);\theta) = \begin{bmatrix}
\frac{1}{\Lambda} C_n(t) \\
0 \\
0
\end{bmatrix}
$$


**Model Piping and Instrumentation Diagram**
---

**Discretization**
---
The model differential equations are discretized via Euler's explicit method. 

$$x_{t+1}=\underbrace{x_t+\Delta t\ \varphi(x_t;\theta)}_{\varphi_d}+\underbrace{\Delta t\ \psi(x_t;\theta)}_{\psi_d}\ u_t$$

To the accommodate model's "stiffness", the time step (dt) must be small enough to be within the stable limit. Therefore, the largest adequate Euler time step must satisfy a stable eigenvalue, $|1 + \Delta t\,\lambda_i| < 1$, within the stable limit, $\Delta t < -2\\mathrm{Re}\\lambda_i / |\lambda_i|^2$, without oscillations or blowups. For real eigenvalues this reduces to $\Delta t < 2/|\lambda_i|$ (i.e. the step must be shorter than twice the fastest time constant).


**Extended Kalman Filter**
---

**Nonlinear Model Predictive Controller**
---


