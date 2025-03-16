function t = plots_TC09_F16_lateral_different_simplify(T, Z, Y, Uinp, params, par_std, iter);
%% Plot time histories of measured and estimated observation variables
figure(1)
title('Time histories of output variables (measured and estimated); input variables')
subplot(8,1,1),plot(rad2deg(T,Z(:,1)), rad2deg(T,Y(:,1)),'r');  grid; ylabel('\beta ()');
subplot(8,1,2),plot(rad2deg(T,Z(:,2)), rad2deg(T,Y(:,2)),'r');  grid; ylabel('\phi ()');
subplot(8,1,3),plot(rad2deg(T,Z(:,3)), rad2deg(T,Y(:,3)),'r');  grid; ylabel('\psi ()');
subplot(8,1,4),plot(rad2deg(T,Z(:,4)), rad2deg(T,Y(:,4)),'r');  grid; ylabel('p (/s)');
subplot(8,1,5),plot(rad2deg(T,Z(:,5)), rad2deg(T,Y(:,5)),'r');  grid; ylabel('r (/s)');
subplot(8,1,6),plot(rad2deg(T,Z(:,6)), rad2deg(T,Y(:,6)),'r');  grid; ylabel('p_dot (/s2)');
subplot(8,1,7),plot(rad2deg(T,Z(:,7)), rad2deg(T,Y(:,7)),'r');  grid; ylabel('r_dot (/s2)');
subplot(8,1,8),plot(T,Z(:,8), T,Y(:,14),'r');                   grid; ylabel('ay (m/s2)');
xlabel('Time in sec');  
figure(2)
title('Time histories of output variables (measured and estimated); input variables')
subplot(8,1,1),plot(rad2deg(T,Uinp(:,1)));                      grid; ylabel('{\delta_re} ()');
subplot(8,1,2),plot(rad2deg(T,Uinp(:,2)));                      grid; ylabel('{\delta_le} ()');
subplot(8,1,3),plot(rad2deg(T,Uinp(:,3)));                      grid; ylabel('{\delta_ra ()');
subplot(8,1,4),plot(rad2deg(T,Uinp(:,4)));                      grid; ylabel('{\delta_la} ()');
subplot(8,1,5),plot(rad2deg(T,Uinp(:,5)));                      grid; ylabel('{\delta_r} ()');
subplot(8,1,6),plot(rad2deg(T,Uinp(:,6)));                      grid; ylabel('{\delta_ry} ()');
subplot(8,1,7),plot(rad2deg(T,Uinp(:,7)));                      grid; ylabel('{\delta_rz} ()');
subplot(8,1,8),plot(rad2deg(T,Uinp(:,8)));                      grid; ylabel('{\delta_ly} ()');
xlabel('Time in sec');  

figure(3)
title('Time histories of output variables (measured and estimated); input variables')
subplot(8,1,1),plot(rad2deg(T,Uinp(:,9)));                      grid; ylabel('{\delta_lz} ()');
subplot(8,1,2),plot(rad2deg(T,Uinp(:,10)));                     grid; ylabel('{\delta_lef} ()');
subplot(8,1,3),plot(rad2deg(T,Uinp(:,11)));                     grid; ylabel('{\delta_sb} ()');
subplot(8,1,4),plot(rad2deg(T,Uinp(:,12)));                     grid; ylabel('{Tx} ()');
subplot(8,1,5),plot(T,Uinp(:,13));                              grid; ylabel('{Ty} ()');
subplot(8,1,6),plot(T,Uinp(:,14));                              grid; ylabel('{Tz} ()');
subplot(8,1,7),plot(T,Uinp(:,15));                              grid; ylabel('{qbar} ()');
subplot(8,1,8),plot(T,Uinp(:,16));                              grid; ylabel('{N} ()');
xlabel('Time in sec');  

