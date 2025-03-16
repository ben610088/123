function [T] = plots_TC81_F16_longitudinal_same_origin(T, Z, Y, Uinp, params, par_std, iter)
%% Plot time histories of measured and estimated observation variables
figure(1)
title('Time histories of output variables (measured and estimated); input variables')
subplot(7,1,1),plot(T,Z(:,1), T,Y(:,1),'r');                    grid; ylabel('Vt (m/s)');
subplot(7,1,2),plot(rad2deg(T,Z(:,2)), rad2deg(T,Y(:,2)),'r');  grid; ylabel('\alpha ()');
subplot(7,1,3),plot(rad2deg(T,Z(:,3)), rad2deg(T,Y(:,3)),'r');  grid; ylabel('\theta ()');
subplot(7,1,4),plot(rad2deg(T,Z(:,4)), rad2deg(T,Y(:,4)),'r');  grid; ylabel('q (/s)');
subplot(7,1,5),plot(rad2deg(T,Z(:,5)), rad2deg(T,Y(:,5)),'r');  grid; ylabel('q_dot (/s2)');
subplot(7,1,6),plot(T,Z(:,6), T,Y(:,6),'r');                    grid; ylabel('ax (m/s2)');
subplot(7,1,7),plot(T,Z(:,7), T,Y(:,7),'r');                    grid; ylabel('az (m/s2)');
xlabel('Time in sec');  
figure(2)
title('Time histories of output variables (measured and estimated); input variables')
subplot(7,1,1),plot(rad2deg(T,Uinp(:,1)));                      grid; ylabel('{\delta_re} ()');
subplot(7,1,2),plot(rad2deg(T,Uinp(:,2)));                     grid; ylabel('{\delta_le} ()');
subplot(7,1,3),plot(rad2deg(T,Uinp(:,3)));                      grid; ylabel('{\delta_ra ()');
subplot(7,1,4),plot(rad2deg(T,Uinp(:,4)));                      grid; ylabel('{\delta_la} ()');
subplot(7,1,5),plot(rad2deg(T,Uinp(:,5)));                      grid; ylabel('{\delta_r} ()');
subplot(7,1,6),plot(rad2deg(T,Uinp(:,6)));                      grid; ylabel('{\delta_ry} ()');
subplot(7,1,7),plot(rad2deg(T,Uinp(:,7)));                      grid; ylabel('{\delta_rz} ()');
xlabel('Time in sec');  
figure(3)
title('Time histories of output variables (measured and estimated); input variables')
subplot(7,1,1),plot(rad2deg(T,Uinp(:,8)));                      grid; ylabel('{\delta_ly} ()');
subplot(7,1,2),plot(rad2deg(T,Uinp(:,9)));                      grid; ylabel('{\delta_lz} ()');
subplot(7,1,3),plot(rad2deg(T,Uinp(:,10)));                     grid; ylabel('{\delta_lef} ()');
subplot(7,1,4),plot(rad2deg(T,Uinp(:,11)));                     grid; ylabel('{\delta_sb} ()');
subplot(7,1,5),plot(rad2deg(T,Uinp(:,12)));                     grid; ylabel('{Tx} ()');
subplot(7,1,6),plot(T,Uinp(:,13));                              grid; ylabel('{Ty} ()');
subplot(7,1,7),plot(T,Uinp(:,14));                              grid; ylabel('{Tz} ()');
xlabel('Time in sec');  
figure(4)
title('Time histories of output variables (measured and estimated); input variables')
subplot(7,1,1),plot(T,Uinp(:,15));                              grid; ylabel('{qbar} ()');
subplot(7,1,2),plot(T,Uinp(:,16));                              grid; ylabel('{N} ()');
subplot(7,1,3),plot(T,Uinp(:,17));                              grid; ylabel('{f} ()');
subplot(7,1,4),plot(T,Uinp(:,18));                              grid; ylabel('{beta} ()');
subplot(7,1,5),plot(T,Uinp(:,19));                              grid; ylabel('{phi} ()');
subplot(7,1,6),plot(T,Uinp(:,20));                              grid; ylabel('{psi} ()');
subplot(7,1,7),plot(T,Uinp(:,21));                              grid; ylabel('{p} ()');
xlabel('Time in sec');  
figure(5)
title('Time histories of output variables (measured and estimated); input variables')
subplot(7,1,1),plot(T,Uinp(:,22));                              grid; ylabel('{r} ()');
subplot(7,1,2),plot(T,Uinp(:,23));                              grid; ylabel('{mu} ()');
subplot(7,1,3),plot(T,Uinp(:,24));                              grid; ylabel('{chi} ()');
subplot(7,1,4),plot(T,Uinp(:,25));                              grid; ylabel('{gamma} ()');
xlabel('Time in sec');  

