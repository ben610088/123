sim(mdl,[0 simTime]);

% 繪圖
figure(1)
tiledlayout(size(tx,2),1);                  
for i=1:size(tx,2)/2 
    ax(i) = nexttile;
    plot(inputSignal(:,1),inputSignal(:,i+1),'b')                    % 繪製輸入時域圖 
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