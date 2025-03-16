figure()
% 'TileSpacing','Compact' 最小化繪圖之間的空間。'Padding','Compact' 最小化佈局周圍的空間
t = tiledlayout(1,1,'TileSpacing','Compact','Padding','Compact');
ax1 = nexttile;
x=tx(:,1).*freqBase;
y1=1;
for i = 1:length(tx)-1
    y1(i+1)=y1(i);
end
y2=1;
for i = 1:length(tx)-1
    y2(i+1)=y2(i);
end
bar(x,y1,0.3,'r')
hold on
x2=tx(:,3).*freqBase;
bar(x2,y2,0.3,'g')
ylim([0 1.2])
xlabel('frequency (Hz)')
ylabel('a_n')
legend('u1','u2')
set(ax1,'Fontsize',20);