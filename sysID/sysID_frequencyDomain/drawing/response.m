FontSize = 20;
switch test_case
    case 'sysID_longitudinal' % 2x4        
        switch true_case
            case 'true'
                %Plot the resulting linearization 修正後頻率響應圖與 true(黑線) 的比較
                linsys = linsys1;

                % 注意：
                % 對於 MIMO 系統，bode()指令輸出的 mag 和 phase(deg) 是 3-D array，其維度(dimensions)為（輸出個數）×（輸入個數）×（頻率點個數）。注意：第一個維度是「輸出」。
                % 例如：phase(i,j,k) 是指從第 j 個輸入到第 i 個輸出，在第 k 個頻率點上的相位角。
                [mag,phase,wout] = bode(linsys);             % mag = 2x2x70                        , phase = 2x2x70                         , wout = 70x1
                % mag = 輸出個數 × 輸入個數 × 頻率點個數, phase = 輸出個數 × 輸入個數 × 頻率點個數, wout = 頻率點個數x1

                % 註：可以自行指定頻率點個數、頻率範圍
                % w = logspace(0,1,20);
                % [mag,phase,wout] = bode(H,w);


                mag_new{1,1}   = squeeze(mag(1,1,:));
                mag_new{2,1}   = squeeze(mag(2,1,:));
                mag_new{3,1}   = squeeze(mag(3,1,:));
                mag_new{4,1}   = squeeze(mag(4,1,:));
                mag_new{1,2}   = squeeze(mag(1,2,:));                
                mag_new{2,2}   = squeeze(mag(2,2,:));
                mag_new{3,2}   = squeeze(mag(3,2,:));
                mag_new{4,2}   = squeeze(mag(4,2,:));

                phase_new{1,1} = squeeze(phase(1,1,:));
                phase_new{2,1} = squeeze(phase(2,1,:));
                phase_new{3,1} = squeeze(phase(3,1,:));
                phase_new{4,1} = squeeze(phase(4,1,:));
                phase_new{1,2} = squeeze(phase(1,2,:));
                phase_new{2,2} = squeeze(phase(2,2,:));
                phase_new{3,2} = squeeze(phase(3,2,:));
                phase_new{4,2} = squeeze(phase(4,2,:));

                phase_new{2,1} = phase_new{2,1}-360;
                phase_new{3,1} = phase_new{3,1}-360;
                phase_new{2,2} = phase_new{2,2}-360;
                phase_new{3,2} = phase_new{3,2}-360;
                
                disp('---------------------')
                disp('     u1 --> y1')
                disp('---------------------')
                [Gm,Pm,Wcg,Wcp] = margin(mag_new{1,1},phase_new{1,1},wout);
                fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
                fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
                disp('---------------------')
                disp('     u2 --> y1')
                disp('---------------------')
                [Gm,Pm,Wcg,Wcp] = margin(mag_new{1,2},phase_new{1,2},wout);
                fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
                fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
                disp('---------------------')
                disp('     u1 --> y2')
                disp('---------------------')
                [Gm,Pm,Wcg,Wcp] = margin(mag_new{2,1},phase_new{2,1},wout);
                fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
                fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
                disp('---------------------')
                disp('     u2 --> y2')
                disp('---------------------')
                [Gm,Pm,Wcg,Wcp] = margin(mag_new{2,2},phase_new{2,2},wout);
                fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
                fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
                disp('---------------------')
                disp('     u1 --> y3')
                disp('---------------------')
                [Gm,Pm,Wcg,Wcp] = margin(mag_new{3,1},phase_new{3,1},wout);
                fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
                fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
                disp('---------------------')
                disp('     u2 --> y3')
                disp('---------------------')
                [Gm,Pm,Wcg,Wcp] = margin(mag_new{3,2},phase_new{3,2},wout);
                fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
                fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
                disp('---------------------')
                disp('     u1 --> y4')
                disp('---------------------')
                [Gm,Pm,Wcg,Wcp] = margin(mag_new{4,1},phase_new{4,1},wout);
                fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
                fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
                disp('---------------------')
                disp('     u2 --> y4')
                disp('---------------------')
                [Gm,Pm,Wcg,Wcp] = margin(mag_new{4,2},phase_new{4,2},wout);
                fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
                fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