%% Convergence plot: estimated parameter +- standard deviations versus iteration count
if  iter > 0 
    iterations = (0:iter);
    figure(7); zoom;
    title('Convergence of parameter estimates with error bounds')
    subplot(321);errorbar(iterations, params(1,:),par_std(1,:));ylabel('dCl_beta');          xlabel('iteration #');grid
    subplot(322);errorbar(iterations, params(2,:),par_std(2,:));ylabel('Cl_delta_ail');      xlabel('iteration #');grid
    subplot(323);errorbar(iterations, params(3,:),par_std(3,:));ylabel('Cl_delta_ail_lef');  xlabel('iteration #');grid
    subplot(324);errorbar(iterations, params(4,:),par_std(4,:));ylabel('Cl_delta_r');        xlabel('iteration #');grid
    subplot(325);errorbar(iterations, params(5,:),par_std(5,:));ylabel('Cl_p');              xlabel('iteration #');grid
    subplot(326);errorbar(iterations, params(6,:),par_std(6,:));ylabel('dCl_p_lef');         xlabel('iteration #');grid
    figure(8); zoom;
    title('Convergence of parameter estimates with error bounds')
    subplot(321);errorbar(iterations, params(7,:),par_std(7,:));ylabel('Cl_r');            xlabel('iteration #');grid
    subplot(322);errorbar(iterations, params(8,:),par_std(8,:));ylabel('dCl_r_lef');       xlabel('iteration #');grid
    subplot(323);errorbar(iterations, params(9,:),par_std(9,:));ylabel('Cm');              xlabel('iteration #');grid
    subplot(324);errorbar(iterations, params(10,:),par_std(10,:));ylabel('dC_m');            xlabel('iteration #');grid
    subplot(325);errorbar(iterations, params(11,:),par_std(11,:));ylabel('dCm_ds');             xlabel('iteration #');grid
    subplot(326);errorbar(iterations, params(12,:),par_std(12,:));ylabel('dCm_ds_elevatorPdeci');             xlabel('iteration #');grid
    figure(9); zoom;
    title('Convergence of parameter estimates with error bounds')
    subplot(321);errorbar(iterations, params(13,:),par_std(13,:));ylabel('dCm_ds_elevatorNdeci');          xlabel('iteration #');grid
    subplot(322);errorbar(iterations, params(14,:),par_std(14,:));ylabel('Cm_elevator0');         xlabel('iteration #');grid
    subplot(323);errorbar(iterations, params(15,:),par_std(15,:));ylabel('Cm_elevatorPdeci');         xlabel('iteration #');grid
    subplot(324);errorbar(iterations, params(16,:),par_std(16,:));ylabel('Cm_elevatorNdeci');    xlabel('iteration #');grid
    subplot(325);errorbar(iterations, params(17,:),par_std(17,:));ylabel('Cm_lef');    xlabel('iteration #');grid
    subplot(326);errorbar(iterations, params(18,:),par_std(18,:));ylabel('Cm_q');   xlabel('iteration #');grid
    figure(10); zoom;
    title('Convergence of parameter estimates with error bounds')
    subplot(321);errorbar(iterations, params(19,:),par_std(19,:));ylabel('dCm_q_lef');   xlabel('iteration #');grid
    subplot(322);errorbar(iterations, params(20,:),par_std(20,:));ylabel('dCm_sb');          xlabel('iteration #');grid
    subplot(323);errorbar(iterations, params(21,:),par_std(21,:));ylabel('eta_elevator');          xlabel('iteration #');grid
    subplot(324);errorbar(iterations, params(22,:),par_std(22,:));ylabel('eta_elevatorPdeci');            xlabel('iteration #');grid
    subplot(325);errorbar(iterations, params(23,:),par_std(23,:));ylabel('eta_elevatorNdeci');       xlabel('iteration #');grid
    subplot(326);errorbar(iterations, params(24,:),par_std(24,:));ylabel('dCn_beta');             xlabel('iteration #');grid
    figure(11); zoom;
    title('Convergence of parameter estimates with error bounds')
    subplot(321);errorbar(iterations, params(25,:),par_std(25,:));ylabel('Cn_delta_ail');              xlabel('iteration #');grid
    subplot(322);errorbar(iterations, params(26,:),par_std(26,:));ylabel('Cn_delta_ail_lef');        xlabel('iteration #');grid
    subplot(323);errorbar(iterations, params(27,:),par_std(27,:));ylabel('Cn_delta_r');    xlabel('iteration #');grid
    subplot(324);errorbar(iterations, params(28,:),par_std(28,:));ylabel('Cn_p');    xlabel('iteration #');grid
    subplot(325);errorbar(iterations, params(29,:),par_std(29,:));ylabel('dCn_p_lef');          xlabel('iteration #');grid
    subplot(326);errorbar(iterations, params(30,:),par_std(30,:));ylabel('Cn_r');            xlabel('iteration #');grid
    figure(12); zoom;
    title('Convergence of parameter estimates with error bounds')
    subplot(321);errorbar(iterations, params(31,:),par_std(31,:));ylabel('dCn_r_lef');       xlabel('iteration #');grid
    subplot(322);errorbar(iterations, params(32,:),par_std(32,:));ylabel('CX');            xlabel('iteration #');grid
    subplot(323);errorbar(iterations, params(33,:),par_std(33,:));ylabel('CX_elevatorPdeci');       xlabel('iteration #');grid
    subplot(324);errorbar(iterations, params(34,:),par_std(34,:));ylabel('CX_elevatorNdeci');              xlabel('iteration #');grid
    subplot(325);errorbar(iterations, params(35,:),par_std(35,:));ylabel('CX_elevator0');             xlabel('iteration #');grid
    subplot(326);errorbar(iterations, params(36,:),par_std(36,:));ylabel('CX_lef');             xlabel('iteration #');grid
    figure(13); zoom;
    title('Convergence of parameter estimates with error bounds')
    subplot(321);errorbar(iterations, params(37,:),par_std(37,:));ylabel('CX_q');    xlabel('iteration #');grid
    subplot(322);errorbar(iterations, params(38,:),par_std(38,:));ylabel('CX_q_lef');          xlabel('iteration #');grid
    subplot(323);errorbar(iterations, params(39,:),par_std(39,:));ylabel('dCX_sb');            xlabel('iteration #');grid
    subplot(324);errorbar(iterations, params(40,:),par_std(40,:));ylabel('CY_delta_ail');          xlabel('iteration #');grid
    subplot(325);errorbar(iterations, params(41,:),par_std(41,:));ylabel('CY_delta_ail_lef');              xlabel('iteration #');grid
    subplot(326);errorbar(iterations, params(42,:),par_std(42,:));ylabel('CY_delta_r');    xlabel('iteration #');grid
    figure(14); zoom;
    title('Convergence of parameter estimates with error bounds')
    subplot(321);errorbar(iterations, params(43,:),par_std(43,:));ylabel('CY_p');      xlabel('iteration #');grid
    subplot(322);errorbar(iterations, params(44,:),par_std(44,:));ylabel('dCY_p_lef');          xlabel('iteration #');grid
    subplot(323);errorbar(iterations, params(45,:),par_std(45,:));ylabel('CY_r');            xlabel('iteration #');grid
    subplot(324);errorbar(iterations, params(46,:),par_std(46,:));ylabel('dCY_r_lef');       xlabel('iteration #');grid
    subplot(325);errorbar(iterations, params(47,:),par_std(47,:));ylabel('CZ');            xlabel('iteration #');grid
    subplot(326);errorbar(iterations, params(48,:),par_std(48,:));ylabel('CZ_elevator0');       xlabel('iteration #');grid
    figure(15); zoom;
    title('Convergence of parameter estimates with error bounds')
    subplot(321);errorbar(iterations, params(49,:),par_std(49,:));ylabel('CZ_elevatorPdeci');              xlabel('iteration #');grid
    subplot(322);errorbar(iterations, params(50,:),par_std(50,:));ylabel('CZ_elevatorNdeci');             xlabel('iteration #');grid
    subplot(323);errorbar(iterations, params(51,:),par_std(51,:));ylabel('CZ_lef');             xlabel('iteration #');grid
    subplot(324);errorbar(iterations, params(52,:),par_std(52,:));ylabel('CZ_q');    xlabel('iteration #');grid
    subplot(325);errorbar(iterations, params(53,:),par_std(53,:));ylabel('dCZ_q_lef');          xlabel('iteration #');grid
    subplot(326);errorbar(iterations, params(54,:),par_std(54,:));ylabel('dCZ_sb');            xlabel('iteration #');grid
    end