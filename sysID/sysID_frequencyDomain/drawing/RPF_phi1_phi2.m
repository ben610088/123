%% 繪製phi1,phi2與RPF的3D圖
clc,clear,close all
fs = 100;                                                                  
T = 20;
t = transpose(0:(1/fs):T); 
tiledlayout(1,1,'TileSpacing','Compact','Padding','Compact');
x = 0:0.0175*3:pi;		 
y = 0:0.0175*3:pi;		  
[xx,yy] = meshgrid(x, y);		
for i = 1:length(x)
    for j = 1:length(y) 
        zz(i,j) = (max(sin( 2*pi*2*t/T + xx(i))+sin( 2*pi*4*t/T + yy(j)))-min(sin( 2*pi*2*t/T + xx(i))+sin( 2*pi*4*t/T + yy(j))))/(2*sqrt(2)*rms(sin( 2*pi*2*t/T + xx(i))+sin( 2*pi*4*t/T + yy(j))));
    end
end
surf(xx, yy, zz);				% 畫出立體曲面圖  
colormap('colormap')
xlabel('\phi2')
ylabel('\phi1')
zlabel('RPF')