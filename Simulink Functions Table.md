# Simulink Functions Table

<table>
  <thead>
    <tr>
      <th>Simulink Block</th>
      <th>MATLAB Code</th>
      <th>Function Type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>Sensor</strong></td>
      <td>
        <pre style="white-space: pre-wrap; word-break: break-word;"><code>function y = Sensor(x, u_prev, v, plant)
   % y_t = C x_t + D u_{t-1} + F v_t   (where D = 0)
   y = sensor_output(x, u_prev, v, plant.C, plant.D, plant.F);
end</code></pre>
      </td>
      <td><strong>MATLAB 2 Function</strong></td>
 </td>
    </tr>
    <tr>
      <td><strong>EKF_MU</strong></td>
      <td>
        <pre style="white-space: pre-wrap; word-break: break-word;"><code>function [xbar_f, P_f, e, St] = EKF_MU(xbar_p, P_p, y, u_prev, ekf)
   [xbar_f, P_f, ~, e, St] = ekf_measurement_update(xbar_p, P_p, y, u_prev, ekf);
end</code></pre>
      </td>
      <td><strong>MATLAB 2 Function</strong></td>
    </tr>
    <tr>
      <td><strong>EKF_TU</strong></td>
      <td>
        <pre style="white-space: pre-wrap; word-break: break-word;"><code>function [xbar_next, P_next] = EKF_TU(xbar_f, P_f, u, ekf)
   [xbar_next, P_next] = ekf_time_update(xbar_f, P_f, u, ekf);
end</code></pre>
      </td>
      <td><strong>MATLAB 2 Function</strong></td>
    </tr>
    <tr>
      <td><strong>NMPC</strong></td>
      <td>
        <pre style="white-space: pre-wrap; word-break: break-word;"><code>function [u, U, Zpred, info] = NMPC(xbar_f, r, u_prev, U_prev, nmpc)
   [u, U, Zpred, info] = nmpc_semilinear(xbar_f, r, u_prev, U_prev, nmpc);
end</code></pre>
      </td>
      <td><strong>MATLAB 2 Function</strong></td>
    </tr>
  </tbody>
</table>
