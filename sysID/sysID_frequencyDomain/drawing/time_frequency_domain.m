%% NDI time_frequency_domain 繪製輸入、輸出的時域和頻域圖
switch test_case
    case 'sysID_longitudinal'
        figure('units','normalized','outerposition',[0 0 1 1])
        set(gcf,'WindowState','maximized');
        % 'TileSpacing','Compact' 最小化繪圖之間的空間。'Padding','Compact' 最小化佈局周圍的空間
        tt = tiledlayout(size(sysIDInput,2),2,'TileSpacing','Compact','Padding','Compact');

        sysIDtime = transpose(0:1/fs:sysID_OBES.initial_delay + max(sum(temp,2)) +sysID_OBES.final_delay);                 % 系統識別實驗時間

        for i=1:size(sysIDInput,2)
            % Tile 1
            ax(2*i-1) = nexttile;
            plot(sysIDtime,rad2deg(sysIDInput(:,i)),'b')                    % 繪製輸入 u 的時域圖
            grid on
            xlim([0 sysIDtime(end)])


            % Tile 2
            ax(2*i) = nexttile;
            stem(w1,abs(InputDataCZT(index(:,1),2*i-1)),'Marker','o','MarkerSize',11,'MarkerFaceColor',[0 0.45 0.741])                                        % CZT Amplitude 頻域圖
            hold on
            stem(w2,abs(InputDataCZT(index(:,2),2*i-1)),'Marker','square','MarkerSize',11,'MarkerFaceColor',[0.851 0.3294 0.102])
            hold on
            grid on
            % title(ax(2),['Chirp-Z Transform u' num2str(i)]);
            set(ax(2*i-1),'Fontsize',20);
            set(ax(2*i),'Fontsize',20);
            xlim([0 w2(end)*1.1])
        end
        legend('\omega_1','\omega_2')
        xticklabels(ax(1),{})
        xticklabels(ax(2),{})
        xlabel(ax(3),'t (sec)')
        xlabel(ax(4),'frequency (Hz)')
        ylabel(ax(1),'\delta_e (deg)')
        ylabel(ax(3),'\delta_y (deg)')
        ylabel(ax(2),'|\delta_e|')
        ylabel(ax(4),'|\delta_y|')
        %%
        figure('units','normalized','outerposition',[0 0 1 1])
        % set(gcf,'Position',get(0,'ScreenSize'))

        set(gcf,'WindowState','maximized');
        % 'TileSpacing','Compact' 最小化繪圖之間的空間。'Padding','Compact' 最小化佈局周圍的空間
        tt = tiledlayout(size(sysIDOutput,2),2,'TileSpacing','Compact','Padding','Compact');
        for i=1:size(sysIDOutput,2)
            % Tile 3
            ax(2*i-1) = nexttile;
            plot(sysIDtime,rad2deg(sysIDOutput(:,i)),'b')                  % 繪製輸出 y 的時域圖
            grid on
            xlim([0 sysIDtime(end)])


            % Tile 4
            ax(2*i) = nexttile;
            stem(w1,abs(OutputDataCZT(index(:,1),2*i-1)),'Marker','o','MarkerSize',11,'MarkerFaceColor',[0 0.45 0.741])                                        % CZT Amplitude 頻域圖
            hold on
            stem(w2,abs(OutputDataCZT(index(:,2),2*i-1)),'Marker','square','MarkerSize',11,'MarkerFaceColor',[0.851 0.3294 0.102])
            hold on
            grid on
            set(ax(2*i),'Fontsize',20);
            set(ax(2*i-1),'Fontsize',20);
            xlim([0 w2(end)*1.1])
        end
        legend('\omega_1','\omega_2')
        xticklabels(ax(1),{})
        xticklabels(ax(2),{})
        xticklabels(ax(3),{})
        xticklabels(ax(4),{})
        xticklabels(ax(5),{})
        xticklabels(ax(6),{})
        xlabel(ax(end-1),'t (sec)')
        xlabel(ax(end),'frequency (Hz)')
        ylabel(ax(1),'\alpha (deg)')
        ylabel(ax(3),'\ita_z (deg/s^2)')
        ylabel(ax(5),'\itq (deg/s)')
        ylabel(ax(7),'\theta (deg)')
        ylabel(ax(2),'|\alpha|')
        ylabel(ax(4),'|\ita_z|')
        ylabel(ax(6),'|\itq|')
        ylabel(ax(8),'|\theta|')
    case 'sysID_lateral'
        figure('units','normalized','outerposition',[0 0 1 1])
        set(gcf,'WindowState','maximized');
        % 'TileSpacing','Compact' 最小化繪圖之間的空間。'Padding','Compact' 最小化佈局周圍的空間
        tt = tiledlayout(size(sysIDInput,2),2,'TileSpacing','Compact','Padding','Compact');

        sysIDtime = transpose(0:1/fs:sysID_OBES.initial_delay + max(sum(temp,2)) +sysID_OBES.final_delay);                 % 系統識別實驗時間

        for i=1:size(sysIDInput,2)
            % Tile 1
            ax(2*i-1) = nexttile;
            plot(sysIDtime,rad2deg(sysIDInput(:,i)),'b')                    % 繪製輸入 u 的時域圖
            grid on
            ylabel(['u' num2str(i) '(t)']);
            xlim([0 sysIDtime(end)])


            % Tile 2
            ax(2*i) = nexttile;
            stem(w1,abs(InputDataCZT(index(:,1),2*i-1)),'Marker','o','MarkerSize',11,'MarkerFaceColor',[0 0.45 0.741])                                        % CZT Amplitude 頻域圖
            hold on
            stem(w2,abs(InputDataCZT(index(:,2),2*i-1)),'Marker','square','MarkerSize',11,'MarkerFaceColor',[0.851 0.3294 0.102])
            hold on
                stem(w3,abs(InputDataCZT(index(:,3),2*i-1)),'Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22])
            grid on
            ylabel(['|u' num2str(i) '|']);
            set(ax(2*i-1),'Fontsize',20);
            set(ax(2*i),'Fontsize',20);
            xlim([0 w3(end)*1.1])
        end
        legend('\omega_1','\omega_2','\omega_3')
        xticklabels(ax(1),{})
        xticklabels(ax(2),{})
        xticklabels(ax(3),{})
        xticklabels(ax(4),{})
        xlabel(ax(end-1),'t (sec)')
        xlabel(ax(end),'frequency (Hz)')
        ylabel(ax(1),'\delta_a(deg)')
        ylabel(ax(3),'\delta_r(deg)')
        ylabel(ax(5),'\delta_z (deg)')
        ylabel(ax(2),'|\delta_a|')
        ylabel(ax(4),'|\delta_r|')
        ylabel(ax(6),'|\delta_z|')
        %%
        figure('units','normalized','outerposition',[0 0 1 1])
        % set(gcf,'Position',get(0,'ScreenSize'))

        set(gcf,'WindowState','maximized');
        % 'TileSpacing','Compact' 最小化繪圖之間的空間。'Padding','Compact' 最小化佈局周圍的空間
        tt = tiledlayout(size(sysIDOutput,2),2,'TileSpacing','Compact','Padding','Compact');
        for i=1:size(sysIDOutput,2)
            % Tile 3
            ax(2*i-1) = nexttile;
            plot(sysIDtime,rad2deg(sysIDOutput(:,i)),'b')                  % 繪製輸出 y 的時域圖
            grid on
            xlim([0 sysIDtime(end)])


            % Tile 4
            ax(2*i) = nexttile;
            stem(w1,abs(OutputDataCZT(index(:,1),2*i-1)),'Marker','o','MarkerSize',11,'MarkerFaceColor',[0 0.45 0.741])                                        % CZT Amplitude 頻域圖
            hold on
            stem(w2,abs(OutputDataCZT(index(:,2),2*i-1)),'Marker','square','MarkerSize',11,'MarkerFaceColor',[0.851 0.3294 0.102])
            hold on
            stem(w3,abs(OutputDataCZT(index(:,3),2*i-1)),'Marker','d','MarkerSize',11,'MarkerEdgeColor','none','MarkerFaceColor',[0 0.85 0.22])
            grid on
            set(ax(2*i),'Fontsize',20);
            set(ax(2*i-1),'Fontsize',20);
            xlim([0 w3(end)*1.1])
        end
        legend('\omega_1','\omega_2','\omega_3')
        xticklabels(ax(1),{})
        xticklabels(ax(2),{})
        xticklabels(ax(3),{})
        xticklabels(ax(4),{})
        xticklabels(ax(5),{})
        xticklabels(ax(6),{})
        xticklabels(ax(7),{})
        xticklabels(ax(8),{})
        xlabel(ax(end-1),'t (sec)')
        xlabel(ax(end),'frequency (Hz)')

        ylabel(ax(1),'\beta (deg)')
        ylabel(ax(3),'\itp (deg/s)')
        ylabel(ax(5),'\phi (deg)')
        ylabel(ax(7),'\psi (deg)')
        ylabel(ax(9),'\itr (deg/s)')

        ylabel(ax(2),'|\beta|')
        ylabel(ax(4),'|\itp|')
        ylabel(ax(6),'|\phi|')
        ylabel(ax(8),'|\psi|')
        ylabel(ax(10),'|\itr|')
end