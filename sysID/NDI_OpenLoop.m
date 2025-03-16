% 本程式適用於MATLAB R2019b之後的版本，因使用繪圖指令： tiledlayout (Create tiled chart layout)
% -------------------------------------------------------------------------
% 相位角修正
% -------------------------------------------------------------------------
% 輸入訊號及輸出訊號分別經過 Chirp-Z 轉換後的相位角會摺疊到定義域 [-pi  +pi]
% 但因物理系統輸出訊號會是輸入訊號的延遲，所以輸出訊號的相位一定會小於輸入訊號的相位，故需要修正
switch test_case
    case 'sysID_longitudinal'
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
            if ( OutputDataCZT(index(i,2),2) > InputDataCZT(index(i,2),4) )
                OutputDataCZT(index(i,2),2) = OutputDataCZT(index(i,2),2)-2*pi;
            end
        end

        for i = 1 : size(index,1)
            if ( OutputDataCZT(index(i,2),4) > InputDataCZT(index(i,2),4) )
                OutputDataCZT(index(i,2),4) = OutputDataCZT(index(i,2),4)-2*pi;
            end
        end


        % -----------
        for i = 1 : size(index,1)
            if ( OutputDataCZT(index(i,1),6) > InputDataCZT(index(i,1),2) )
                OutputDataCZT(index(i,1),6) = OutputDataCZT(index(i,1),6)-2*pi;
            end
        end

        for i = 1 : size(index,1)
            if ( OutputDataCZT(index(i,1),8) > InputDataCZT(index(i,1),2) )
                OutputDataCZT(index(i,1),8) = OutputDataCZT(index(i,1),8)-2*pi;
            end
        end

        for i = 1 : size(index,1)
            if ( OutputDataCZT(index(i,2),6) > InputDataCZT(index(i,2),4) )
                OutputDataCZT(index(i,2),6) = OutputDataCZT(index(i,2),6)-2*pi;
            end
        end

        for i = 1 : size(index,1)
            if ( OutputDataCZT(index(i,2),8) > InputDataCZT(index(i,2),4) )
                OutputDataCZT(index(i,2),8) = OutputDataCZT(index(i,2),8)-2*pi;
            end
        end



        % -------------------------------------------------------------------------
        H11_w1_Am = OutputDataCZT(index(:,1),1)./InputDataCZT(index(:,1),1);
        H11_w1_Phi = OutputDataCZT(index(:,1),2)-InputDataCZT(index(:,1),2);

        H21_w1_Am = OutputDataCZT(index(:,1),3)./InputDataCZT(index(:,1),1);
        H21_w1_Phi = OutputDataCZT(index(:,1),4)-InputDataCZT(index(:,1),2);

        H31_w1_Am = OutputDataCZT(index(:,1),5)./InputDataCZT(index(:,1),1);
        H31_w1_Phi = OutputDataCZT(index(:,1),6)-InputDataCZT(index(:,1),2);

        H41_w1_Am = OutputDataCZT(index(:,1),7)./InputDataCZT(index(:,1),1);
        H41_w1_Phi = OutputDataCZT(index(:,1),8)-InputDataCZT(index(:,1),2);

        H12_w2_Am = OutputDataCZT(index(:,2),1)./InputDataCZT(index(:,2),3);
        H12_w2_Phi = OutputDataCZT(index(:,2),2)-InputDataCZT(index(:,2),4);

        H22_w2_Am = OutputDataCZT(index(:,2),3)./InputDataCZT(index(:,2),3);
        H22_w2_Phi = OutputDataCZT(index(:,2),4)-InputDataCZT(index(:,2),4);

        H32_w2_Am = OutputDataCZT(index(:,2),5)./InputDataCZT(index(:,2),3);
        H32_w2_Phi = OutputDataCZT(index(:,2),6)-InputDataCZT(index(:,2),4);

        H42_w2_Am = OutputDataCZT(index(:,2),7)./InputDataCZT(index(:,2),3);
        H42_w2_Phi = OutputDataCZT(index(:,2),8)-InputDataCZT(index(:,2),4);
        %%
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

                t.YLabel.String = '\ita_z                                                      \italpha';
                t.YLabel.FontSize = 20;
                t.YLabel.FontWeight = 'bold';



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
                semilogx((w1*2*pi),mag2db(H31_w1_Am),'LineStyle','none','Marker','o','MarkerSize',14,'MarkerEdgeColor','b','LineWidth',2.5);
                grid on
                ylabel('Mag. (dB)','FontSize',FontSize)
                title('\delta_e_o ','FontWeight','bold','FontSize',FontSize)
                xlim([min(w1rad) max(w2rad)])
                set(ax1,'Fontsize',20);

                ax2 = nexttile;
                semilogx(wout,mag2db(squeeze(mag(1,2,:))),'k')
                hold on
                semilogx((w2*2*pi),mag2db(H32_w2_Am),'LineStyle','none','Marker','square','MarkerSize',14,'MarkerEdgeColor',[0.851 0.3294 0.102],'LineWidth',2.5);
                grid on
                title('\delta_e_i ','FontWeight','bold','FontSize',FontSize)
                xlim([min(w1rad) max(w2rad)])
                set(ax2,'Fontsize',20);

                ax3 = nexttile;
                semilogx(wout,phase_new{1,1},'k')
                hold on
                semilogx((w1*2*pi),rad2deg(H31_w1_Phi),'LineStyle','none','Marker','o','MarkerSize',14,'MarkerEdgeColor','b','LineWidth',2.5);
                grid on
                ylabel('Phase (deg)')
                xlim([min(w1rad) max(w2rad)])
                set(ax3,'Fontsize',20);

                ax4 = nexttile;
                semilogx(wout,phase_new{1,2},'k')
                hold on
                semilogx((w2*2*pi),rad2deg(H32_w2_Phi),'LineStyle','none','Marker','square','MarkerSize',14,'MarkerEdgeColor',[0.851 0.3294 0.102],'LineWidth',2.5);
                grid on
                xlim([min(w1rad) max(w2rad)])
                set(ax4,'Fontsize',20);

                ax5 = nexttile;
                semilogx(wout,mag2db(squeeze(mag(2,1,:))),'k')
                hold on
                semilogx((w1*2*pi),mag2db(H41_w1_Am),'LineStyle','none','Marker','o','MarkerSize',14,'MarkerEdgeColor','b','LineWidth',2.5);
                grid on
                ylabel('Mag. (dB)','FontSize',FontSize)
                % title('Bode Diagram','FontWeight','bold','FontSize',FontSize)
                xlim([min(w1rad) max(w2rad)])
                set(ax5,'Fontsize',20);

                ax6 = nexttile;
                semilogx(wout,mag2db(squeeze(mag(2,2,:))),'k')
                hold on
                semilogx((w2*2*pi),mag2db(H42_w2_Am),'LineStyle','none','Marker','square','MarkerSize',14,'MarkerEdgeColor',[0.851 0.3294 0.102],'LineWidth',2.5);
                grid on
                xlim([min(w1rad) max(w2rad)])
                set(ax6,'Fontsize',20);

                ax7 = nexttile;
                semilogx(wout,phase_new{2,1},'k')
                hold on
                semilogx((w1*2*pi),rad2deg(H41_w1_Phi),'LineStyle','none','Marker','o','MarkerSize',14,'MarkerEdgeColor','b','LineWidth',2.5);
                grid on
                xlabel('Frequency \omega (rad/s)','FontSize',FontSize)
                ylabel('Phase (deg)','FontSize',FontSize)
                xlim([min(w1rad) max(w2rad)])
                set(ax7,'Fontsize',20);

                ax8 = nexttile;
                semilogx(wout,phase_new{2,2},'k')
                hold on
                semilogx((w2*2*pi),rad2deg(H42_w2_Phi),'LineStyle','none','Marker','square','MarkerSize',14,'MarkerEdgeColor',[0.851 0.3294 0.102],'LineWidth',2.5);
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

                t.YLabel.String = '\theta                                                      \itq';
                t.YLabel.FontSize = 20;
                t.YLabel.FontWeight = 'bold';

            case 'untrue'
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
        end
    case 'sysID_lateral'

        for j = 1:3
            for n = 1:5
                for i = 1 : size(index,1)
                    if ( OutputDataCZT(index(i,j),2*n) > InputDataCZT(index(i,j),2*j) )
                        OutputDataCZT(index(i,j),2*n) = OutputDataCZT(index(i,j),2*n)-2*pi;
                    end
                end
            end
        end