%% 
        figure('units','normalized','outerposition',[0 0 1 1])
        % set(gcf,'Position',get(0,'ScreenSize'))

        set(gcf,'WindowState','maximized');
        % 'TileSpacing','Compact' 最小化繪圖之間的空間。'Padding','Compact' 最小化佈局周圍的空間
        t = tiledlayout(4,2,'TileSpacing','Compact','Padding','Compact');
        w1rad = w1*2*pi;
        w2rad = w2*2*pi;

        ax1 = nexttile; % u1 --> y1 振幅(dB)
        semilogx(w1rad,mag2db(abs(H11w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(wout,mag2db(squeeze(mag(1,1,:))),'k')
        semilogx(w2rad,mag2db(abs(H11w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        title('\delta_e','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax1,'Fontsize',20);

        ax2 = nexttile; % u2 --> y1 振幅(dB)
        semilogx(w1rad,mag2db(abs(H12w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(wout,mag2db(squeeze(mag(1,2,:))),'k')
        semilogx(w2rad,mag2db(abs(H12w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        title('\delta_y','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax2,'Fontsize',20);

        ax3 = nexttile; % u1 --> y1 相位角(deg)
        semilogx(w1rad,rad2deg(H11w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(wout,squeeze(phase(1,1,:)),'k')
        semilogx(w2rad,rad2deg(H11w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax3,'Fontsize',20);

        ax4 = nexttile; % u2 --> y1 相位角(deg)
        semilogx(w1rad,rad2deg(H12w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(wout,squeeze(phase(1,2,:)),'k')
        semilogx(w2rad,rad2deg(H12w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        % xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax4,'Fontsize',20);

        ax5 = nexttile; % u1 --> y2 振幅(dB)
        semilogx(w1rad,mag2db(abs(H21w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(wout,mag2db(squeeze(mag(2,1,:))),'k')
        semilogx(w2rad,mag2db(abs(H21w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        % title('Bode Diagram','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax5,'Fontsize',20);

        ax6 = nexttile; % u2 --> y2 振幅(dB)
        semilogx(w1rad,mag2db(abs(H22w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(wout,mag2db(squeeze(mag(2,2,:))),'k')
        semilogx(w2rad,mag2db(abs(H22w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        xlim([min(w1rad) max(w2rad)])
        set(ax6,'Fontsize',20);

        ax7 = nexttile; % u1 --> y2 相位角(deg)
        semilogx(w1rad,rad2deg(H21w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(wout,phase_new{2,1},'k')
        semilogx(w2rad,rad2deg(H21w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax7,'Fontsize',20);

        ax8 = nexttile; % u2 --> y2 相位角(deg)
        semilogx(w1rad,rad2deg(H22w2_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H22w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(wout,phase_new{2,2},'k')
        xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax8,'Fontsize',20);

        t.YLabel.String = '\ita_z                                                      \alpha';
        t.YLabel.FontSize = 20;
        t.YLabel.FontWeight = 'bold';
        xticklabels(ax1,{})
        xticklabels(ax2,{})
        xticklabels(ax3,{})
        xticklabels(ax4,{})
        xticklabels(ax5,{})
        xticklabels(ax6,{})
        legend('sysID \omega_1','sysID \omega_2','Linearized')


        % --------------------------------------------------------------------------------
        figure('units','normalized','outerposition',[0 0 1 1])
        % set(gcf,'Position',get(0,'ScreenSize'))

        set(gcf,'WindowState','maximized');
        % 'TileSpacing','Compact' 最小化繪圖之間的空間。'Padding','Compact' 最小化佈局周圍的空間
        t = tiledlayout(4,2,'TileSpacing','Compact','Padding','Compact');
        w1rad = w1*2*pi;
        w2rad = w2*2*pi;

        ax1 = nexttile; % u1 --> y3 振幅(dB)
        semilogx(w1rad,mag2db(abs(H31w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(wout,mag2db(squeeze(mag(3,1,:))),'k')
        semilogx(w2rad,mag2db(abs(H31w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        title('\delta_e','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax1,'Fontsize',20);

        ax2 = nexttile; % u2 --> y3 振幅(dB)
        semilogx(w1rad,mag2db(abs(H32w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(wout,mag2db(squeeze(mag(3,2,:))),'k')
        semilogx(w2rad,mag2db(abs(H32w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        title('\delta_y','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax2,'Fontsize',20);

        ax3 = nexttile; % u1 --> y3 相位角(deg)
        semilogx(w1rad,rad2deg(H31w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(wout,phase_new{3,1},'k')
        semilogx(w2rad,rad2deg(H31w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax3,'Fontsize',20);

        ax4 = nexttile; % u2 --> y3 相位角(deg)
        semilogx(w1rad,rad2deg(H32w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(wout,phase_new{3,2},'k')
        semilogx(w2rad,rad2deg(H32w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        xlim([min(w1rad) max(w2rad)])
        set(ax4,'Fontsize',20);

        ax5 = nexttile; % u1 --> y4 振幅(dB)
        semilogx(w1rad,mag2db(abs(H41w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(wout,mag2db(squeeze(mag(4,1,:))),'k')
        semilogx(w2rad,mag2db(abs(H41w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        % title('Bode Diagram','FontWeight','bold','FontSize',FontSize)
        xlim([0.5 10])
        set(ax5,'Fontsize',20);

        ax6 = nexttile; % u2 --> y4 振幅(dB)
        semilogx(w1rad,mag2db(abs(H42w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(wout,mag2db(squeeze(mag(4,2,:))),'k')
        semilogx(w2rad,mag2db(abs(H42w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        xlim([min(w1rad) max(w2rad)])
        set(ax6,'Fontsize',20);

        ax7 = nexttile; % u1 --> y4 相位角(deg)
        semilogx(w1rad,rad2deg(H41w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(wout,squeeze(phase(4,1,:)),'k')
        semilogx(w2rad,rad2deg(H41w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax7,'Fontsize',20);

        ax8 = nexttile; % u2 --> y4 相位角(deg)
        p1 = semilogx(w1rad,rad2deg(H42w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        p2 = semilogx(w2rad,rad2deg(H42w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        p3 = semilogx(wout,squeeze(phase(4,2,:)),'k');
        xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax8,'Fontsize',20);

        t.YLabel.String = '\theta                                                      \itq';
        t.YLabel.FontSize = 20;
        t.YLabel.FontWeight = 'bold';

        xticklabels(ax1,{})
        xticklabels(ax2,{})
        xticklabels(ax3,{})
        xticklabels(ax4,{})
        xticklabels(ax5,{})
        xticklabels(ax6,{})
        legend('sysID \omega_1','sysID \omega_2','Linearized')

            case 'untrue'
                figure('units','normalized','outerposition',[0 0 1 1])
        % set(gcf,'Position',get(0,'ScreenSize'))

        set(gcf,'WindowState','maximized');
        % 'TileSpacing','Compact' 最小化繪圖之間的空間。'Padding','Compact' 最小化佈局周圍的空間
        t = tiledlayout(4,2,'TileSpacing','Compact','Padding','Compact');
        w1rad = w1*2*pi;
        w2rad = w2*2*pi;

        ax1 = nexttile; % u1 --> y1 振幅(dB)
        semilogx(w1rad,mag2db(abs(H11w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H11w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        title('u1','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax1,'Fontsize',20);

        ax2 = nexttile; % u2 --> y1 振幅(dB)
        semilogx(w1rad,mag2db(abs(H12w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H12w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        title('u2','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax2,'Fontsize',20);

        ax3 = nexttile; % u1 --> y1 相位角(deg)
        semilogx(w1rad,rad2deg(H11w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H11w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax3,'Fontsize',20);

        ax4 = nexttile; % u2 --> y1 相位角(deg)
        semilogx(w1rad,rad2deg(H12w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H12w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        % xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax4,'Fontsize',20);

        ax5 = nexttile; % u1 --> y2 振幅(dB)
        semilogx(w1rad,mag2db(abs(H21w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H21w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        % title('Bode Diagram','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax5,'Fontsize',20);

        ax6 = nexttile; % u2 --> y2 振幅(dB)
        semilogx(w1rad,mag2db(abs(H22w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H22w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        % title('Bode Diagram','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax6,'Fontsize',20);

        ax7 = nexttile; % u1 --> y2 相位角(deg)
        semilogx(w1rad,rad2deg(H21w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H21w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax7,'Fontsize',20);

        ax8 = nexttile; % u2 --> y2 相位角(deg)
        semilogx(w1rad,rad2deg(H22w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H22w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax8,'Fontsize',20);
        legend
        % --------------------------------------------------------------------------------
        figure('units','normalized','outerposition',[0 0 1 1])
        % set(gcf,'Position',get(0,'ScreenSize'))

        set(gcf,'WindowState','maximized');
        % 'TileSpacing','Compact' 最小化繪圖之間的空間。'Padding','Compact' 最小化佈局周圍的空間
        t = tiledlayout(4,2,'TileSpacing','Compact','Padding','Compact');
        w1rad = w1*2*pi;
        w2rad = w2*2*pi;

        ax1 = nexttile; % u1 --> y3 振幅(dB)
        semilogx(w1rad,mag2db(abs(H31w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H31w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        title('u1','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax1,'Fontsize',20);

        ax2 = nexttile; % u2 --> y3 振幅(dB)
        semilogx(w1rad,mag2db(abs(H32w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H32w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        title('u2','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax2,'Fontsize',20);

        ax3 = nexttile; % u1 --> y3 相位角(deg)
        semilogx(w1rad,rad2deg(H31w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H31w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax3,'Fontsize',20);

        ax4 = nexttile; % u2 --> y3 相位角(deg)
        semilogx(w1rad,rad2deg(H32w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H32w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax4,'Fontsize',20);

        ax5 = nexttile; % u1 --> y4 振幅(dB)
        semilogx(w1rad,mag2db(abs(H41w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H41w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        % title('Bode Diagram','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax5,'Fontsize',20);

        ax6 = nexttile; % u2 --> y4 振幅(dB)
        semilogx(w1rad,mag2db(abs(H42w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H42w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        % title('Bode Diagram','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax6,'Fontsize',20);

        ax7 = nexttile; % u1 --> y4 相位角(deg)
        semilogx(w1rad,rad2deg(H41w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H41w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax7,'Fontsize',20);

        ax8 = nexttile; % u2 --> y4 相位角(deg)
        semilogx(w1rad,rad2deg(H42w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H42w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax8,'Fontsize',20);
        legend
        end
% ------------------------------------------------------------------------------------------
%                                     sysID_lateral
% ------------------------------------------------------------------------------------------
    case 'sysID_lateral' % 3x5
        switch true_case
            case 'true'
                % Plot the resulting linearization 修正後頻率響應圖與 true(黑線) 的比較
                % load('D:\NDI\sysID\sysID_frequencyDomain\NDI_True_TVC2_h10000V617alpha2.mat')
                FontSize = 11;
                linsys = linsys1;

                % 注意：
                % 對於 MIMO 系統，bode()指令輸出的 mag 和 phase(deg) 是 3-D array，其維度(dimensions)為（輸出個數）×（輸入個數）×（頻率點個數）。注意：第一個維度是「輸出」。
                % 例如：phase(i,j,k) 是指從第 j 個輸入到第 i 個輸出，在第 k 個頻率點上的相位角。
                [mag,phase,wout] = bode(linsys);             % mag = 2x2x70                        , phase = 2x2x70                         , wout = 70x1
                % mag = 輸出個數 × 輸入個數 × 頻率點個數, phase = 輸出個數 × 輸入個數 × 頻率點個數, wout = 頻率點個數x1

                % 註：可以自行指定頻率點個數、頻率範圍
                % w = logspace(0,1,20);
                % [mag,phase,wout] = bode(H,w);


                mag_new{1,1}   = squeeze(mag(1,1,:));
                mag_new{1,2}   = squeeze(mag(1,2,:));
                mag_new{1,3}   = squeeze(mag(1,3,:));
                mag_new{2,1}   = squeeze(mag(2,1,:));
                mag_new{2,2}   = squeeze(mag(2,2,:));
                mag_new{2,3}   = squeeze(mag(2,3,:));
                mag_new{3,1}   = squeeze(mag(3,1,:));
                mag_new{3,2}   = squeeze(mag(3,2,:));
                mag_new{3,3}   = squeeze(mag(3,3,:));
                mag_new{4,1}   = squeeze(mag(4,1,:));
                mag_new{4,2}   = squeeze(mag(4,2,:));
                mag_new{4,3}   = squeeze(mag(4,3,:));
                mag_new{5,1}   = squeeze(mag(5,1,:));
                mag_new{5,2}   = squeeze(mag(5,2,:));
                mag_new{5,3}   = squeeze(mag(5,3,:));

                phase_new{1,1}   = squeeze(phase(1,1,:));
                phase_new{1,2}   = squeeze(phase(1,2,:));
                phase_new{1,3}   = squeeze(phase(1,3,:));
                phase_new{2,1}   = squeeze(phase(2,1,:));
                phase_new{2,2}   = squeeze(phase(2,2,:));
                phase_new{2,3}   = squeeze(phase(2,3,:));
                phase_new{3,1}   = squeeze(phase(3,1,:));
                phase_new{3,2}   = squeeze(phase(3,2,:));
                phase_new{3,3}   = squeeze(phase(3,3,:));
                phase_new{4,1}   = squeeze(phase(4,1,:));
                phase_new{4,2}   = squeeze(phase(4,2,:));
                phase_new{4,3}   = squeeze(phase(4,3,:));
                phase_new{5,1}   = squeeze(phase(5,1,:));
                phase_new{5,2}   = squeeze(phase(5,2,:));
                phase_new{5,3}   = squeeze(phase(5,3,:));

                 phase_new{1,1} = phase_new{1,1}-360;
                 phase_new{5,2} = phase_new{5,2}-360;
                 phase_new{5,3} = phase_new{5,3}-360;
                disp('---------------------')
                disp('     u1 --> y1')
                disp('---------------------')
                [Gm,Pm,Wcg,Wcp] = margin(mag_new{1,1},phase_new{1,1},wout);
                fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
                fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
                disp('---------------------')
                disp('     u2 --> y1')
                disp('---------------------')
                [Gm,Pm,Wcg,Wcp] = margin(mag_new{1,2},phase_new{1,2},wout);
                fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
                fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
                disp('---------------------')
                disp('     u3 --> y1')
                disp('---------------------')
                [Gm,Pm,Wcg,Wcp] = margin(mag_new{1,3},phase_new{1,3},wout);
                fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
                fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
                disp('---------------------')
                disp('     u1 --> y2')
                disp('---------------------')
                [Gm,Pm,Wcg,Wcp] = margin(mag_new{2,1},phase_new{2,1},wout);
                fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
                fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
                disp('---------------------')
                disp('     u2 --> y2')
                disp('---------------------')
                [Gm,Pm,Wcg,Wcp] = margin(mag_new{2,2},phase_new{2,2},wout);
                fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
                fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
                disp('---------------------')
                disp('     u3 --> y2')
                disp('---------------------')
                [Gm,Pm,Wcg,Wcp] = margin(mag_new{2,3},phase_new{2,3},wout);
                fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
                fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
                disp('---------------------')
                disp('     u1 --> y3')
                disp('---------------------')
                [Gm,Pm,Wcg,Wcp] = margin(mag_new{3,1},phase_new{3,1},wout);
                fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
                fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
                disp('---------------------')
                disp('     u2 --> y3')
                disp('---------------------')
                [Gm,Pm,Wcg,Wcp] = margin(mag_new{3,2},phase_new{3,2},wout);
                fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
                fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
                disp('---------------------')
                disp('     u3 --> y3')
                disp('---------------------')
                [Gm,Pm,Wcg,Wcp] = margin(mag_new{3,3},phase_new{3,3},wout);
                fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
                fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
                disp('---------------------')
                disp('     u1 --> y4')
                disp('---------------------')
                [Gm,Pm,Wcg,Wcp] = margin(mag_new{4,1},phase_new{4,1},wout);
                fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
                fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
                disp('---------------------')
                disp('     u2 --> y4')
                disp('---------------------')
                [Gm,Pm,Wcg,Wcp] = margin(mag_new{4,2},phase_new{4,2},wout);
                fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
                fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
                disp('---------------------')
                disp('     u3 --> y4')
                disp('---------------------')
                [Gm,Pm,Wcg,Wcp] = margin(mag_new{4,3},phase_new{4,3},wout);
                fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
                fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
                disp('---------------------')
                disp('     u1 --> y5')
                disp('---------------------')
                [Gm,Pm,Wcg,Wcp] = margin(mag_new{5,1},phase_new{5,1},wout);
                fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
                fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
                disp('---------------------')
                disp('     u2 --> y5')
                disp('---------------------')
                [Gm,Pm,Wcg,Wcp] = margin(mag_new{5,2},phase_new{5,2},wout);
                fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
                fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)
                disp('---------------------')
                disp('     u3 --> y5')
                disp('---------------------')
                [Gm,Pm,Wcg,Wcp] = margin(mag_new{5,3},phase_new{5,3},wout);
                fprintf('Gm = %f (dB)\t\t W = %f (rad/s)\n',mag2db(Gm),Wcg)
                fprintf('Pm = %f (deg)\t\t W = %f(rad/s)\n',Pm,Wcp)

                h1 = figure('units','normalized','outerposition',[0 0 1 1]);
                set(gcf,'WindowState','maximized');
                % 'TileSpacing','Compact' 最小化繪圖之間的空間。'Padding','Compact' 最小化佈局周圍的空間
                t = tiledlayout(4,3,'TileSpacing','Compact','Padding','Compact');
                w1rad = w1*2*pi;
                w2rad = w2*2*pi;
                w3rad = w3*2*pi;
           

                ax1 = nexttile; % u1 --> y1 振幅(dB)
                semilogx(w1rad,mag2db(abs(H11w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,mag2db(abs(H11w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,mag2db(abs(H11w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,mag2db(squeeze(mag(1,1,:))),'k')
                ylabel('Mag. (dB)','FontSize',FontSize)
                title('\delta_a','FontWeight','bold','FontSize',FontSize)
                xlim([min(w1rad) max(w3rad)])
                set(ax1,'Fontsize',20);

                ax2 = nexttile; % u2 --> y1 振幅(dB)
                semilogx(w1rad,mag2db(abs(H12w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,mag2db(abs(H12w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,mag2db(abs(H12w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,mag2db(squeeze(mag(1,2,:))),'k')
%                 ylabel('Mag. (dB)','FontSize',FontSize)
                title('\delta_r','FontWeight','bold','FontSize',FontSize)
                xlim([min(w1rad) max(w3rad)])
                set(ax2,'Fontsize',20);

                ax3 = nexttile; % u3 --> y1 振幅(dB)
                semilogx(w1rad,mag2db(abs(H13w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,mag2db(abs(H13w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,mag2db(abs(H13w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,mag2db(squeeze(mag(1,3,:))),'k')
%                 ylabel('Mag. (dB)','FontSize',FontSize)
                title('\delta_z','FontWeight','bold','FontSize',FontSize)
                xlim([min(w1rad) max(w3rad)])
                set(ax3,'Fontsize',20);

                ax4 = nexttile; % u1 --> y1 相位角(deg)
                semilogx(w1rad,rad2deg(H11w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,rad2deg(H11w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,rad2deg(H11w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,phase_new{1,1},'k')
                ylabel('Phase (deg)','FontSize',FontSize)
                xlim([min(w1rad) max(w3rad)])
                set(ax4,'Fontsize',20);

                ax5 = nexttile; % u2 --> y1 相位角(deg)
                semilogx(w1rad,rad2deg(H12w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,rad2deg(H12w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,rad2deg(H12w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,squeeze(phase(1,2,:)),'k')
%                 ylabel('Phase (deg)','FontSize',FontSize)
                xlim([min(w1rad) max(w3rad)])
                set(ax5,'Fontsize',20);

                ax6 = nexttile; % u3 --> y1 相位角(deg)
                semilogx(w1rad,rad2deg(H13w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,rad2deg(H13w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,rad2deg(H13w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,squeeze(phase(1,3,:)),'k')
%                 ylabel('Phase (deg)','FontSize',FontSize)
                xlim([min(w1rad) max(w3rad)])
                set(ax6,'Fontsize',20);

                ax7 = nexttile; % u1 --> y2 振幅(dB)
                semilogx(w1rad,mag2db(abs(H21w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,mag2db(abs(H21w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,mag2db(abs(H21w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,mag2db(squeeze(mag(2,1,:))),'k')
                ylabel('Mag. (dB)','FontSize',FontSize)
                xlim([min(w1rad) max(w3rad)])
                set(ax7,'Fontsize',20);

                ax8 = nexttile; % u2 --> y2 振幅(dB)
                semilogx(w1rad,mag2db(abs(H22w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,mag2db(abs(H22w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,mag2db(abs(H22w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,mag2db(squeeze(mag(2,2,:))),'k')
%                 ylabel('Mag. (dB)','FontSize',FontSize)
                xlim([min(w1rad) max(w3rad)])
                set(ax8,'Fontsize',20);

                ax9 = nexttile; % u3 --> y2 振幅(dB)
                semilogx(w1rad,mag2db(abs(H23w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,mag2db(abs(H23w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,mag2db(abs(H23w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,mag2db(squeeze(mag(2,3,:))),'k')
%                 ylabel('Mag. (dB)','FontSize',FontSize)
                xlim([min(w1rad) max(w3rad)])
                set(ax9,'Fontsize',20);

                ax10 = nexttile; % u1 --> y2 相位角(deg))
                semilogx(w1rad,rad2deg(H21w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,rad2deg(H21w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,rad2deg(H21w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,squeeze(phase(2,1,:)),'k')
                ylabel('Phase (deg)','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax10,'Fontsize',20);
                xlabel('Frequency (rad/s)','FontSize',20)

                ax11 = nexttile; % u2 --> y2 相位角(deg)
                semilogx(w1rad,rad2deg(H22w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,rad2deg(H22w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,rad2deg(H22w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,squeeze(phase(2,2,:)),'k')
%                 ylabel('Phase (deg)','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax11,'Fontsize',20);
                xlabel('Frequency (rad/s)','FontSize',20)

                ax12 = nexttile; % u3 --> y2 相位角(deg)
                semilogx(w1rad,rad2deg(H23w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,rad2deg(H23w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,rad2deg(H23w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,squeeze(phase(2,3,:)),'k')
%                 ylabel('Phase (deg)','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax12,'Fontsize',20);
                xlabel('Frequency (rad/s)','FontSize',20)

                xticklabels(ax1,{})
                xticklabels(ax2,{})
                xticklabels(ax3,{})
                xticklabels(ax4,{})
                xticklabels(ax5,{})
                xticklabels(ax6,{})
                xticklabels(ax7,{})
                xticklabels(ax8,{})
                xticklabels(ax9,{})

                t.YLabel.String = '\itp                                                      \beta';
                t.YLabel.FontSize = 20;
                t.YLabel.FontWeight = 'bold';

        legend('sysID \omega_1','sysID \omega_2','sysID \omega_3','Linearized')

                % ---------------------------------------------
                figure('units','normalized','outerposition',[0 0 1 1])
                set(gcf,'WindowState','maximized');
                % 'TileSpacing','Compact' 最小化繪圖之間的空間。'Padding','Compact' 最小化佈局周圍的空間
                t = tiledlayout(4,3,'TileSpacing','Compact','Padding','Compact');
                ax1 = nexttile; % u1 --> y3 振幅(dB)
                semilogx(w1rad,mag2db(abs(H31w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,mag2db(abs(H31w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,mag2db(abs(H31w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,mag2db(squeeze(mag(3,1,:))),'k')
                ylabel('Mag. (dB)','FontSize',20)
                title('\delta_a','FontWeight','bold','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax1,'Fontsize',20);

                ax2 = nexttile; % u2 --> y3 振幅(dB)
                semilogx(w1rad,mag2db(abs(H32w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,mag2db(abs(H32w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,mag2db(abs(H32w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,mag2db(squeeze(mag(3,2,:))),'k')
%                 ylabel('Mag. (dB)','FontSize',20)
                title('\delta_r','FontWeight','bold','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax2,'Fontsize',20);

                ax3 = nexttile; % u3 --> y3 振幅(dB)
                semilogx(w1rad,mag2db(abs(H33w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,mag2db(abs(H33w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,mag2db(abs(H33w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,mag2db(squeeze(mag(3,3,:))),'k')
%                 ylabel('Mag. (dB)','FontSize',20)
                title('\delta_z','FontWeight','bold','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax3,'Fontsize',20);

                ax4 = nexttile; % u1 --> y3 相位角(deg)
                semilogx(w1rad,rad2deg(H31w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,rad2deg(H31w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,rad2deg(H31w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,squeeze(phase(3,1,:)),'k')
                ylabel('Phase (deg)','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax4,'Fontsize',20);

                ax5 = nexttile; % u2 --> y3 相位角(deg)
                semilogx(w1rad,rad2deg(H32w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,rad2deg(H32w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,rad2deg(H32w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,squeeze(phase(3,2,:)),'k')
%                 ylabel('Phase (deg)','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax5,'Fontsize',20);

                ax6 = nexttile; % u3 --> y3 相位角(deg)
                semilogx(w1rad,rad2deg(H33w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,rad2deg(H33w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,rad2deg(H33w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,squeeze(phase(3,3,:)),'k')
%                 ylabel('Phase (deg)','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax6,'Fontsize',20);

                ax7 = nexttile; % u1 --> y4 振幅(dB)
                semilogx(w1rad,mag2db(abs(H41w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,mag2db(abs(H41w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,mag2db(abs(H41w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,mag2db(squeeze(mag(4,1,:))),'k')
                ylabel('Mag. (dB)','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax7,'Fontsize',20);

                ax8 = nexttile; % u2 --> y4 振幅(dB)
                semilogx(w1rad,mag2db(abs(H42w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,mag2db(abs(H42w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,mag2db(abs(H42w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,mag2db(squeeze(mag(4,2,:))),'k')
%                 ylabel('Mag. (dB)','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax8,'Fontsize',20);

                ax9 = nexttile; % u3 --> y4 振幅(dB)
                semilogx(w1rad,mag2db(abs(H43w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,mag2db(abs(H43w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,mag2db(abs(H43w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,mag2db(squeeze(mag(4,3,:))),'k')
%                 ylabel('Mag. (dB)','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax9,'Fontsize',20);

                ax10 = nexttile; % u1 --> y4 相位角(deg)
                semilogx(w1rad,rad2deg(H41w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,rad2deg(H41w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,rad2deg(H41w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,squeeze(phase(4,1,:)),'k')
                ylabel('Phase (deg)','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax10,'Fontsize',20);
                xlabel('Frequency (rad/s)','FontSize',20)

                ax11 = nexttile; % u2 --> y4 相位角(deg)
                semilogx(w1rad,rad2deg(H42w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,rad2deg(H42w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,rad2deg(H42w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,squeeze(phase(4,2,:)),'k')
%                 ylabel('Phase (deg)','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax11,'Fontsize',20);
                xlabel('Frequency (rad/s)','FontSize',20)

                ax12 = nexttile; % u3 --> y4 相位角(deg)
                semilogx(w1rad,rad2deg(H43w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,rad2deg(H43w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,rad2deg(H43w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,mag2db(squeeze(mag(4,3,:))),'k')
%                 ylabel('Phase (deg)','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax12,'Fontsize',20);
                xlabel('Frequency (rad/s)','FontSize',20)

                xticklabels(ax1,{})
                xticklabels(ax2,{})
                xticklabels(ax3,{})
                xticklabels(ax4,{})
                xticklabels(ax5,{})
                xticklabels(ax6,{})
                xticklabels(ax7,{})
                xticklabels(ax8,{})
                xticklabels(ax9,{})

                t.YLabel.String = '\psi                                                      \phi';
                t.YLabel.FontSize = 20;
                t.YLabel.FontWeight = 'bold';

        legend('sysID \omega_1','sysID \omega_2','sysID \omega_3','Linearized')
                h1 = figure('units','normalized','outerposition',[0 0 1 1]);
                set(gcf,'WindowState','maximized');
                % 'TileSpacing','Compact' 最小化繪圖之間的空間。'Padding','Compact' 最小化佈局周圍的空間
                t = tiledlayout(4,3,'TileSpacing','Compact','Padding','Compact');
                ax1 = nexttile; % u1 --> y5 振幅(dB)
                semilogx(w1rad,mag2db(abs(H51w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,mag2db(abs(H51w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,mag2db(abs(H51w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,mag2db(squeeze(mag(5,1,:))),'k')
                ylabel('Mag. (dB)','FontSize',20)
                title('\delta_a','FontWeight','bold','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax1,'Fontsize',20);

                ax2 = nexttile; % u2 --> y5 振幅(dB)
                semilogx(w1rad,mag2db(abs(H52w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,mag2db(abs(H52w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,mag2db(abs(H52w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,mag2db(squeeze(mag(5,2,:))),'k')
%                 ylabel('Mag. (dB)','FontSize',20)
                title('\delta_r','FontWeight','bold','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax2,'Fontsize',20);

                ax3 = nexttile; % u3 --> y5 振幅(dB)
                semilogx(w1rad,mag2db(abs(H53w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,mag2db(abs(H53w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,mag2db(abs(H53w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,mag2db(squeeze(mag(5,3,:))),'k')
%                 ylabel('Mag. (dB)','FontSize',20)
                title('\delta_z','FontWeight','bold','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax3,'Fontsize',20);

                ax4 = nexttile; % u1 --> y5 相位角(deg)
                semilogx(w1rad,rad2deg(H51w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,rad2deg(H51w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,rad2deg(H51w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,squeeze(phase(5,1,:)),'k')
                ylabel('Phase (deg)','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax4,'Fontsize',20);
                xlabel('Frequency (rad/s)','FontSize',20)

                ax5 = nexttile; % u2 --> y5 相位角(deg)
                semilogx(w1rad,rad2deg(H52w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,rad2deg(H52w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,rad2deg(H52w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,phase_new{5,2},'k')
%                 ylabel('Phase (deg)','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax5,'Fontsize',20);
                xlabel('Frequency (rad/s)','FontSize',20)

                ax6 = nexttile; % u3 --> y5 相位角(deg)
                semilogx(w1rad,rad2deg(H53w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
                grid on
                hold on
                semilogx(w2rad,rad2deg(H53w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
                semilogx(w3rad,rad2deg(H53w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
                semilogx(wout,phase_new{5,3},'k')
%                 ylabel('Phase (deg)','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax6,'Fontsize',20);
                xlabel('Frequency (rad/s)','FontSize',20)
                xticklabels(ax1,{})
                xticklabels(ax2,{})
                xticklabels(ax3,{})

                t.YLabel.String = '                                                               \itr';
                t.YLabel.FontSize = 20;
                t.YLabel.FontWeight = 'bold';
        legend('sysID \omega_1','sysID \omega_2','sysID \omega_3','Linearized')

                 case 'untrue'
                     figure('units','normalized','outerposition',[0 0 1 1])
        set(gcf,'WindowState','maximized');
        % 'TileSpacing','Compact' 最小化繪圖之間的空間。'Padding','Compact' 最小化佈局周圍的空間
        t = tiledlayout(4,3,'TileSpacing','Compact','Padding','Compact');
        w1rad = w1*2*pi;
        w2rad = w2*2*pi;
        w3rad = w3*2*pi;

        ax1 = nexttile; % u1 --> y1 振幅(dB)
        semilogx(w1rad,mag2db(abs(H11w1)),'LineStyle','none','Marker','o','MarkerSize',8,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H11w2)),'LineStyle','none','Marker','square','MarkerSize',8,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,mag2db(abs(H11w3)),'LineStyle','none','Marker','d','MarkerSize',8,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        title('u1','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax1,'Fontsize',20);

        ax2 = nexttile; % u2 --> y1 振幅(dB)
        semilogx(w1rad,mag2db(abs(H12w1)),'LineStyle','none','Marker','o','MarkerSize',9,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H12w2)),'LineStyle','none','Marker','square','MarkerSize',9,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,mag2db(abs(H12w3)),'LineStyle','none','Marker','d','MarkerSize',9,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        title('u2','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax2,'Fontsize',20);

        ax3 = nexttile; % u3 --> y1 振幅(dB)
        semilogx(w1rad,mag2db(abs(H13w1)),'LineStyle','none','Marker','o','MarkerSize',10,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H13w2)),'LineStyle','none','Marker','square','MarkerSize',10,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,mag2db(abs(H13w3)),'LineStyle','none','Marker','d','MarkerSize',10,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        title('u3','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax3,'Fontsize',20);

        ax4 = nexttile; % u1 --> y1 相位角(deg)
        semilogx(w1rad,rad2deg(H11w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H11w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,rad2deg(H11w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax4,'Fontsize',20);

        ax5 = nexttile; % u2 --> y1 相位角(deg)
        semilogx(w1rad,rad2deg(H12w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H12w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,rad2deg(H12w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax5,'Fontsize',20);
       
        ax6 = nexttile; % u3 --> y1 相位角(deg)
        semilogx(w1rad,rad2deg(H13w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H13w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,rad2deg(H13w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax6,'Fontsize',20);

        ax7 = nexttile; % u1 --> y2 振幅(dB)
        semilogx(w1rad,mag2db(abs(H21w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H21w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,mag2db(abs(H21w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        set(ax7,'Fontsize',20);

        ax8 = nexttile; % u2 --> y2 振幅(dB)
        semilogx(w1rad,mag2db(abs(H22w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H22w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,mag2db(abs(H22w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax8,'Fontsize',20);

        ax9 = nexttile; % u3 --> y2 振幅(dB)
        semilogx(w1rad,mag2db(abs(H23w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H23w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,mag2db(abs(H23w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax9,'Fontsize',20);

        ax10 = nexttile; % u1 --> y2 相位角(deg))
        semilogx(w1rad,rad2deg(H21w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H21w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,rad2deg(H21w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax10,'Fontsize',20);

        ax11 = nexttile; % u2 --> y2 相位角(deg)
        semilogx(w1rad,rad2deg(H22w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H22w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,rad2deg(H22w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax11,'Fontsize',20);

        ax12 = nexttile; % u3 --> y2 相位角(deg)
        semilogx(w1rad,rad2deg(H23w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H23w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,rad2deg(H23w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax12,'Fontsize',20);

        xticklabels(ax1,{})
        xticklabels(ax2,{})
        xticklabels(ax3,{})
        xticklabels(ax4,{})
        xticklabels(ax5,{})
        xticklabels(ax6,{})
        xticklabels(ax7,{})
        xticklabels(ax8,{})
        xticklabels(ax9,{})
        % ---------------------------------------------
        figure('units','normalized','outerposition',[0 0 1 1])
        set(gcf,'WindowState','maximized');
        % 'TileSpacing','Compact' 最小化繪圖之間的空間。'Padding','Compact' 最小化佈局周圍的空間
        t = tiledlayout(4,3,'TileSpacing','Compact','Padding','Compact');
        ax1 = nexttile; % u1 --> y3 振幅(dB)
        semilogx(w1rad,mag2db(abs(H31w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H31w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,mag2db(abs(H31w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        title('u1','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax1,'Fontsize',20);
        
        ax2 = nexttile; % u2 --> y3 振幅(dB)
        semilogx(w1rad,mag2db(abs(H32w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H32w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,mag2db(abs(H32w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        title('u2','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax2,'Fontsize',20);

        ax3 = nexttile; % u3 --> y3 振幅(dB)
        semilogx(w1rad,mag2db(abs(H33w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H33w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,mag2db(abs(H33w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        title('u3','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax3,'Fontsize',20);

        ax4 = nexttile; % u1 --> y3 相位角(deg)
        semilogx(w1rad,rad2deg(H31w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H31w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,rad2deg(H31w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax4,'Fontsize',20);

        ax5 = nexttile; % u2 --> y3 相位角(deg)
        semilogx(w1rad,rad2deg(H32w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H32w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,rad2deg(H32w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax5,'Fontsize',20);

        ax6 = nexttile; % u3 --> y3 相位角(deg)
        semilogx(w1rad,rad2deg(H33w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H33w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,rad2deg(H33w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax6,'Fontsize',20);

        ax7 = nexttile; % u1 --> y4 振幅(dB)
        semilogx(w1rad,mag2db(abs(H41w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H41w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,mag2db(abs(H41w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax7,'Fontsize',20);

        ax8 = nexttile; % u2 --> y4 振幅(dB)
        semilogx(w1rad,mag2db(abs(H42w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H42w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,mag2db(abs(H42w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Mag. (dB)','FontSize',FontSize)        
        xlim([min(w1rad) max(w3rad)])
        set(ax8,'Fontsize',20);

        ax9 = nexttile; % u3 --> y4 振幅(dB)
        semilogx(w1rad,mag2db(abs(H43w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H43w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,mag2db(abs(H43w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Mag. (dB)','FontSize',FontSize)       
        xlim([min(w1rad) max(w3rad)])
        set(ax9,'Fontsize',20);

        ax10 = nexttile; % u1 --> y4 相位角(deg)
        semilogx(w1rad,rad2deg(H41w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H41w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,rad2deg(H41w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax10,'Fontsize',20);

        ax11 = nexttile; % u2 --> y4 相位角(deg)
        semilogx(w1rad,rad2deg(H42w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H42w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,rad2deg(H42w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax11,'Fontsize',20);

        ax12 = nexttile; % u3 --> y4 相位角(deg)
        semilogx(w1rad,rad2deg(H43w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H43w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,rad2deg(H43w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax12,'Fontsize',20);
        xticklabels(ax1,{})
        xticklabels(ax2,{})
        xticklabels(ax3,{})
        xticklabels(ax4,{})
        xticklabels(ax5,{})
        xticklabels(ax6,{})
        xticklabels(ax7,{})
        xticklabels(ax8,{})
        xticklabels(ax9,{})


        figure('units','normalized','outerposition',[0 0 1 1])
        set(gcf,'WindowState','maximized');
        % 'TileSpacing','Compact' 最小化繪圖之間的空間。'Padding','Compact' 最小化佈局周圍的空間
        t = tiledlayout(4,3,'TileSpacing','Compact','Padding','Compact');
        ax1 = nexttile; % u1 --> y5 振幅(dB)
        semilogx(w1rad,mag2db(abs(H51w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H51w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,mag2db(abs(H51w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        title('u1','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax1,'Fontsize',20);

        ax2 = nexttile; % u2 --> y5 振幅(dB)
        semilogx(w1rad,mag2db(abs(H52w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H52w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,mag2db(abs(H52w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        title('u2','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax2,'Fontsize',20);

        ax3 = nexttile; % u3 --> y5 振幅(dB)
        semilogx(w1rad,mag2db(abs(H53w1)),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,mag2db(abs(H53w2)),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,mag2db(abs(H53w3)),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Mag. (dB)','FontSize',FontSize)
        title('u3','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax3,'Fontsize',20);

        ax4 = nexttile; % u1 --> y5 相位角(deg)
        semilogx(w1rad,rad2deg(H51w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H51w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,rad2deg(H51w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax4,'Fontsize',20);

        ax5 = nexttile; % u2 --> y5 相位角(deg)
        semilogx(w1rad,rad2deg(H52w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H52w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,rad2deg(H52w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax5,'Fontsize',20);

        ax6 = nexttile; % u3 --> y5 相位角(deg)
        semilogx(w1rad,rad2deg(H53w1_rad),'LineStyle','none','Marker','o','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.45 0.741]);
        grid on
        hold on
        semilogx(w2rad,rad2deg(H53w2_rad),'LineStyle','none','Marker','square','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0.851 0.3294 0.102]);
        semilogx(w3rad,rad2deg(H53w3_rad),'LineStyle','none','Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22]);
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w3rad)])
        set(ax6,'Fontsize',20);
        end
end