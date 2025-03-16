% 本程式適用於MATLAB R2019b之後的版本，因使用繪圖指令： tiledlayout (Create tiled chart layout)
% -------------------------------------------------------------------------
% 相位角修正
% -------------------------------------------------------------------------
% 輸入訊號及輸出訊號分別經過 Chirp-Z 轉換後的相位角會摺疊到定義域 [-pi  +pi]
% 但因物理系統輸出訊號會是輸入訊號的延遲，所以輸出訊號的相位一定會小於輸入訊號的相位，故需要修正
for i = 1 : size(index,1)
    if ( OutputDataCZT(index(i,1),2) > InputDataCZT(index(i,1),2) )
        OutputDataCZT(index(i,1),2) = OutputDataCZT(index(i,1),2)-2*pi;
    end
end

for i = 1 : size(index,1)
    if ( OutputDataCZT(index(i,1),4) > InputDataCZT(index(i,1),2) )
        OutputDataCZT(index(i,1),4) = OutputDataCZT(index(i,1),4)-2*pi;
    end
end

for i = 1 : size(index,1)
    if ( OutputDataCZT(index(i,2),4) > InputDataCZT(index(i,2),4) )
        OutputDataCZT(index(i,2),4) = OutputDataCZT(index(i,2),4)-2*pi;
    end
end

for i = 1 : size(index,1)
    if ( OutputDataCZT(index(i,2),2) > InputDataCZT(index(i,2),4) )
        OutputDataCZT(index(i,2),2) = OutputDataCZT(index(i,2),2)-2*pi;
    end
end
% -------------------------------------------------------------------------
H11_w1_Am = OutputDataCZT(index(:,1),1)./InputDataCZT(index(:,1),1);
H11_w1_Phi = OutputDataCZT(index(:,1),2)-InputDataCZT(index(:,1),2);

H21_w1_Am = OutputDataCZT(index(:,1),3)./InputDataCZT(index(:,1),1);
H21_w1_Phi = OutputDataCZT(index(:,1),4)-InputDataCZT(index(:,1),2);

H12_w2_Am = OutputDataCZT(index(:,2),1)./InputDataCZT(index(:,2),3);
H12_w2_Phi = OutputDataCZT(index(:,2),2)-InputDataCZT(index(:,2),4);

H22_w2_Am = OutputDataCZT(index(:,2),3)./InputDataCZT(index(:,2),3);
H22_w2_Phi = OutputDataCZT(index(:,2),4)-InputDataCZT(index(:,2),4);

figure('units','normalized','outerposition',[0 0 1 1])

set(gcf,'WindowState','maximized');
% 'TileSpacing','Compact' 最小化繪圖之間的空間。'Padding','Compact' 最小化佈局周圍的空間
t = tiledlayout(4,2,'TileSpacing','Compact','Padding','Compact');
w1rad = w1*2*pi;
w2rad = w2*2*pi;

ax1 = nexttile;
semilogx((w1*2*pi),mag2db(H11_w1_Am),'LineStyle','none','Marker','o','MarkerSize',14,'MarkerEdgeColor','b','LineWidth',2.5);
grid on
ylabel('Mag. (dB)','FontSize',FontSize)
title('u1','FontWeight','bold','FontSize',FontSize)
xlim([min(w1rad) max(w2rad)])
set(ax1,'Fontsize',20);

ax2 = nexttile;
semilogx((w2*2*pi),mag2db(H12_w2_Am),'LineStyle','none','Marker','square','MarkerSize',14,'MarkerEdgeColor',[0.851 0.3294 0.102],'LineWidth',2.5);
grid on
title('u2','FontWeight','bold','FontSize',FontSize)
xlim([min(w1rad) max(w2rad)])
set(ax2,'Fontsize',20);

