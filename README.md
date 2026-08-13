**Nuclear Fission Reactor: Multivariable Control Design and State Estimation**
---
Nuclear Fission Reactor implementation and design of nonlinear optimal controller and Extended Kalman Filter (EKF) for state estimation was built in MATLAB/Simulink.
  * Semi-linearization Approach to NMPC
  * State Estimation using EKF

**Usage**
---
This implementation uses MATLAB's Control System ToolBox, ran using MATLAB_R2025b and Simulink

**Process Model**
---

**Model Piping and Instrumentation Diagram**
---
'''

Consider a model of a nuclear fission reactor given by:

\begin{subequations}
\begin{align}
\dot{C}_n(t) &= \frac{\rho(t) - \beta}{\Lambda} C_n(t) + \lambda C_p(t), \\
\dot{C}_p(t) &= \frac{\beta}{\Lambda} C_n(t) - \lambda C_p(t), \\
\dot{\rho}_{th}(t) &= -\kappa H C_n(t),
\end{align}
\end{subequations}

Where $C_n$ is the concentration of neutrons, $C_p$ is the concentration of so-called neutron precursors (essentially, fission products that emit neutrons at a relatively slow rate), and $\rho_{th}$ is the thermal reactivity. The reactivity given by.
