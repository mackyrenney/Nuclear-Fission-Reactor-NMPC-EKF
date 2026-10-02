**Nuclear Fission Reactor: Multivariable Control Design and State Estimation**
---
Nuclear Fission Reactor implementation and design of nonlinear model predictive controller (NMPC) and Extended Kalman Filter (EKF) for state estimation was built in MATLAB/Simulink.
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

$$\dot{x}(t) = \varphi(x(t); \theta) + \psi(x(t); \theta)\ u(t)$$

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

$C_n(t)$ is presented as an actuated state, where the neutron population state dynamics are balanced (1) Neutron Net Rate: thermal feedback ($p_{th}$) and delayed neutron precursors $\beta$, then scaled by the neutron generation time ($\Lambda$); (2) Delayed neutron source: nuetron release of radioactive decaying precursor via decay constant $\lambda$. $C_n(t)$ rate of change is produced by external control reactivity ($u(t)=\rho_{ext}$) and scaled by the current $\frac{C_n(t)}{\Lambda}$.

$C_p(t)$ is a drift only state where there is no explicit control coupling. The $C_p(t)$ state captures precursor isotope generation via fission $\frac{\beta}{\Lambda} C_n(t)$ and loss via radioactive decay scaled by $-\lambda$.

$\rho_{th}(t)$ is also a drift only state where there is no explicit control coupling. The $\rho_{th}(t)$ state dynamics defines heat output driving thermal feedback through negative temperature coefficient ($-\kappa$). For this simple control design, moving control rods $u(t)$ only indirectly affects thermal reactivity. Adding alternative mechanisms that control core temperature, i.e. cooling water, has not been included in this design.

**Model Piping and Instrumentation Diagram**
---

**Discretization**
---
The model differential equations are discretized via Euler's explicit method. 

$$x_{t+1}=\underbrace{x_t+\Delta t\ \varphi(x_t;\theta)}_{\varphi_d}+\underbrace{\Delta t\ \psi(x_t;\theta)}_{\psi_d}\ u_t + G w_t$$

To accommodate the model's "stiffness", the time step (dt) must be small enough to be within the stable limit. Therefore, the largest adequate Euler time step must satisfy a stable eigenvalue, $|1 + \Delta t\,\lambda_i| < 1$, within the stable limit, $\Delta t < -2\\mathrm{Re}\\lambda_i / |\lambda_i|^2$, without oscillations or blowups. For real eigenvalues this reduces to $\Delta t < 2/|\lambda_i|$ (i.e. the step must be shorter than twice the fastest time constant).


**Extended Kalman Filter**
---


**Nonlinear Model Predictive Controller**
---


**Reactor: Simulink Design**
---
<img width="2954" height="632" alt="Screenshot 2026-10-02 at 7 17 48 PM" src="https://github.com/user-attachments/assets/fe01428d-1e77-4e53-b817-8426330a6cf2" />

