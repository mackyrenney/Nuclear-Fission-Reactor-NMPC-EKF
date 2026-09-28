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
% Process variables
kappa = 0.000005    (delayed neutron fraction)
lambda = 3          (precursor decay constant)
Lambda = 0.000005   (product temperature)
Beta = 0.0065       (circulating temperature)
H = 0.05            (heating coefficient)
```

**Model Piping and Instrumentation Diagram**
---

**Discretization**
---

