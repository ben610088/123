function x = ruku4(state_eq, ts, x, dt, u1, u2, param, t ,~)      % 將 Nx 改成 ~
% 有修改 1 個地方

% Subroutine for integration of state equations by Runge-Kutta 4th order
%
% Chapter 3: Model Postulates and Simulation
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA

% 範例書附原始程式
% dt2 = 0.5*dt;
% % xdt = zeros(Nx,1);        % 推測為初始化動作!?但是會會引響結果
% 
% xdt = feval(state_eq, ts, x, u1, param);
% rk1 = xdt*dt2;
% 
% u12 = (u1 + u2) / 2;    % average of u(k) and u(k+1) 
% x1  = x + rk1;
% xdt = feval(state_eq, ts, x1, u12, param);
% rk2 = dt2*xdt;
% 
% x1  = x + rk2;
% xdt = feval(state_eq, ts, x1, u12, param);
% rk3 = dt2*xdt;
% 
% x1  = x + 2*rk3;
% xdt = feval(state_eq, ts, x1, u2, param);
% rk4 = dt2*xdt;
% 
% x   = x + (rk1 + 2.0*(rk2+rk3) + rk4)/3;

% 參考影片：https://www.youtube.com/watch?v=uErapmuyMpw  MATLAB代碼分享視頻：四階龍格庫塔法求解常微分方程組
% 經過驗證，與上面書附範例原始程式計算結果相同
u12 = (u1 + u2) / 2;

z1 = feval(state_eq, ts, x, u1, param);
z2 = feval(state_eq, ts + dt/2, x + z1*dt/2, u12, param);
z3 = feval(state_eq, ts + dt/2, x + z2*dt/2, u12, param);
z4 = feval(state_eq, ts + dt, x + z3*dt, u2, param);
x = x + dt*(z1 + 2*z2 + 2*z3 + z4)/6;

return
% end of subroutine
