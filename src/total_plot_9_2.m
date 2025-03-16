% close all


font_size = 15;
legend_size = 13;
line_size = 1.5;

time = f16_control_pqr.Time;
%start-----------------------------pqr-------------------------------------
figure(1)
%p
subplot(2,3,1)
% plot(time,rad2deg(f16_control_com_pqr.Data(:,1)),'k:','LineWidth',line_size )
hold on
plot(time,rad2deg(f16_control_pqr.Data(:,1)),'b-','LineWidth',line_size )
hold on
set(gca,'FontSize',font_size)
% legend('pc','p1','p2','FontSize',legend_size)
legend('p_1','p_2','FontSize',legend_size)
xlabel('Time(s)')
ylabel('p (deg/s)')
grid on

%q
subplot(2,3,2)
% plot(time,rad2deg(f16_control_com_pqr.Data(:,2)),'k:','LineWidth',line_size )
hold on
plot(time,rad2deg(f16_control_pqr.Data(:,2)),'b-','LineWidth',line_size )
hold on
set(gca,'FontSize',font_size)
% legend('qc','q1','q2','FontSize',legend_size)
legend('q_1','q_2','FontSize',legend_size)
xlabel('Time(s)')
ylabel('q (deg/s)')
grid on

%r
subplot(2,3,3)
% plot(time,rad2deg(f16_control_com_pqr.Data(:,3)),'k:','LineWidth',line_size )
hold on
plot(time,rad2deg(f16_control_pqr.Data(:,3)),'b-','LineWidth',line_size )
hold on
set(gca,'FontSize',font_size)
% legend('rc','r1','r2','FontSize',legend_size)
legend('r_1','r_2','FontSize',legend_size)
xlabel('Time(s)')
ylabel('r (deg/s)')
grid on
%end-----------------------------pqr-------------------------------------
%start-----------------------------euler-------------------------------------
%phi
subplot(2,3,4)
% 判斷兩相鄰角度是否超越180度，若超過則判斷為有跳變點(即有wrap的意思)，故減掉 2*pi 使角度 unwrap 
phi_rad = f16_control_Euler.Data(:,1);
for i = 2 : size(phi_rad,1)
    if  phi_rad(i) - phi_rad(i-1) < (-1*pi)                  % 可以改用diff()指令
        phi_rad(i:end) = phi_rad(i:end) + 2*pi;
    elseif phi_rad(i) - phi_rad(i-1) > pi                  % 可以改用diff()指令
        phi_rad(i:end) = phi_rad(i:end) - 2*pi;
    else
        % 不動作        
    end
end
% -----
plot(time,rad2deg(phi_rad),'b-','LineWidth',line_size )
hold on
set(gca,'FontSize',font_size)
legend('\phi_1','\phi_2','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\phi (deg)')
grid on

%theta
subplot(2,3,5)
% 判斷兩相鄰角度是否超越180度，若超過則判斷為有跳變點(即有wrap的意思)，故減掉 2*pi 使角度 unwrap 
theta_rad = f16_control_Euler.Data(:,2);
for i = 2 : size(theta_rad,1)
    if  theta_rad(i) - theta_rad(i-1) < (-1*pi)                  % 可以改用diff()指令
        theta_rad(i:end) = theta_rad(i:end) + 2*pi;
    elseif theta_rad(i) - theta_rad(i-1) > pi                  % 可以改用diff()指令
        theta_rad(i:end) = theta_rad(i:end) - 2*pi;
    else
        % 不動作        
    end
end
% -----
plot(time,rad2deg(theta_rad),'b-','LineWidth',line_size )
hold on
set(gca,'FontSize',font_size)
legend('\theta_1','\theta_2','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\theta (deg)')
grid on

%psi
subplot(2,3,6)
% 判斷兩相鄰角度是否超越180度，若超過則判斷為有跳變點(即有wrap的意思)，故減掉 2*pi 使角度 unwrap 
psi_rad = f16_control_Euler.Data(:,3);
for i = 2 : size(psi_rad,1)
    if  psi_rad(i) - psi_rad(i-1) < (-1*pi)                  % 可以改用diff()指令
        psi_rad(i:end) = psi_rad(i:end) + 2*pi;
    elseif psi_rad(i) - psi_rad(i-1) > pi                  % 可以改用diff()指令
        psi_rad(i:end) = psi_rad(i:end) - 2*pi;
    else
        % 不動作        
    end
end
% -----
plot(time,rad2deg(psi_rad),'b-','LineWidth',line_size )
hold on
set(gca,'FontSize',font_size)
legend('\psi_1','\psi_2','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\psi (deg)')
grid on
%end-----------------------------euler-------------------------------------


