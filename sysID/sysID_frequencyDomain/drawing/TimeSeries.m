t = 0:0.01:110;
x = [0 50 50 90 90 110];
y = [0 0 1 1 0 0];
z = zeros(2000,1);
aa = [sysID_InputData.Data(:,3);z];
bb = [sysID_InputData.Data(:,5);z];
cc = [sysID_OutputData.Data(:,3);z];
dd = [sysID_OutputData.Data(:,7);z];



figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'WindowState','maximized');
% 'TileSpacing','Compact' 最小化繪圖之間的空間。'Padding','Compact' 最小化佈局周圍的空間
tt = tiledlayout(5,1,'TileSpacing','Compact','Padding','Compact');
ax1 = nexttile;
plot(x,y,'b','LineWidth',3)
ylabel('Enable')
xlim([0 110]);
ax2 = nexttile;
plot(t,aa)
ylabel('\it\delta_a (deg)')
xlim([0 110]);
ax3 = nexttile;
plot(t,bb)
ylabel('\it\delta_r (deg)')
xlim([0 110]);
ax4 = nexttile;
plot(t,cc)
ylabel('\beta (deg)')
xlim([0 110]);
ax5 = nexttile;
plot(t,dd)
ylabel('\itp (deg)')
xlabel('t (sec)')
xlim([0 110]);
xticklabels(ax1,{})
xticklabels(ax2,{})
xticklabels(ax3,{})
xticklabels(ax4,{})
set(ax1,'Fontsize',20);
set(ax2,'Fontsize',20);
set(ax3,'Fontsize',20);
set(ax4,'Fontsize',20);
set(ax5,'Fontsize',20);


