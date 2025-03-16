% sim(mdl,[0 simTime]);

% 繪圖
figure(1)
tiledlayout(1,1);                  
% for i=1:1
%     ax(i) = nexttile;
%     plot(mu.Time,mu.Data(:,i),'b')                    % 繪製輸入時域圖 
%     xlabel('t(s)');
%     ylabel('u(t)'); 
% end



figure(1)
tiledlayout(size(tx,2),1);                  
for i=1:size(tx,2)/2 
    ax(i) = nexttile;
    plot(mu.Time,mu.Data(:,i),'b')                    % 繪製輸入時域圖 
    xlabel('t(s)');
    ylabel(['u' num2str(i) '(t)']); 
end
title(ax(1),'time domain inputs');
for i=1:size(tx,2)/2 
    ax(i+2) = nexttile;
    plot(sysIDOutput.Time,sysIDOutput.Data(:,i),'b')                  % 繪製輸出時域圖 
    xlabel('t(s)');
    ylabel(['y' num2str(i) '(t)']); 
end
set(ax1,'Fontsize',20);


% 2.4.1數值範例
% figure('units','normalized','outerposition',[0 0 1 1])
% % set(gcf,'Position',get(0,'ScreenSize'))
% set(gcf,'WindowState','maximized');
% tiledlayout(2,1,'TileSpacing','Compact','Padding','Compact');                  
% for i=1:size(tx,2)/2 
%     ax(i) = nexttile;
%     plot(t,SSS(:,i),'b')                    % 繪製輸入時域圖 
%     ylabel(['u' num2str(i) '(t)']); 
% end
% xlabel(ax(2),'t(s)');
% xticklabels(ax(1),{})
% set(ax(1),'Fontsize',20);
% set(ax(2),'Fontsize',20);