% --------------------------------------------------------------------------------u1 y1~y5
        H11_w1_Am = OutputDataCZT(index(:,1),1)./InputDataCZT(index(:,1),1);
        H11_w1_Phi = OutputDataCZT(index(:,1),2)-InputDataCZT(index(:,1),2);

        H21_w1_Am = OutputDataCZT(index(:,1),3)./InputDataCZT(index(:,1),1);
        H21_w1_Phi = OutputDataCZT(index(:,1),4)-InputDataCZT(index(:,1),2);

        H31_w1_Am = OutputDataCZT(index(:,1),5)./InputDataCZT(index(:,1),1);
        H31_w1_Phi = OutputDataCZT(index(:,1),6)-InputDataCZT(index(:,1),2);

        H41_w1_Am = OutputDataCZT(index(:,1),7)./InputDataCZT(index(:,1),1);
        H41_w1_Phi = OutputDataCZT(index(:,1),8)-InputDataCZT(index(:,1),2);

        H51_w1_Am = OutputDataCZT(index(:,1),9)./InputDataCZT(index(:,1),1);
        H51_w1_Phi = OutputDataCZT(index(:,1),10)-InputDataCZT(index(:,1),2);
% --------------------------------------------------------------------------------u2 y1~y5
        H12_w2_Am = OutputDataCZT(index(:,2),1)./InputDataCZT(index(:,2),3);
        H12_w2_Phi = OutputDataCZT(index(:,2),2)-InputDataCZT(index(:,2),4);

        H22_w2_Am = OutputDataCZT(index(:,2),3)./InputDataCZT(index(:,2),3);
        H22_w2_Phi = OutputDataCZT(index(:,2),4)-InputDataCZT(index(:,2),4);

        H32_w2_Am = OutputDataCZT(index(:,2),5)./InputDataCZT(index(:,2),3);
        H32_w2_Phi = OutputDataCZT(index(:,2),6)-InputDataCZT(index(:,2),4);

        H42_w2_Am = OutputDataCZT(index(:,2),7)./InputDataCZT(index(:,2),3);
        H42_w2_Phi = OutputDataCZT(index(:,2),8)-InputDataCZT(index(:,2),4);

        H52_w2_Am = OutputDataCZT(index(:,2),9)./InputDataCZT(index(:,2),3);
        H52_w2_Phi = OutputDataCZT(index(:,2),10)-InputDataCZT(index(:,2),4);
