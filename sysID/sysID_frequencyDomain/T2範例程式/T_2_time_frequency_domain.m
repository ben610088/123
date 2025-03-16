%% 繪製輸入、輸出的時域和頻域圖
% Requires R2019b or later
figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'WindowState','maximized');
% 'TileSpacing','Compact' 最小化繪圖之間的空間。'Padding','Compact' 最小化佈局周圍的空間
tiledlayout(4,2,'TileSpacing','Compact','Padding','Compact');
for i=1:size(tx,2)/2
    % Tile 1
    ax(2*i-1) = nexttile;
    plot(mu.Time,mu.Data(:,i),'b')                    % 繪製輸入 u 的時域圖 
    grid on

    % Tile 2
    ax(2*i) = nexttile;
    stem(w1,abs(InputDataCZT(index(:,1),2*i-1)),'Marker','o','MarkerSize',11,'MarkerFaceColor',[0 0.45 0.741])                                        % CZT Amplitude 頻域圖
    hold on
    stem(w2,abs(InputDataCZT(index(:,2),2*i-1)),'Marker','square','MarkerSize',11,'MarkerFaceColor',[0.851 0.3294 0.102])
    grid on
    % title(ax(2),['Chirp-Z Transform u' num2str(i)]);
    set(ax(2*i-1),'Fontsize',20);
    set(ax(2*i),'Fontsize',20);
end


for i=1:size(tx,2)/2
    % Tile 3
    ax(2*i-1+4) = nexttile;
    plot(sysIDOutput.Time,sysIDOutput.Data(:,i),'b')                  % 繪製輸出 y 的時域圖
    grid on
    % Tile 4
    ax(2*i+4) = nexttile;
    stem(w1,abs(OutputDataCZT(index(:,1),2*i-1)),'Marker','o','MarkerSize',11,'MarkerFaceColor',[0 0.45 0.741])                                        % CZT Amplitude 頻域圖
    hold on
    stem(w2,abs(OutputDataCZT(index(:,2),2*i-1)),'Marker','square','MarkerSize',11,'MarkerFaceColor',[0.851 0.3294 0.102])
    grid on
    set(ax(2*i-1+4),'Fontsize',20);
    set(ax(2*i+4),'Fontsize',20);
end
xt = xticks(ax(end-1));
xt1 = xticks(ax(end));
for i = 1:size(ax,2)/2-1
    xticklabels(ax(2*i-1),{})
    xticklabels(ax(2*i),{})
    xticks(ax(2*i-1),xt)
    xticks(ax(2*i),xt1)
end
ylabel(ax(1),'\delta_e_o (deg)');
ylabel(ax(3),'\delta_e_i (deg)');
ylabel(ax(5),'\itq (deg/s)');
ylabel(ax(7),'\ita_z (deg/s^2)');
ylabel(ax(2),'|\delta_e_o|');
ylabel(ax(4),'|\delta_e_i|');
ylabel(ax(6),'|\itq|');
ylabel(ax(8),'|\ita_z|');
xlabel(ax(end-1),'t (sec)');
xlabel(ax(end),'Frequency (Hz)');
