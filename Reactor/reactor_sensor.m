% Sensor Measurements
% x true state x_t 
% u_held : input held by the actuator at the sampling instant (u_{t|t-1})
% v measurement noise vector (v_t ~ N(0,I)
% C, D, F measurement matrices

function y = sensor_output(x, u_held, v, C, D, F)
  y = C*x(:) + D*u_held + F*v(:);
end