ax3 = nexttile;
semilogx((w1*2*pi),rad2deg(H11_w1_Phi),'LineStyle','none','Marker','o','MarkerSize',14,'MarkerEdgeColor','b','LineWidth',2.5);
grid on
ylabel('Phase (deg)')
xlim([min(w1rad) max(w2rad)])
set(ax3,'Fontsize',20);

ax4 = nexttile;
semilogx((w2*2*pi),rad2deg(H12_w2_Phi),'LineStyle','none','Marker','square','MarkerSize',14,'MarkerEdgeColor',[0.851 0.3294 0.102],'LineWidth',2.5);
grid on
xlim([min(w1rad) max(w2rad)])
set(ax4,'Fontsize',20);

ax5 = nexttile;
semilogx((w1*2*pi),mag2db(H21_w1_Am),'LineStyle','none','Marker','o','MarkerSize',14,'MarkerEdgeColor','b','LineWidth',2.5);
grid on
ylabel('Mag. (dB)','FontSize',FontSize)
xlim([min(w1rad) max(w2rad)])
set(ax5,'Fontsize',20);

ax6 = nexttile;
semilogx((w2*2*pi),mag2db(H22_w2_Am),'LineStyle','none','Marker','square','MarkerSize',14,'MarkerEdgeColor',[0.851 0.3294 0.102],'LineWidth',2.5);
grid on
xlim([min(w1rad) max(w2rad)])
set(ax6,'Fontsize',20);

ax7 = nexttile;
semilogx((w1*2*pi),rad2deg(H21_w1_Phi),'LineStyle','none','Marker','o','MarkerSize',14,'MarkerEdgeColor','b','LineWidth',2.5);
grid on
xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
ylabel('Phase (deg)','FontSize',FontSize)
xlim([min(w1rad) max(w2rad)])
set(ax7,'Fontsize',20);

ax8 = nexttile;
semilogx((w2*2*pi),rad2deg(H22_w2_Phi),'LineStyle','none','Marker','square','MarkerSize',14,'MarkerEdgeColor',[0.851 0.3294 0.102],'LineWidth',2.5);
grid on
xlabel('Frequency (rad/s)','FontSize',FontSize)
xlim([min(w1rad) max(w2rad)])
set(ax8,'Fontsize',20);

xticklabels(ax1,{})
xticklabels(ax2,{})
xticklabels(ax3,{})
xticklabels(ax4,{})
xticklabels(ax5,{})
xticklabels(ax6,{})