% --------------------------------------------------------------------------------u3 y1~y5
        H13_w3_Am = OutputDataCZT(index(:,3),1)./InputDataCZT(index(:,3),5);
        H13_w3_Phi = OutputDataCZT(index(:,3),2)-InputDataCZT(index(:,3),6);

        H23_w3_Am = OutputDataCZT(index(:,3),3)./InputDataCZT(index(:,3),5);
        H23_w3_Phi = OutputDataCZT(index(:,3),4)-InputDataCZT(index(:,3),6);

        H33_w3_Am = OutputDataCZT(index(:,3),5)./InputDataCZT(index(:,3),5);
        H33_w3_Phi = OutputDataCZT(index(:,3),6)-InputDataCZT(index(:,3),6);

        H43_w3_Am = OutputDataCZT(index(:,3),7)./InputDataCZT(index(:,3),5);
        H43_w3_Phi = OutputDataCZT(index(:,3),8)-InputDataCZT(index(:,3),6);

        H53_w3_Am = OutputDataCZT(index(:,3),9)./InputDataCZT(index(:,3),5);
        H53_w3_Phi = OutputDataCZT(index(:,3),10)-InputDataCZT(index(:,3),6);
% ------------------------------------------
 h1 = figure('units','normalized','outerposition',[0 0 1 1]);
                set(gcf,'WindowState','maximized');
                % 'TileSpacing','Compact' 最小化繪圖之間的空間。'Padding','Compact' 最小化佈局周圍的空間
                t = tiledlayout(4,3,'TileSpacing','Compact','Padding','Compact');
                w1rad = w1*2*pi;
                w2rad = w2*2*pi;
                w3rad = w3*2*pi;


                ax1 = nexttile; % u1 --> y1 振幅(dB)
                semilogx((w1*2*pi),mag2db(H11_w1_Am),'LineStyle','none','Marker','o','MarkerSize',14,'MarkerEdgeColor','b','LineWidth',2.5);
                hold on
                semilogx(wout,mag2db(squeeze(mag(1,1,:))),'k')
                ylabel('Mag. (dB)','FontSize',FontSize)
                title('\delta_a','FontWeight','bold','FontSize',FontSize)
                xlim([min(w1rad) max(w3rad)])
                set(ax1,'Fontsize',20);

                ax2 = nexttile; % u2 --> y1 振幅(dB)
                semilogx((w2*2*pi),mag2db(H12_w2_Am),'LineStyle','none','Marker','square','MarkerSize',14,'MarkerEdgeColor',[0.851 0.3294 0.102],'LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,mag2db(squeeze(mag(1,2,:))),'k')
                title('\delta_r','FontWeight','bold','FontSize',FontSize)
                xlim([min(w1rad) max(w3rad)])
                set(ax2,'Fontsize',20);

                ax3 = nexttile; % u3 --> y1 振幅(dB)
                semilogx((w3*2*pi),mag2db(H13_w3_Am),'LineStyle','none','Marker','d','MarkerSize',14,'MarkerEdgeColor',[0 0.85 0.22],'LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,mag2db(squeeze(mag(1,3,:))),'k')
                title('\delta_z','FontWeight','bold','FontSize',FontSize)
                xlim([min(w1rad) max(w3rad)])
                set(ax3,'Fontsize',20);

                ax4 = nexttile; % u1 --> y1 相位角(deg)
                semilogx((w1*2*pi),rad2deg(H11_w1_Phi),'LineStyle','none','Marker','o','MarkerSize',14,'MarkerEdgeColor','b','LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,phase_new{1,1},'k')
                ylabel('Phase (deg)','FontSize',FontSize)
                xlim([min(w1rad) max(w3rad)])
                set(ax4,'Fontsize',20);

                ax5 = nexttile; % u2 --> y1 相位角(deg)
                semilogx((w2*2*pi),rad2deg(H12_w2_Phi),'LineStyle','none','Marker','square','MarkerSize',14,'MarkerEdgeColor',[0.851 0.3294 0.102],'LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,squeeze(phase(1,2,:)),'k')
%                 ylabel('Phase (deg)','FontSize',FontSize)
                xlim([min(w1rad) max(w3rad)])
                set(ax5,'Fontsize',20);

                ax6 = nexttile; % u3 --> y1 相位角(deg)
                semilogx((w3*2*pi),rad2deg(H13_w3_Phi),'LineStyle','none','Marker','d','MarkerSize',14,'MarkerEdgeColor',[0 0.85 0.22],'LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,squeeze(phase(1,3,:)),'k')
                xlim([min(w1rad) max(w3rad)])
                set(ax6,'Fontsize',20);

                ax7 = nexttile; % u1 --> y2 振幅(dB)
                semilogx((w1*2*pi),mag2db(H21_w1_Am),'LineStyle','none','Marker','o','MarkerSize',14,'MarkerEdgeColor','b','LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,mag2db(squeeze(mag(2,1,:))),'k')
                ylabel('Mag. (dB)','FontSize',FontSize)
                xlim([min(w1rad) max(w3rad)])
                set(ax7,'Fontsize',20);

                ax8 = nexttile; % u2 --> y2 振幅(dB)
                semilogx((w2*2*pi),mag2db(H22_w2_Am),'LineStyle','none','Marker','square','MarkerSize',14,'MarkerEdgeColor',[0.851 0.3294 0.102],'LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,mag2db(squeeze(mag(2,2,:))),'k')
                xlim([min(w1rad) max(w3rad)])
                set(ax8,'Fontsize',20);

                ax9 = nexttile; % u3 --> y2 振幅(dB)
                semilogx((w3*2*pi),mag2db(H23_w3_Am),'LineStyle','none','Marker','d','MarkerSize',14,'MarkerEdgeColor',[0 0.85 0.22],'LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,mag2db(squeeze(mag(2,3,:))),'k')
                xlim([min(w1rad) max(w3rad)])
                set(ax9,'Fontsize',20);

                ax10 = nexttile; % u1 --> y2 相位角(deg))
                semilogx((w1*2*pi),rad2deg(H21_w1_Phi),'LineStyle','none','Marker','o','MarkerSize',14,'MarkerEdgeColor','b','LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,squeeze(phase(2,1,:)),'k')
                ylabel('Phase (deg)','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax10,'Fontsize',20);
                xlabel('Frequency (rad/s)','FontSize',20)

                ax11 = nexttile; % u2 --> y2 相位角(deg)
                semilogx((w2*2*pi),rad2deg(H22_w2_Phi),'LineStyle','none','Marker','square','MarkerSize',14,'MarkerEdgeColor',[0.851 0.3294 0.102],'LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,squeeze(phase(2,2,:)),'k')
                xlim([min(w1rad) max(w3rad)])
                set(ax11,'Fontsize',20);
                xlabel('Frequency (rad/s)','FontSize',20)

                ax12 = nexttile; % u3 --> y2 相位角(deg)
                semilogx((w3*2*pi),rad2deg(H23_w3_Phi),'LineStyle','none','Marker','d','MarkerSize',14,'MarkerEdgeColor',[0 0.85 0.22],'LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,squeeze(phase(2,3,:)),'k')
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

                % ----------------------------------------------
                figure('units','normalized','outerposition',[0 0 1 1])
                set(gcf,'WindowState','maximized');
                % 'TileSpacing','Compact' 最小化繪圖之間的空間。'Padding','Compact' 最小化佈局周圍的空間
                t = tiledlayout(4,3,'TileSpacing','Compact','Padding','Compact');
                ax1 = nexttile; % u1 --> y3 振幅(dB)
                semilogx((w1*2*pi),mag2db(H31_w1_Am),'LineStyle','none','Marker','o','MarkerSize',14,'MarkerEdgeColor','b','LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,mag2db(squeeze(mag(3,1,:))),'k')
                ylabel('Mag. (dB)','FontSize',20)
                title('\delta_a','FontWeight','bold','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax1,'Fontsize',20);

                ax2 = nexttile; % u2 --> y3 振幅(dB)
                semilogx((w2*2*pi),mag2db(H32_w2_Am),'LineStyle','none','Marker','square','MarkerSize',14,'MarkerEdgeColor',[0.851 0.3294 0.102],'LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,mag2db(squeeze(mag(3,2,:))),'k')
%                 ylabel('Mag. (dB)','FontSize',20)
                title('\delta_r','FontWeight','bold','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax2,'Fontsize',20);

                ax3 = nexttile; % u3 --> y3 振幅(dB)
                semilogx((w3*2*pi),mag2db(H33_w3_Am),'LineStyle','none','Marker','d','MarkerSize',14,'MarkerEdgeColor',[0 0.85 0.22],'LineWidth',2.5);
                grid on
                hold on
               semilogx(wout,mag2db(squeeze(mag(3,3,:))),'k')
%                 ylabel('Mag. (dB)','FontSize',20)
                title('\delta_z','FontWeight','bold','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax3,'Fontsize',20);

                ax4 = nexttile; % u1 --> y3 相位角(deg)
                semilogx((w1*2*pi),rad2deg(H31_w1_Phi),'LineStyle','none','Marker','o','MarkerSize',14,'MarkerEdgeColor','b','LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,squeeze(phase(3,1,:)),'k')
                ylabel('Phase (deg)','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax4,'Fontsize',20);

                ax5 = nexttile; % u2 --> y3 相位角(deg)
                semilogx((w2*2*pi),rad2deg(H32_w2_Phi),'LineStyle','none','Marker','square','MarkerSize',14,'MarkerEdgeColor',[0.851 0.3294 0.102],'LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,squeeze(phase(3,2,:)),'k')
%                 ylabel('Phase (deg)','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax5,'Fontsize',20);

                ax6 = nexttile; % u3 --> y3 相位角(deg)
                semilogx((w3*2*pi),rad2deg(H33_w3_Phi),'LineStyle','none','Marker','d','MarkerSize',14,'MarkerEdgeColor',[0 0.85 0.22],'LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,squeeze(phase(3,3,:)),'k')
%                 ylabel('Phase (deg)','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax6,'Fontsize',20);

                ax7 = nexttile; % u1 --> y4 振幅(dB)
                semilogx((w1*2*pi),mag2db(H41_w1_Am),'LineStyle','none','Marker','o','MarkerSize',14,'MarkerEdgeColor','b','LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,mag2db(squeeze(mag(4,1,:))),'k')
                ylabel('Mag. (dB)','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax7,'Fontsize',20);

                ax8 = nexttile; % u2 --> y4 振幅(dB)
                semilogx((w2*2*pi),mag2db(H42_w2_Am),'LineStyle','none','Marker','square','MarkerSize',14,'MarkerEdgeColor',[0.851 0.3294 0.102],'LineWidth',2.5);
                grid on
                hold on
               semilogx(wout,mag2db(squeeze(mag(4,2,:))),'k')
%                 ylabel('Mag. (dB)','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax8,'Fontsize',20);

                ax9 = nexttile; % u3 --> y4 振幅(dB)
                semilogx((w3*2*pi),mag2db(H43_w3_Am),'LineStyle','none','Marker','d','MarkerSize',14,'MarkerEdgeColor',[0 0.85 0.22],'LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,mag2db(squeeze(mag(4,3,:))),'k')
                xlim([min(w1rad) max(w3rad)])
                set(ax9,'Fontsize',20);

                ax10 = nexttile; % u1 --> y4 相位角(deg)
                semilogx((w1*2*pi),rad2deg(H41_w1_Phi),'LineStyle','none','Marker','o','MarkerSize',14,'MarkerEdgeColor','b','LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,squeeze(phase(4,1,:)),'k')
                ylabel('Phase (deg)','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax10,'Fontsize',20);
                xlabel('Frequency (rad/s)','FontSize',20)

                ax11 = nexttile; % u2 --> y4 相位角(deg)
                semilogx((w2*2*pi),rad2deg(H42_w2_Phi),'LineStyle','none','Marker','square','MarkerSize',14,'MarkerEdgeColor',[0.851 0.3294 0.102],'LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,squeeze(phase(4,2,:)),'k')
                xlim([min(w1rad) max(w3rad)])
                set(ax11,'Fontsize',20);
                xlabel('Frequency (rad/s)','FontSize',20)

                ax12 = nexttile; % u3 --> y4 相位角(deg)
                semilogx((w3*2*pi),rad2deg(H43_w3_Phi),'LineStyle','none','Marker','d','MarkerSize',14,'MarkerEdgeColor',[0 0.85 0.22],'LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,mag2db(squeeze(mag(4,3,:))),'k')
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
                % ----------------------------------
 h1 = figure('units','normalized','outerposition',[0 0 1 1]);
                set(gcf,'WindowState','maximized');
                % 'TileSpacing','Compact' 最小化繪圖之間的空間。'Padding','Compact' 最小化佈局周圍的空間
                t = tiledlayout(4,3,'TileSpacing','Compact','Padding','Compact');
                ax1 = nexttile; % u1 --> y5 振幅(dB)
                semilogx((w1*2*pi),mag2db(H51_w1_Am),'LineStyle','none','Marker','o','MarkerSize',14,'MarkerEdgeColor','b','LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,mag2db(squeeze(mag(5,1,:))),'k')
                ylabel('Mag. (dB)','FontSize',20)
                title('\delta_a','FontWeight','bold','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax1,'Fontsize',20);

                ax2 = nexttile; % u2 --> y5 振幅(dB)
                semilogx((w2*2*pi),mag2db(H52_w2_Am),'LineStyle','none','Marker','square','MarkerSize',14,'MarkerEdgeColor',[0.851 0.3294 0.102],'LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,mag2db(squeeze(mag(5,2,:))),'k')
%                 ylabel('Mag. (dB)','FontSize',20)
                title('\delta_r','FontWeight','bold','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax2,'Fontsize',20);

                ax3 = nexttile; % u3 --> y5 振幅(dB)
                semilogx((w3*2*pi),mag2db(H53_w3_Am),'LineStyle','none','Marker','d','MarkerSize',14,'MarkerEdgeColor',[0 0.85 0.22],'LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,mag2db(squeeze(mag(5,3,:))),'k')
%                 ylabel('Mag. (dB)','FontSize',20)
                title('\delta_z','FontWeight','bold','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax3,'Fontsize',20);

                ax4 = nexttile; % u1 --> y5 相位角(deg)
                semilogx((w1*2*pi),rad2deg(H51_w1_Phi),'LineStyle','none','Marker','o','MarkerSize',14,'MarkerEdgeColor','b','LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,squeeze(phase(5,1,:)),'k')
                ylabel('Phase (deg)','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax4,'Fontsize',20);
                xlabel('Frequency (rad/s)','FontSize',20)

                ax5 = nexttile; % u2 --> y5 相位角(deg)
                semilogx((w2*2*pi),rad2deg(H52_w2_Phi),'LineStyle','none','Marker','square','MarkerSize',14,'MarkerEdgeColor',[0.851 0.3294 0.102],'LineWidth',2.5);
                grid on
                hold on
                semilogx(wout,phase_new{5,2},'k')
%                 ylabel('Phase (deg)','FontSize',20)
                xlim([min(w1rad) max(w3rad)])
                set(ax5,'Fontsize',20);
                xlabel('Frequency (rad/s)','FontSize',20)

                ax6 = nexttile; % u3 --> y5 相位角(deg)
                semilogx((w3*2*pi),rad2deg(H53_w3_Phi),'LineStyle','none','Marker','d','MarkerSize',14,'MarkerEdgeColor',[0 0.85 0.22],'LineWidth',2.5);
                grid on
                hold on
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
                % --------------------------------
end