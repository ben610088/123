close all


font_size = 15;
legend_size = 13;
line_size = 2.5;
%%
time = f16_control_Error_pqr.Time;
% %   noTVC scope Input Command : P Q R  用於 繪製 "無加裝向量噴嘴的體軸角速度控制迴路" 模擬圖；Model: NDI_controller_f16_pqr_test_final
% % Thrust
% figure(1)
% subplot(2,2,1)
% 
% plot(time,f16_control_energy.Data(:,1),'k:','LineWidth',line_size )
% hold on 
% plot(time,f16_control_energy.Data(:,5),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% legend('Controller','Actual','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('Thrust (lbf)')
% % 
% %Elevator
% subplot(2,2,2)
% plot(time,f16_control_energy.Data(:,2),'k:','LineWidth',line_size )
% hold on 
% plot(time,f16_control_energy.Data(:,6),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% legend('Controller','Actual','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\delta_{e} (deg)')
% 
% subplot(2,2,3)
% plot(time,f16_control_energy.Data(:,3),'k:','LineWidth',line_size )
% hold on 
% plot(time,f16_control_energy.Data(:,7),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% legend('Controller','Actual','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\delta_{a} (deg)')
% 
% subplot(2,2,4)
% plot(time,f16_control_energy.Data(:,4),'k:','LineWidth',line_size )
% hold on 
% plot(time,f16_control_energy.Data(:,8),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% legend('Controller','Actual','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\delta_{r}  (deg)')
% %---------------------------------------------------------------------------------
% % Angular Rate Control
% figure(50)
% %p
% subplot(2,3,1)
% plot(time,rad2deg(f16_control_pqr.Data(:,1)),'r-','LineWidth',line_size )
% hold on
% plot(time,rad2deg(f16_control_com_pqr.Data(:,1)),'k:','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% legend('p','p_{ref}','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('p (deg/s)')
% 
% %q
% subplot(2,3,2)
% plot(time,rad2deg(f16_control_pqr.Data(:,2)),'r-','LineWidth',line_size )
% hold on
% plot(time,rad2deg(f16_control_com_pqr.Data(:,2)),'k:','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% legend('q','q_{ref}','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('q (deg/s)')
% 
% %r
% subplot(2,3,3)
% plot(time,rad2deg(f16_control_pqr.Data(:,3)),'r-','LineWidth',line_size )
% hold on
% plot(time,rad2deg(f16_control_com_pqr.Data(:,3)),'k:','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% legend('r','r_{ref}','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('r (deg/s)')

% %  TVC scope Input Command : P Q R   用於繪製 "加裝向量噴嘴的體軸角速度控制迴路" 模擬圖；Model: NDI_controller_f16_pqr_test_TVC_final
% %actuator
% 
% figure(145)
% %Thrust
% subplot(2,3,1)
% plot(time,f16_control_energy.Data(:,1),'k:','LineWidth',line_size )
% hold on 
% plot(time,f16_control_energy.Data(:,7),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% legend('Controller','Actual','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('Thrust (lbf)')
% 
% %Elevator
% subplot(2,3,2)
% plot(time,f16_control_energy.Data(:,2),'k:','LineWidth',line_size )
% hold on 
% plot(time,f16_control_energy.Data(:,8),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('Controller','Actual','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\delta_{e} (deg)')
% 
% %aileon 
% subplot(2,3,3)
% plot(time,f16_control_energy.Data(:,3),'k:','LineWidth',line_size )
% hold on 
% plot(time,f16_control_energy.Data(:,9),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('Controller','Actual','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\delta_{a} (deg)')
% 
% %rudder 
% subplot(2,3,4)
% plot(time,f16_control_energy.Data(:,4),'k:','LineWidth',line_size )
% hold on 
% plot(time,f16_control_energy.Data(:,10),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('Controller','Actual','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\delta_{r}  (deg)')
% 
% % delta_z
% subplot(2,3,5)
% plot(time,f16_control_energy.Data(:,5),'k:','LineWidth',line_size )
% hold on 
% plot(time,f16_control_energy.Data(:,11),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('Controller','Actual','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\delta_{z}  (deg)')
% 
% %delta_y 
% subplot(2,3,6)
% plot(time,f16_control_energy.Data(:,6),'k:','LineWidth',line_size )
% hold on 
% plot(time,f16_control_energy.Data(:,12),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('Controller','Actual','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\delta_{y}  (deg)')
% %---------------------------------------------------------------------------------
% % Angular Rate Control
% figure(50)
% %p
% subplot(2,3,1)
% plot(time,rad2deg(f16_control_pqr.Data(:,1)),'r-','LineWidth',line_size )
% hold on
% plot(time,rad2deg(f16_control_com_pqr.Data(:,1)),'k:','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% legend('p','p_{ref}','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('p (deg/s)')
% 
% %q
% subplot(2,3,2)
% plot(time,rad2deg(f16_control_pqr.Data(:,2)),'r-','LineWidth',line_size )
% hold on
% plot(time,rad2deg(f16_control_com_pqr.Data(:,2)),'k:','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% legend('q','q_{ref}','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('q (deg/s)')
% 
% %r
% subplot(2,3,3)
% plot(time,rad2deg(f16_control_pqr.Data(:,3)),'r-','LineWidth',line_size )
% hold on
% plot(time,rad2deg(f16_control_com_pqr.Data(:,3)),'k:','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% legend('r','r_{ref}','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('r (deg/s)')

%%  noTVC scope  Input Command : mu alpha beta  用於繪製 "無加裝向量噴嘴的風軸姿態角控制迴路" 模擬圖；Model: NDI_controller_f16_mu_alpha_beta_test_final
% %actuator----------------------------------------------------------------
% % Thrust
% figure(1)
% subplot(2,3,1)
% 
% plot(time,f16_control_energy.Data(:,1),'k:','LineWidth',line_size )
% hold on 
% plot(time,f16_control_energy.Data(:,5),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% legend('Controller','Actual','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('Thrust (lbf)')
% 
% %Elevator
% subplot(2,3,2)
% plot(time,f16_control_energy.Data(:,2),'k:','LineWidth',line_size )
% hold on 
% plot(time,f16_control_energy.Data(:,6),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('Controller','Actual','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\delta_{e} (deg)')
% 
% %aileon
% subplot(2,3,3)
% plot(time,f16_control_energy.Data(:,3),'k:','LineWidth',line_size )
% hold on 
% plot(time,f16_control_energy.Data(:,7),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('Controller','Actual','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\delta_{a} (deg)')
% 
% %rudder
% subplot(2,3,4)
% plot(time,f16_control_energy.Data(:,4),'k:','LineWidth',line_size )
% hold on 
% plot(time,f16_control_energy.Data(:,8),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('Controller','Actual','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\delta_{r}  (deg)')
% 
% %--------------------------------------------------------------------
% 
% %alpha/beta/mu
% % alpha
% figure(100)
% subplot(2,3,1)
% plot(time,rad2deg(f16_control_velocity_mu_alpha_beta.Data(:,2)),'r-','LineWidth',line_size )
% hold on 
% plot(time,rad2deg(f16_control_comm_mu_alpha_beta.Data(:,2)),'k:','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('\alpha','\alpha_{ref}','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\alpha (deg)')
% 
% % beta
% subplot(2,3,2)
% plot(time,rad2deg(f16_control_velocity_mu_alpha_beta.Data(:,3)),'r-','LineWidth',line_size )
% hold on 
% plot(time,rad2deg(f16_control_comm_mu_alpha_beta.Data(:,3)),'k:','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('\beta','\beta_{ref}','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\beta (deg)')
% 
% % mu
% subplot(2,3,3)
% plot(time,rad2deg(f16_control_velocity_mu_alpha_beta.Data(:,4)),'r-','LineWidth',line_size )
% hold on 
% plot(time,rad2deg(f16_control_comm_mu_alpha_beta.Data(:,1)),'k:','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('\mu','\mu_{ref}','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\mu (deg)')
% %---------------------------------------------------------------------------------------------
% %inertia axis
% 
% %上視圖
% figure(111)
% subplot(2,3,1)
% plot(f16_control_inertia_axis.Data(:,1),f16_control_inertia_axis.Data(:,2),'r-','LineWidth',line_size)
% set(gca,'FontSize',font_size)
% grid on
% xlabel('North(ft)')
% ylabel('East(ft)')
% 
% %側視圖
% subplot(2,3,2)
% plot(f16_control_inertia_axis.Data(:,1),-1*f16_control_inertia_axis.Data(:,3),'r-','LineWidth',line_size)
% set(gca,'FontSize',font_size)
% grid on
% xlabel('North(ft)')
% ylabel('Height(ft)')
% 
% %3D
% subplot(2,3,3)
% plot3(f16_control_inertia_axis.Data(:,1),f16_control_inertia_axis.Data(:,2),-1*f16_control_inertia_axis.Data(:,3),'r-','LineWidth',line_size)
% set(gca,'FontSize',font_size)
% grid on
% xlabel('North(ft)')
% ylabel('East(ft)')
% zlabel('Height(ft)')
% 
% %axis/time
% subplot(2,3,4)
% plot(time,f16_control_inertia_axis.Data(:,1),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% xlabel('Time(s)')
% ylabel('North(ft)')
% 
% %epos
% subplot(2,3,5)
% plot(time,f16_control_inertia_axis.Data(:,2),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% xlabel('Time(s)')
% ylabel('Eorth(ft)')
% 
% %Attitude
% subplot(2,3,6)
% plot(time,f16_control_inertia_axis.Data(:,3).*-1,'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% xlabel('Time(s)')
% ylabel('Height(ft)')

%% TVC scope  Input Command : mu alpha beta  用於繪製 "加裝向量噴嘴的風軸姿態角控制迴路" 模擬圖；Model: NDI_controller_f16_mu_alpha_beta_TVC_test_final

% %actuator
% 
% figure(145)
% %Thrust
% subplot(2,3,1)
% plot(time,f16_control_energy.Data(:,1),'k:','LineWidth',line_size )
% hold on 
% plot(time,f16_control_energy.Data(:,7),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% legend('Controller','Actual','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('Thrust (lbf)')
% 
% %Elevator
% subplot(2,3,2)
% plot(time,f16_control_energy.Data(:,2),'k:','LineWidth',line_size )
% hold on 
% plot(time,f16_control_energy.Data(:,8),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('Controller','Actual','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\delta_{e} (deg)')
% 
% %aileon 
% subplot(2,3,3)
% plot(time,f16_control_energy.Data(:,3),'k:','LineWidth',line_size )
% hold on 
% plot(time,f16_control_energy.Data(:,9),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('Controller','Actual','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\delta_{a} (deg)')
% 
% %rudder 
% subplot(2,3,4)
% plot(time,f16_control_energy.Data(:,4),'k:','LineWidth',line_size )
% hold on 
% plot(time,f16_control_energy.Data(:,10),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('Controller','Actual','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\delta_{r}  (deg)')
% 
% % delta_z
% subplot(2,3,5)
% plot(time,f16_control_energy.Data(:,5),'k:','LineWidth',line_size )
% hold on 
% plot(time,f16_control_energy.Data(:,11),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('Controller','Actual','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\delta_{z}  (deg)')
% 
% %delta_y 
% subplot(2,3,6)
% plot(time,f16_control_energy.Data(:,6),'k:','LineWidth',line_size )
% hold on 
% plot(time,f16_control_energy.Data(:,12),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('Controller','Actual','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\delta_{y}  (deg)')
% 
% %-------------------------------------------------------------------------
% 
% %alpha/beta/mu
% % alpha
% figure(100)
% subplot(2,3,1)
% plot(time,rad2deg(f16_control_velocity_mu_alpha_beta.Data(:,2)),'r-','LineWidth',line_size )
% hold on 
% plot(time,rad2deg(f16_control_comm_mu_alpha_beta.Data(:,2)),'k:','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('\alpha','\alpha_{ref}','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\alpha (deg)')
% 
% % beta
% subplot(2,3,2)
% plot(time,rad2deg(f16_control_velocity_mu_alpha_beta.Data(:,3)),'r-','LineWidth',line_size )
% hold on 
% plot(time,rad2deg(f16_control_comm_mu_alpha_beta.Data(:,3)),'k:','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('\beta','\beta_{ref}','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\beta (deg)')
% 
% % mu
% subplot(2,3,3)
% plot(time,rad2deg(f16_control_velocity_mu_alpha_beta.Data(:,4)),'r-','LineWidth',line_size )
% hold on 
% plot(time,rad2deg(f16_control_comm_mu_alpha_beta.Data(:,1)),'k:','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('\mu','\mu_{ref}','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\mu (deg)')
% 
% %---------------------------------------------------------------------------------------------
% %inertia axis
% 
% %上視圖
% figure(111)
% subplot(2,3,1)
% plot(f16_control_inertia_axis.Data(:,1),f16_control_inertia_axis.Data(:,2),'r-','LineWidth',line_size)
% set(gca,'FontSize',font_size)
% grid on
% xlabel('North(ft)')
% ylabel('East(ft)')
% 
% %側視圖
% subplot(2,3,2)
% plot(f16_control_inertia_axis.Data(:,1),-1*f16_control_inertia_axis.Data(:,3),'r-','LineWidth',line_size)
% set(gca,'FontSize',font_size)
% grid on
% xlabel('North(ft)')
% ylabel('Height(ft)')
% 
% %3D
% subplot(2,3,3)
% plot3(f16_control_inertia_axis.Data(:,1),f16_control_inertia_axis.Data(:,2),-1*f16_control_inertia_axis.Data(:,3),'r-','LineWidth',line_size)
% set(gca,'FontSize',font_size)
% grid on
% xlabel('North(ft)')
% ylabel('East(ft)')
% zlabel('Height(ft)')
% 
% %axis/time
% subplot(2,3,4)
% plot(time,f16_control_inertia_axis.Data(:,1),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% xlabel('Time(s)')
% ylabel('North(ft)')
% 
% %epos
% subplot(2,3,5)
% plot(time,f16_control_inertia_axis.Data(:,2),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% xlabel('Time(s)')
% ylabel('Eorth(ft)')
% 
% %Attitude
% subplot(2,3,6)
% plot(time,f16_control_inertia_axis.Data(:,3).*-1,'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% xlabel('Time(s)')
% ylabel('Height(ft)')

% %  noTVC scope  Input Command : V chi gamma  用於繪製 "無加裝向量噴嘴的速度向量追蹤控制迴路" 模擬圖；Model: NDI_controller_f16_Vt_gamma_chi_noTVC
% 
% %actuator----------------------------------------------------------------
% % Thrust
% figure(1)
% subplot(2,3,1)
% plot(time,f16_control_energy.Data(:,5),'r-','LineWidth',line_size )
% hold on
% plot(time,T_max_min.Data(:,1),'k:','LineWidth',line_size)
% plot(time,T_max_min.Data(:,2),'k:','LineWidth',line_size)
% set(gca,'FontSize',font_size)
% grid on
%  legend('T','T_{max}','T_{min}','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('Actual Thrust (lbf)')
% % 
% %Elevator
% subplot(2,3,2)
% plot(time,f16_control_energy.Data(:,2),'k:','LineWidth',line_size )
% hold on 
% plot(time,f16_control_energy.Data(:,6),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('\delta_{e_{c}}','\delta_{e}','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\delta_{e} (deg)')
% 
% %aileon
% subplot(2,3,3)
% plot(time,f16_control_energy.Data(:,3),'k:','LineWidth',line_size )
% hold on 
% plot(time,f16_control_energy.Data(:,7),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('\delta_{a_{c}}','\delta_{a}','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\delta_{a} (deg)')
% 
% %rudder
% subplot(2,3,4)
% plot(time,f16_control_energy.Data(:,4),'k:','LineWidth',line_size )
% hold on 
% plot(time,f16_control_energy.Data(:,8),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('\delta_{r_{c}}','\delta_{r}','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\delta_{r}  (deg)')
% 
% %Drag
% subplot(2,3,5)
% plot(time,f16_control_DYL.Data(:,1),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('Drag','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('Drag (lbf)')
% 
% %Lift
% subplot(2,3,6)
% plot(time,f16_control_DYL.Data(:,3),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('Lift','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('Lift (lbf)')
% %--------------------------------------------------------------------
% 
% %alpha/beta/mu
% % alpha
% figure(100)
% subplot(2,3,1)
% plot(time,rad2deg(f16_control_velocity_mu_alpha_beta.Data(:,2)),'r-','LineWidth',line_size )
% hold on 
% plot(time,rad2deg(f16_control_comm_mu_alpha_beta.Data(:,2)),'k:','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('\alpha','\alpha_{c}','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\alpha (deg)')
% 
% % beta
% subplot(2,3,2)
% plot(time,rad2deg(f16_control_velocity_mu_alpha_beta.Data(:,3)),'r-','LineWidth',line_size )
% hold on 
% plot(time,rad2deg(f16_control_comm_mu_alpha_beta.Data(:,3)),'k:','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('\beta','\beta_{c}','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\beta (deg)')
% 
% % mu
% subplot(2,3,3)
% plot(time,rad2deg(f16_control_velocity_mu_alpha_beta.Data(:,4)),'r-','LineWidth',line_size )
% hold on 
% plot(time,rad2deg(f16_control_comm_mu_alpha_beta.Data(:,1)),'k:','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('\mu','\mu_{c}','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\mu (deg)')
% 
% %-------------------------------------------------------------------------------------------------
% % Outer loop V/chi/gamma
% %V
% subplot(2,3,4)
% plot(time,outer_loop_Vt_Chi_gamma.Data(:,1),'r-','LineWidth',line_size )
% hold on 
% plot(time,f16_control_comm_Vt_Chi_Gamma.Data(:,1),'k:','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('V_{T}','V_{T_{c}}','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('V_{T} (ft/s)')
% 
% %chi
% subplot(2,3,5)
% plot(time,rad2deg(outer_loop_Vt_Chi_gamma.Data(:,2)),'r-','LineWidth',line_size )
% hold on 
% plot(time,rad2deg(f16_control_comm_Vt_Chi_Gamma.Data(:,2)),'k:','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('\chi','\chi_{c}','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\chi (deg)')
% 
% %gamma
% subplot(2,3,6)
% plot(time,rad2deg(outer_loop_Vt_Chi_gamma.Data(:,3)),'r-','LineWidth',line_size )
% hold on 
% plot(time,rad2deg(f16_control_comm_Vt_Chi_Gamma.Data(:,3)),'k:','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% legend('\gamma','\gamma_{c}','FontSize',legend_size)
% xlabel('Time(s)')
% ylabel('\gamma (deg)')
% 
% %--------------------------------------------------------------------------------------
% %inertia axis
% 
% %上視圖
% figure(111)
% subplot(2,3,1)
% plot(f16_control_inertia_axis.Data(:,1),f16_control_inertia_axis.Data(:,2),'r-','LineWidth',line_size)
% set(gca,'FontSize',font_size)
% grid on
% xlabel('North(ft)')
% ylabel('East(ft)')
% 
% %側視圖
% subplot(2,3,2)
% plot(f16_control_inertia_axis.Data(:,1),-1*f16_control_inertia_axis.Data(:,3),'r-','LineWidth',line_size)
% set(gca,'FontSize',font_size)
% grid on
% xlabel('North(ft)')
% ylabel('Height(ft)')
% 
% %3D
% subplot(2,3,3)
% plot3(f16_control_inertia_axis.Data(:,1),f16_control_inertia_axis.Data(:,2),-1*f16_control_inertia_axis.Data(:,3),'r-','LineWidth',line_size)
% set(gca,'FontSize',font_size)
% grid on
% axis equal
% xlabel('North(ft)')
% ylabel('East(ft)')
% zlabel('Height(ft)')
% 
% %axis/time
% subplot(2,3,4)
% plot(time,f16_control_inertia_axis.Data(:,1),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% xlabel('Time(s)')
% ylabel('North(ft)')
% 
% %epos
% subplot(2,3,5)
% plot(time,f16_control_inertia_axis.Data(:,2),'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% xlabel('Time(s)')
% ylabel('East(ft)')
% 
% %Attitude
% subplot(2,3,6)
% plot(time,f16_control_inertia_axis.Data(:,3).*-1,'r-','LineWidth',line_size )
% set(gca,'FontSize',font_size)
% grid on
% xlabel('Time(s)')
% ylabel('Height(ft)')

%% TVC Input Command : V chi gamma  用於繪製 "加裝向量噴嘴的速度向量追蹤控制迴路" 模擬圖；Model: NDI_controller_f16_Vt_gamma_chi_TVC 、NDI_controller_f16_Vt_gamma_chi_TVC_inlet

%actuator

figure(145)
%Thrust
subplot(2,3,1)
plot(time,f16_control_energy.Data(:,7),'r-','LineWidth',line_size )
hold on
plot(time,T_max_min.Data(:,1),'k:','LineWidth',line_size)
plot(time,T_max_min.Data(:,2),'k:','LineWidth',line_size)
set(gca,'FontSize',font_size)
grid on
legend('T','T_{max}','T_{min}','FontSize',legend_size)
xlabel('Time(s)')
ylabel('Actual Thrust (lbf)')

%Elevator
subplot(2,3,2)
plot(time,f16_control_energy.Data(:,2),'k:','LineWidth',line_size )
hold on 
plot(time,f16_control_energy.Data(:,8),'r-','LineWidth',line_size )
set(gca,'FontSize',font_size)
grid on
legend('\delta_{e_{c}}','\delta_{e}','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\delta_{e} (deg)')

%aileon 
subplot(2,3,3)
plot(time,f16_control_energy.Data(:,3),'k:','LineWidth',line_size )
hold on 
plot(time,f16_control_energy.Data(:,9),'r-','LineWidth',line_size )
set(gca,'FontSize',font_size)
grid on
legend('\delta_{a_{c}}','\delta_{a}','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\delta_{a} (deg)')

%rudder 
subplot(2,3,4)
plot(time,f16_control_energy.Data(:,4),'k:','LineWidth',line_size )
hold on 
plot(time,f16_control_energy.Data(:,10),'r-','LineWidth',line_size )
set(gca,'FontSize',font_size)
grid on
legend('\delta_{r_{c}}','\delta_{r}','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\delta_{r}  (deg)')

% delta_z
subplot(2,3,5)
plot(time,f16_control_energy.Data(:,5),'k:','LineWidth',line_size )
hold on 
plot(time,f16_control_energy.Data(:,11),'r-','LineWidth',line_size )
set(gca,'FontSize',font_size)
grid on
legend('\delta_{z_{c}}','\delta_{z}','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\delta_{z}  (deg)')

%delta_y 
subplot(2,3,6)
plot(time,f16_control_energy.Data(:,6),'k:','LineWidth',line_size )
hold on 
plot(time,f16_control_energy.Data(:,12),'r-','LineWidth',line_size )
set(gca,'FontSize',font_size)
grid on
legend('\delta_{y_{c}}','\delta_{y}','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\delta_{y}  (deg)')


%-------------------------------------------------------------------------

%alpha/beta/mu
% alpha
figure(100)
subplot(2,3,1)
plot(time,rad2deg(f16_control_velocity_mu_alpha_beta.Data(:,2)),'r-','LineWidth',line_size )
hold on 
plot(time,rad2deg(f16_control_comm_mu_alpha_beta.Data(:,2)),'k:','LineWidth',line_size )
set(gca,'FontSize',font_size)
grid on
legend('\alpha','\alpha_{c}','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\alpha (deg)')

% beta
subplot(2,3,2)
plot(time,rad2deg(f16_control_velocity_mu_alpha_beta.Data(:,3)),'r-','LineWidth',line_size )
hold on 
plot(time,rad2deg(f16_control_comm_mu_alpha_beta.Data(:,3)),'k:','LineWidth',line_size )
set(gca,'FontSize',font_size)
grid on
legend('\beta','\beta_{c}','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\beta (deg)')

% mu
subplot(2,3,3)
plot(time,rad2deg(f16_control_velocity_mu_alpha_beta.Data(:,4)),'r-','LineWidth',line_size )
hold on 
plot(time,rad2deg(f16_control_comm_mu_alpha_beta.Data(:,1)),'k:','LineWidth',line_size )
set(gca,'FontSize',font_size)
grid on
legend('\mu','\mu_{c}','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\mu (deg)')

% %--------------------------------------------------------------------------

% Outer loop V/chi/gamma
%V
subplot(2,3,4)
plot(time,outer_loop_Vt_Chi_gamma.Data(:,1),'r-','LineWidth',line_size )
hold on 
plot(time,f16_control_comm_Vt_Chi_Gamma.Data(:,1),'k:','LineWidth',line_size )
set(gca,'FontSize',font_size)
grid on
legend('V_{T}','V_{T_{c}}','FontSize',legend_size)
xlabel('Time(s)')
ylabel('V_{T} (ft/s)')

%chi
subplot(2,3,5)
plot(time,rad2deg(outer_loop_Vt_Chi_gamma.Data(:,2)),'r-','LineWidth',line_size )
hold on 
plot(time,rad2deg(f16_control_comm_Vt_Chi_Gamma.Data(:,2)),'k:','LineWidth',line_size )
set(gca,'FontSize',font_size)
grid on
legend('\chi','\chi_{c}','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\chi (deg)')

%gamma
subplot(2,3,6)
plot(time,rad2deg(outer_loop_Vt_Chi_gamma.Data(:,3)),'r-','LineWidth',line_size )
hold on 
plot(time,rad2deg(f16_control_comm_Vt_Chi_Gamma.Data(:,3)),'k:','LineWidth',line_size )
set(gca,'FontSize',font_size)
grid on
legend('\gamma','\gamma_{c}','FontSize',legend_size)
xlabel('Time(s)')
ylabel('\gamma (deg)')

%-----------------------------------------------------------------------------------------

%inertia axis

%上視圖
figure(111)
subplot(2,3,1)
plot(f16_control_inertia_axis.Data(:,1),f16_control_inertia_axis.Data(:,2),'r-','LineWidth',line_size)
set(gca,'FontSize',font_size)
grid on
xlabel('North(ft)')
ylabel('East(ft)')

%側視圖
subplot(2,3,2)
plot(f16_control_inertia_axis.Data(:,1),-1*f16_control_inertia_axis.Data(:,3),'r-','LineWidth',line_size)
set(gca,'FontSize',font_size)
grid on
xlabel('North(ft)')
ylabel('Height(ft)')

%3D
subplot(2,3,3)
plot3(f16_control_inertia_axis.Data(:,1),f16_control_inertia_axis.Data(:,2),-1*f16_control_inertia_axis.Data(:,3),'r-','LineWidth',line_size)
set(gca,'FontSize',font_size)
axis equal
grid on
xlabel('North(ft)')
ylabel('East(ft)')
zlabel('Height(ft)')

%axis/time
subplot(2,3,4)
plot(time,f16_control_inertia_axis.Data(:,1),'r-','LineWidth',line_size )
set(gca,'FontSize',font_size)
grid on
xlabel('Time(s)')
ylabel('North(ft)')

%epos
subplot(2,3,5)
plot(time,f16_control_inertia_axis.Data(:,2),'r-','LineWidth',line_size )
set(gca,'FontSize',font_size)
grid on
xlabel('Time(s)')
ylabel('Eorth(ft)')

%Attitude
subplot(2,3,6)
plot(time,f16_control_inertia_axis.Data(:,3).*-1,'r-','LineWidth',line_size )
set(gca,'FontSize',font_size)
grid on
xlabel('Time(s)')
ylabel('Height(ft)')
%% 升力阻力組合圖 用於繪製圖6.2.23阻力升力圖
figure(1254)
%Drag
subplot(2,3,1)
plot(time,f16_control_DYL.Data(:,1),'r-','LineWidth',line_size )
hold on
plot(time,f16_control_DYL.Data(:,3),'b:','LineWidth',line_size )
set(gca,'FontSize',font_size)
grid on
legend('Drag','Lift','FontSize',legend_size)
xlabel('Time(s)')
ylabel('Drag & Lift (lbf)')