switch true_case
    case 'true'

        %Plot the resulting linearization 修正後頻率響應圖與 true(黑線) 的比較
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
        mag_new{2,1}   = squeeze(mag(2,1,:));
        mag_new{2,2}   = squeeze(mag(2,2,:));
        phase_new{1,1} = squeeze(phase(1,1,:));
        phase_new{1,2} = squeeze(phase(1,2,:));
        phase_new{2,1} = squeeze(phase(2,1,:));
        phase_new{2,2} = squeeze(phase(2,2,:));

        % 為了繪圖好看，統一修正True(黑線)，Phase若大於0度則減360度，進行相位下移。此舉不會影響GM、PM判斷
        if all(phase_new{1,1}>0)
            phase_new{1,1}=phase_new{1,1}-360;
        end
        if all(phase_new{1,2}>0)
            phase_new{1,2}=phase_new{1,2}-360;
        end
        if all(phase_new{2,1}>0)
            phase_new{2,1}=phase_new{2,1}-360;
        end
        if all(phase_new{2,2}>0)
            phase_new{2,2}=phase_new{2,2}-360;
        end

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


        figure('units','normalized','outerposition',[0 0 1 1])
        % set(gcf,'Position',get(0,'ScreenSize'))

        set(gcf,'WindowState','maximized');
        % 'TileSpacing','Compact' 最小化繪圖之間的空間。'Padding','Compact' 最小化佈局周圍的空間
        t = tiledlayout(4,2,'TileSpacing','Compact','Padding','Compact');
        w1rad = w1*2*pi;
        w2rad = w2*2*pi;

        ax1 = nexttile;
        semilogx(wout,mag2db(squeeze(mag(1,1,:))),'k')
        hold on
        semilogx((w1*2*pi),mag2db(H11_w1_Am),'LineStyle','none','Marker','o','MarkerSize',14,'MarkerEdgeColor','b','LineWidth',2.5);
        grid on
        ylabel('Mag. (dB)','FontSize',FontSize)
        title('\delta_e_o ','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax1,'Fontsize',20);

        ax2 = nexttile;
        semilogx(wout,mag2db(squeeze(mag(1,2,:))),'k')
        hold on
        semilogx((w2*2*pi),mag2db(H12_w2_Am),'LineStyle','none','Marker','square','MarkerSize',14,'MarkerEdgeColor',[0.851 0.3294 0.102],'LineWidth',2.5);
        grid on
        title('\delta_e_i ','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax2,'Fontsize',20);

        ax3 = nexttile;
        semilogx(wout,phase_new{1,1},'k')
        hold on
        semilogx((w1*2*pi),rad2deg(H11_w1_Phi),'LineStyle','none','Marker','o','MarkerSize',14,'MarkerEdgeColor','b','LineWidth',2.5);
        grid on
        ylabel('Phase (deg)')
        xlim([min(w1rad) max(w2rad)])
        set(ax3,'Fontsize',20);

        ax4 = nexttile;
        semilogx(wout,phase_new{1,2},'k')
        hold on
        semilogx((w2*2*pi),rad2deg(H12_w2_Phi),'LineStyle','none','Marker','square','MarkerSize',14,'MarkerEdgeColor',[0.851 0.3294 0.102],'LineWidth',2.5);
        grid on
        xlim([min(w1rad) max(w2rad)])
        set(ax4,'Fontsize',20);

        ax5 = nexttile;
        semilogx(wout,mag2db(squeeze(mag(2,1,:))),'k')
        hold on
        semilogx((w1*2*pi),mag2db(H21_w1_Am),'LineStyle','none','Marker','o','MarkerSize',14,'MarkerEdgeColor','b','LineWidth',2.5);
        grid on
        ylabel('Mag. (dB)','FontSize',FontSize)
        % title('Bode Diagram','FontWeight','bold','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax5,'Fontsize',20);

        ax6 = nexttile;
        semilogx(wout,mag2db(squeeze(mag(2,2,:))),'k')
        hold on
        semilogx((w2*2*pi),mag2db(H22_w2_Am),'LineStyle','none','Marker','square','MarkerSize',14,'MarkerEdgeColor',[0.851 0.3294 0.102],'LineWidth',2.5);
        grid on
        xlim([min(w1rad) max(w2rad)])
        set(ax6,'Fontsize',20);

        ax7 = nexttile;
        semilogx(wout,phase_new{2,1},'k')
        hold on
        semilogx((w1*2*pi),rad2deg(H21_w1_Phi),'LineStyle','none','Marker','o','MarkerSize',14,'MarkerEdgeColor','b','LineWidth',2.5);
        grid on
        xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
        ylabel('Phase (deg)','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax7,'Fontsize',20);

        ax8 = nexttile;
        semilogx(wout,phase_new{2,2},'k')
        hold on
        semilogx((w2*2*pi),rad2deg(H22_w2_Phi),'LineStyle','none','Marker','square','MarkerSize',14,'MarkerEdgeColor',[0.851 0.3294 0.102],'LineWidth',2.5);
        grid on
        xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
        xlim([min(w1rad) max(w2rad)])
        set(ax8,'Fontsize',20);

        xticklabels(ax1,{})
        xticklabels(ax2,{})
        xticklabels(ax3,{})
        xticklabels(ax4,{})
        xticklabels(ax5,{})
        xticklabels(ax6,{})

        t.YLabel.String = '\ita_z                                                      \itq';
        t.YLabel.FontSize = 20;
        t.YLabel.FontWeight = 'bold';
    case 'untrue'
end