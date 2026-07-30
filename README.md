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

```matlab
% Nominal Process Variables
% Inputs
F1   = 10; % kg/min    (feed flowrate)
F2   = 2; % kg/min     (product flowrate)
F3   = 50; % kg/min    (circulating flowrate)
X1   = 5;% percent     (inlet composition)
F200 = 208; % kg/min   (cooling water flowrate)
T1   = 40; % C         (feed temperature)
T200 = 25; % C         (cooling water inlet temp.)
P100 = 194.7; % kPa    (steam pressure)

% States
L2 = 1; % m            (separator level)
X2 = 25; % percent     (product composition)
P2 = 50.5; % kPa       (operating pressure)

% Constant Parameters
rhoA = 20; % kg/m              (separator hold-up)
M = 20; % kg                   (evaporator liquid hold-up)
Cpar = 4; % kg/kPa             (constant for vapor mass to pressure conversion)
Cp = 0.07; % kW/K(kg/min)      (heat capacity of process liquid)
lambda   = 38.5; % kW/(kg/min) (latent heat of evaporation of process liquid)
UA2 = 6.84; % kW/K             (condenser overall heat transfer coefficient)
lambda_s = 36.6; % kW/(kg/min) (latent heat of steam)

```
