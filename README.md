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

The system is in the form:

\begin{equation}
\begin{aligned}
\dot{x}(t) &= F(x(t)) + G(x(t))u(t),
\end{aligned}
\end{equation}

where 

\[
x(t) = \begin{bmatrix}
C_n(t) \\
C_p(t) \\
\rho_{th}(t)
\end{bmatrix}, \qquad u(t) = \rho_{ext}(t)
\]
\[
F(x(t)) = \begin{bmatrix}
\frac{\rho_{th}(t) - \beta}{\Lambda} C_n(t) + \lambda C_p(t) \\
\frac{\beta}{\Lambda} C_n(t) - \lambda C_p(t) \\
-\kappa H C_n(t)
\end{bmatrix}, \qquad G(x(t)) = \begin{bmatrix}
\frac{1}{\Lambda} C_n(t) \\
0 \\
0
\end{bmatrix}
\]