figure(4)
title('Time histories of output variables (measured and estimated); input variables')
subplot(8,1,1),plot(T,Uinp(:,17));                              grid; ylabel('{f} ()');
subplot(8,1,2),plot(T,Uinp(:,18));                              grid; ylabel('{Vt} ()');
subplot(8,1,3),plot(T,Uinp(:,19));                              grid; ylabel('{alpha} ()');
subplot(8,1,4),plot(T,Uinp(:,20));                              grid; ylabel('{theta} ()');
subplot(8,1,5),plot(T,Uinp(:,21));                              grid; ylabel('{q} ()');
subplot(8,1,6),plot(T,Uinp(:,22));                              grid; ylabel('{mu} ()');
subplot(8,1,7),plot(T,Uinp(:,23));                              grid; ylabel('{chi} ()');
subplot(8,1,8),plot(T,Uinp(:,24));                              grid; ylabel('{gamma} ()');
xlabel('Time in sec');  

%% Convergence plot: estimated parameter +- standard deviations versus iteration count
if  iter > 0 
    iterations = (0:iter);
    figure(5); zoom;
    title('Convergence of parameter estimates with error bounds')
    subplot(321);errorbar(iterations, params(1,:),par_std(1,:));ylabel('Cl');                xlabel('iteration #');grid
    subplot(322);errorbar(iterations, params(2,:),par_std(2,:));ylabel('dCl_beta');          xlabel('iteration #');grid
    subplot(323);errorbar(iterations, params(3,:),par_std(3,:));ylabel('Cl_delta_ail');      xlabel('iteration #');grid
    subplot(324);errorbar(iterations, params(4,:),par_std(4,:));ylabel('Cl_delta_ail_lef');  xlabel('iteration #');grid
    subplot(325);errorbar(iterations, params(5,:),par_std(5,:));ylabel('Cl_delta_r');        xlabel('iteration #');grid
    subplot(326);errorbar(iterations, params(6,:),par_std(6,:));ylabel('Cl_elevator0}');     xlabel('iteration #');grid
    figure(6); zoom;
    title('Convergence of parameter estimates with error bounds')
    subplot(321);errorbar(iterations, params(7,:),par_std(7,:));ylabel('Cl_lef');            xlabel('iteration #');grid
    subplot(322);errorbar(iterations, params(8,:),par_std(8,:));ylabel('Cl_p');              xlabel('iteration #');grid
    subplot(323);errorbar(iterations, params(9,:),par_std(9,:));ylabel('dCl_p_lef');         xlabel('iteration #');grid
    subplot(324);errorbar(iterations, params(10,:),par_std(10,:));ylabel('Cl_r');            xlabel('iteration #');grid
    subplot(325);errorbar(iterations, params(11,:),par_std(11,:));ylabel('dCl_r_lef');       xlabel('iteration #');grid
    subplot(326);errorbar(iterations, params(12,:),par_std(12,:));ylabel('Cn');              xlabel('iteration #');grid
    figure(7); zoom;
    title('Convergence of parameter estimates with error bounds')
    subplot(321);errorbar(iterations, params(13,:),par_std(13,:));ylabel('dCn_beta');        xlabel('iteration #');grid
    subplot(322);errorbar(iterations, params(14,:),par_std(14,:));ylabel('Cn_delta_ail');    xlabel('iteration #');grid
    subplot(323);errorbar(iterations, params(15,:),par_std(15,:));ylabel('Cn_delta_ail_lef');xlabel('iteration #');grid
    subplot(324);errorbar(iterations, params(16,:),par_std(16,:));ylabel('Cn_delta_r');      xlabel('iteration #');grid
    subplot(325);errorbar(iterations, params(17,:),par_std(17,:));ylabel('Cn_elevator0');    xlabel('iteration #');grid
    subplot(326);errorbar(iterations, params(18,:),par_std(18,:));ylabel('Cn_lef');          xlabel('iteration #');grid
    figure(8); zoom;
    title('Convergence of parameter estimates with error bounds')
    subplot(321);errorbar(iterations, params(19,:),par_std(19,:));ylabel('Cn_p');            xlabel('iteration #');grid
    subplot(322);errorbar(iterations, params(20,:),par_std(20,:));ylabel('dCn_p_lef');       xlabel('iteration #');grid
    subplot(323);errorbar(iterations, params(21,:),par_std(21,:));ylabel('Cn_r');            xlabel('iteration #');grid
    subplot(324);errorbar(iterations, params(22,:),par_std(22,:));ylabel('dCn_r_lef');       xlabel('iteration #');grid
    subplot(325);errorbar(iterations, params(23,:),par_std(23,:));ylabel('CX');              xlabel('iteration #');grid
    subplot(326);errorbar(iterations, params(24,:),par_std(24,:));ylabel('CX_delta_ra');             xlabel('iteration #');grid
    figure(9); zoom;
    title('Convergence of parameter estimates with error bounds')
    subplot(321);errorbar(iterations, params(25,:),par_std(25,:));ylabel('CX_delta_la');              xlabel('iteration #');grid
    subplot(322);errorbar(iterations, params(26,:),par_std(26,:));ylabel('CX_elevator0');     xlabel('iteration #');grid
    subplot(323);errorbar(iterations, params(27,:),par_std(27,:));ylabel('CX_lef');           xlabel('iteration #');grid
    subplot(324);errorbar(iterations, params(28,:),par_std(28,:));ylabel('CX_q');             xlabel('iteration #');grid
    subplot(325);errorbar(iterations, params(29,:),par_std(29,:));ylabel('CX_q_lef');         xlabel('iteration #');grid
    subplot(326);errorbar(iterations, params(30,:),par_std(30,:));ylabel('dCX_sb');           xlabel('iteration #');grid
    figure(10); zoom;
    title('Convergence of parameter estimates with error bounds')
    subplot(321);errorbar(iterations, params(31,:),par_std(31,:));ylabel('CY');               xlabel('iteration #');grid
    subplot(322);errorbar(iterations, params(32,:),par_std(32,:));ylabel('CY_delta_ail');     xlabel('iteration #');grid
    subplot(323);errorbar(iterations, params(33,:),par_std(33,:));ylabel('CY_delta_ail_lef'); xlabel('iteration #');grid
    subplot(324);errorbar(iterations, params(34,:),par_std(34,:));ylabel('CY_delta_r');       xlabel('iteration #');grid
    subplot(325);errorbar(iterations, params(35,:),par_std(35,:));ylabel('CY_lef');           xlabel('iteration #');grid
    subplot(326);errorbar(iterations, params(36,:),par_std(36,:));ylabel('CY_p');             xlabel('iteration #');grid
    figure(11); zoom;
    title('Convergence of parameter estimates with error bounds')
    subplot(321);errorbar(iterations, params(37,:),par_std(37,:));ylabel('dCY_p_lef');        xlabel('iteration #');grid
    subplot(322);errorbar(iterations, params(38,:),par_std(38,:));ylabel('CY_r');             xlabel('iteration #');grid
    subplot(323);errorbar(iterations, params(39,:),par_std(39,:));ylabel('dCY_r_lef');        xlabel('iteration #');grid
    subplot(324);errorbar(iterations, params(40,:),par_std(40,:));ylabel('CZ');               xlabel('iteration #');grid
    subplot(325);errorbar(iterations, params(41,:),par_std(41,:));ylabel('CZ_delta_ra');              xlabel('iteration #');grid
    subplot(326);errorbar(iterations, params(42,:),par_std(42,:));ylabel('CZ_delta_la');              xlabel('iteration #');grid
    figure(12); zoom;
    title('Convergence of parameter estimates with error bounds')
    subplot(321);errorbar(iterations, params(43,:),par_std(43,:));ylabel('CZ_elevator0');     xlabel('iteration #');grid
    subplot(322);errorbar(iterations, params(44,:),par_std(44,:));ylabel('CZ_lef');           xlabel('iteration #');grid
    subplot(323);errorbar(iterations, params(45,:),par_std(45,:));ylabel('CZ_q');             xlabel('iteration #');grid
    subplot(324);errorbar(iterations, params(46,:),par_std(46,:));ylabel('dCZ_q_lef');        xlabel('iteration #');grid
    subplot(325);errorbar(iterations, params(47,:),par_std(47,:));ylabel('dCZ_sb');           xlabel('iteration #');grid
end