%start-----------------------------actuator-------------------------------------
figure(2)
%Thrust
% subplot(2,3,1)
% plot(time,f16_control_energy.Data(:,7),'b-','LineWidth',line_size )
% hold on
% plot(time,T_max_min.Data(:,1),'k:','LineWidth',line_size)
% plot(time,T_max_min.Data(:,2),'k:','LineWidth',line_size)
% set(gca,'FontSize',font_size)
% grid on
% legend('T_1','T_{max}','T_{min}','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('Actual Thrust (lbf)')

%right aileron
subplot(2,3,1)
% plot(time,f16_control_energy.Data(:,2),'k:','LineWidth',line_size )
hold on 
plot(time,f16_control_energy.Data(:,12),'b-','LineWidth',line_size )
hold on
set(gca,'FontSize',font_size)
grid on
% legend('\delta_{ra_{c}}','\delta_{ra}','FontSize',legend_size)
legend('\delta_{ra_{c}}','\delta_{ra_1}','\delta_{ra_2}','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\delta_{ra} (deg)')
ylim([-25 25])

%left aileron
subplot(2,3,4)
% plot(time,f16_control_energy.Data(:,3),'k:','LineWidth',line_size )
hold on 
plot(time,f16_control_energy.Data(:,13),'b-','LineWidth',line_size )
hold on
set(gca,'FontSize',font_size)
grid on
% legend('\delta_{la_{c}}','\delta_{la}','FontSize',legend_size)
legend('\delta_{la_{c}}','\delta_{la_1}','\delta_{la_2}','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\delta_{la} (deg)')
ylim([-25 25])

%right elevator 
subplot(2,3,2)
% plot(time,f16_control_energy.Data(:,4),'k:','LineWidth',line_size )
hold on 
plot(time,f16_control_energy.Data(:,14),'b-','LineWidth',line_size )
hold on
set(gca,'FontSize',font_size)
grid on
% legend('\delta_{re_{c}}','\delta_{re}','FontSize',legend_size)
legend('\delta_{re_{c}}','\delta_{re_1}','\delta_{re_2}','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\delta_{re} (deg)')
ylim([-30 30])

%left elevator 
subplot(2,3,5)
% plot(time,f16_control_energy.Data(:,5),'k:','LineWidth',line_size )
hold on 
plot(time,f16_control_energy.Data(:,15),'b-','LineWidth',line_size )
hold on
set(gca,'FontSize',font_size)
grid on
% legend('\delta_{le_{c}}','\delta_{le}','FontSize',legend_size)
legend('\delta_{le_{c}}','\delta_{le_1}','\delta_{le_2}','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\delta_{le} (deg)')
ylim([-30 30])

%rudder 
subplot(2,3,3)
% plot(time,f16_control_energy.Data(:,6),'k:','LineWidth',line_size )
hold on 
plot(time,f16_control_energy.Data(:,16),'b-','LineWidth',line_size )
hold on
hold on
set(gca,'FontSize',font_size)
grid on
% legend('\delta_{r_{c}}','\delta_{r}','FontSize',legend_size)
legend('\delta_{r_{c}}','\delta_{r_1}','\delta_{r_2}','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\delta_{r}  (deg)')
ylim([-35 35])

%Mach  
subplot(2,3,6)
plot(time,Mach.Data(:),'b-','LineWidth',line_size )
hold on
set(gca,'FontSize',font_size)
grid on
legend('Mach number','FontSize',legend_size)
xlabel('Time(s)')
ylabel('Mach')


figure (3)
subplot(2,3,1)
% delta_ry
% plot(time,f16_control_energy.Data(:,7),'k:','LineWidth',line_size )
hold on 
plot(time,f16_control_energy.Data(:,17),'b-','LineWidth',line_size )
hold on
set(gca,'FontSize',font_size)
grid on
% legend('\delta_{y_{c}}','\delta_{y}','FontSize',legend_size)
legend('\delta_{ry_{c}}','\delta_{ry_1}','\delta_{ry_2}','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\delta_{ry}  (deg)')
ylim([-20 20])

%delta_rz 
subplot(2,3,2)
% plot(time,f16_control_energy.Data(:,8),'k:','LineWidth',line_size )
hold on 
plot(time,f16_control_energy.Data(:,18),'b-','LineWidth',line_size )
hold on
set(gca,'FontSize',font_size)
grid on
% legend('\delta_{z_{c}}','\delta_{z}','FontSize',legend_size)
legend('\delta_{rz_{c}}','\delta_{rz_1}','\delta_{rz_2}','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\delta_{rz}  (deg)')
ylim([-20 20])

subplot(2,3,4)
% delta_ly
% plot(time,f16_control_energy.Data(:,9),'k:','LineWidth',line_size )
hold on 
plot(time,f16_control_energy.Data(:,19),'b-','LineWidth',line_size )
hold on
set(gca,'FontSize',font_size)
grid on
% legend('\delta_{y_{c}}','\delta_{y}','FontSize',legend_size)
legend('\delta_{ly_{c}}','\delta_{ly_1}','\delta_{ly_2}','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\delta_{ly}  (deg)')
ylim([-20 20])

%delta_lz 
subplot(2,3,5)
% plot(time,f16_control_energy.Data(:,10),'k:','LineWidth',line_size )
hold on 
plot(time,f16_control_energy.Data(:,20),'b-','LineWidth',line_size )
hold on
set(gca,'FontSize',font_size)
grid on
% legend('\delta_{z_{c}}','\delta_{z}','FontSize',legend_size)
legend('\delta_{lz_{c}}','\delta_{lz_1}','\delta_{lz_2}','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\delta_{lz}  (deg)')
ylim([-20 20])
%end-----------------------------actuator-------------------------------------

%start-----------------------------inertia axis-------------------------------------
%上視圖
figure(4)
subplot(2,3,1)
plot(f16_control_inertia_axis.Data(:,1),f16_control_inertia_axis.Data(:,2),'b-','LineWidth',line_size)
hold on
set(gca,'FontSize',font_size)
grid on
xlabel('North(ft)')
ylabel('East(ft)')

%側視圖
subplot(2,3,2)
plot(f16_control_inertia_axis.Data(:,1),-1*f16_control_inertia_axis.Data(:,3),'b-','LineWidth',line_size)
hold on
set(gca,'FontSize',font_size)
grid on
xlabel('North(ft)')
ylabel('Height(ft)')

%3D
subplot(2,3,3)
plot3(f16_control_inertia_axis.Data(:,1),f16_control_inertia_axis.Data(:,2),-1*f16_control_inertia_axis.Data(:,3),'b-','LineWidth',line_size)
hold on
set(gca,'FontSize',font_size)
axis equal
grid on
xlabel('North(ft)')
ylabel('East(ft)')
zlabel('Height(ft)')

%axis/time
subplot(2,3,4)
plot(time,f16_control_inertia_axis.Data(:,1),'b-','LineWidth',line_size )
hold on
set(gca,'FontSize',font_size)
grid on
xlabel('Time(s)')
ylabel('North(ft)')

%epos
subplot(2,3,5)
plot(time,f16_control_inertia_axis.Data(:,2),'b-','LineWidth',line_size )
hold on
set(gca,'FontSize',font_size)
grid on
xlabel('Time(s)')
ylabel('East(ft)')

%Attitude
subplot(2,3,6)
plot(time,f16_control_inertia_axis.Data(:,3).*-1,'b-','LineWidth',line_size )
hold on
set(gca,'FontSize',font_size)
grid on
xlabel('Time(s)')
ylabel('Height(ft)')
%end-----------------------------inertia axis-------------------------------------

%start-----------------------------alpha/beta/mu/V/chi/gamma--------------------------------------------
% alpha
figure(5)
subplot(2,3,1)

% plot(time,rad2deg(f16_control_comm_mu_alpha_beta.Data(:,2)),'k:','LineWidth',line_size )
hold on 
plot(time,rad2deg(f16_control_velocity_mu_alpha_beta.Data(:,2)),'b-','LineWidth',line_size )
set(gca,'FontSize',font_size)
grid on
% legend('\alpha','\alpha_{c}','FontSize',legend_size)
legend('\alpha_{c}','\alpha_1','\alpha_2','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\alpha (deg)')

% beta
subplot(2,3,2)

% plot(time,rad2deg(f16_control_comm_mu_alpha_beta.Data(:,3)),'k:','LineWidth',line_size )
hold on 
plot(time,rad2deg(f16_control_velocity_mu_alpha_beta.Data(:,3)),'b-','LineWidth',line_size )
set(gca,'FontSize',font_size)
grid on
% legend('\beta','\beta_{c}','FontSize',legend_size)
legend('\beta_{c}','\beta_1','\beta_2','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\beta (deg)')

% mu
subplot(2,3,3)
% plot(time,rad2deg(f16_control_comm_mu_alpha_beta.Data(:,1)),'k:','LineWidth',line_size )
hold on 
plot(time,rad2deg(f16_control_velocity_mu_alpha_beta.Data(:,4)),'b-','LineWidth',line_size )
set(gca,'FontSize',font_size)
grid on
% legend('\mu','\mu_{c}','FontSize',legend_size)
legend('\mu_{c}','\mu_1','\mu_2','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\mu (deg)')

%V
subplot(2,3,4)
plot(time,outer_loop_Vt_Chi_gamma.Data(:,1),'b-','LineWidth',line_size )
hold on 
% plot(time,f16_control_comm_Vt_Chi_Gamma.Data(:,1),'k:','LineWidth',line_size )
set(gca,'FontSize',font_size)
grid on
% legend('V_{T}','V_{T_{c}}','FontSize',legend_size)
legend('V_{T1}','V_{T2}','FontSize',legend_size)
xlabel('Time(s)')
ylabel('V_{T} (ft/s)')

%chi
subplot(2,3,5)
plot(time,rad2deg(outer_loop_Vt_Chi_gamma.Data(:,2)),'b-','LineWidth',line_size )
hold on 
% plot(time,rad2deg(f16_control_comm_Vt_Chi_Gamma.Data(:,2)),'k:','LineWidth',line_size )
set(gca,'FontSize',font_size)
grid on
% legend('\chi','\chi_{c}','FontSize',legend_size)
legend('\chi_1','\chi_2','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\chi (deg)')

%gamma
subplot(2,3,6)
plot(time,rad2deg(outer_loop_Vt_Chi_gamma.Data(:,3)),'b-','LineWidth',line_size )
hold on 
% plot(time,rad2deg(f16_control_comm_Vt_Chi_Gamma.Data(:,3)),'k:','LineWidth',line_size )
set(gca,'FontSize',font_size)
grid on
% legend('\gamma','\gamma_{c}','FontSize',legend_size)
legend('\gamma_1','\gamma_2','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\gamma (deg)')
%end-----------------------------alpha/beta/mu/V/chi/gamma--------------------------------------------

%start-----------------------------DYL--------------------------------------------
figure (6)
%Drag
subplot(2,3,1)
plot(time,f16_control_DYL.Data(:,1),'b-','LineWidth',line_size )
set(gca,'FontSize',font_size)
grid on
legend('Drag','FontSize',legend_size)
xlabel('Time(s)')
ylabel('Drag (lbf)')

% %Lift
subplot(2,3,2)
plot(time,f16_control_DYL.Data(:,3),'b-','LineWidth',line_size )
set(gca,'FontSize',font_size)
grid on
legend('Lift','FontSize',legend_size)
xlabel('Time(s)')
ylabel('Lift (lbf)')

subplot(2,3,3)
plot(time,f16_control_energy.Data(:,11),'b-','LineWidth',line_size )
hold on
plot(time,T_max_min.Data(:,1),'k:','LineWidth',line_size)
plot(time,T_max_min.Data(:,2),'k:','LineWidth',line_size)
set(gca,'FontSize',font_size)
grid on
legend('T_1','T_{max}','T_{min}','FontSize',legend_size)
%end-----------------------------DYL--------------------------------------------
%-------------------------------------------------------------------------------
% figure(7)

% u_past1 = upast.Data;
% u_past  = reshape(u_past1,9,2001)';

% subplot(5,2,1)
% plot(time,u_past(1:2001,1),'b-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% xlabel('Time(s)')
% ylabel('\delta_{ra} (deg)')
% 
% subplot(5,2,2)
% plot(time,u_past(1:2001,2),'b-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% xlabel('Time(s)')
% ylabel('\delta_{la} (deg)')
% 
% subplot(5,2,3)
% plot(time,u_past(1:2001,3),'b-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% xlabel('Time(s)')
% ylabel('\delta_{re} (deg)')
% 
% subplot(5,2,4)
% plot(time,u_past(1:2001,4),'b-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% xlabel('Time(s)')
% ylabel('\delta_{le} (deg)')
% 
% subplot(5,2,5)
% plot(time,u_past(1:2001,5),'b-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% xlabel('Time(s)')
% ylabel('\delta_{r} (deg)')
% 
% subplot(5,2,7)
% plot(time,u_past(1:2001,6),'b-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% xlabel('Time(s)')
% ylabel('\delta_{rz}  (deg)')
% 
% subplot(5,2,8)
% plot(time,u_past(1:2001,7),'b-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% xlabel('Time(s)')
% ylabel('\delta_{ry}  (deg)')
% 
% subplot(5,2,9)
% plot(time,u_past(1:2001,8),'b-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% xlabel('Time(s)')
% ylabel('\delta_{lz}  (deg)')

% subplot(5,2,10)
% plot(time,u_past(1:2001,9),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% xlabel('Time(s)')
% ylabel('\delta_{ly}  (deg)')
