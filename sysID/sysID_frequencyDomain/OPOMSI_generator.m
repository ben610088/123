clear, clc            
fs = 100;                                                                  % 取樣頻率   
T = 40;                                                                    % 週期長度 (秒)  
fss = 1000000;                                                               % 尋找零交叉的取樣頻率

% P = [8.96];                                                                 % 均勻功率[u1_a u2_a... un_a]
M = 60;                                                                    % 頻率個數
uj_k0 = [3];                                                             % 頻率的索引起始點：[u1_k u2_k... un_k]
k_interval = 2;                                                            % 索引間隔
WW = 1.2;                                                                 % RPF 搜索範圍界於 2-WW < RPF < WW
iterations_number = 50;                                                     % 迭代次數

t = transpose(0:(1/fs):T);                                                 % 時間
A = [];                                                                    % 線性不等式約束函數係數  若無約束則用[]表示
b = [];                                                                    % 線性不等式約束函數常數
Aeq = [];                                                                  % 線性等式約束函數係數
beq = [];                                                                  % 線性等式約束函數常數
lb = -pi*ones(1,M);                                                        % 下界
ub = pi*ones(1,M);                                                         % 上界

k = uj_k0;                                                                    % 頻率的索引值
for i = 1:M-1
    k(i+1,:) = k(i,:) + k_interval ;
end

phi0 = zeros(M,1);                                                         % 相位角的初始值
for i = 1:length(k)-1
    phi0(i+1,1) = phi0(i,1) - pi * k(i,1)^2 / M;
end
Phi = zeros(M,length(uj_k0));
RPF = zeros(1,length(uj_k0));
for i = 1:length(uj_k0)
    [Phi(:,i), RPF(:,i)] = fmincon(@(phi) objectiveFcn(phi,fs,T,t,k(:,i)),phi0,A,b,Aeq,beq,lb,ub);
end




r = zeros(M,length(uj_k0));
for ii = 1:iterations_number                                               % 迭代
    if iterations_number == 1
    else
        for j = 1:length(uj_k0)
            r(:,j) = -2*pi+4*pi.*rand(M,1);                                % 將優化解 Phi 加入界於[-2pi 2pi]的隨機值，做迭代
            phi0(:,j) = Phi(:,j)+r(:,j);
            [Phi(:,j), RPF(:,j)] = fmincon(@(phi) objectiveFcn(phi,fs,T,t,k(:,j)),phi0(:,j),A,b,Aeq,beq,lb,ub);
        end
        fprintf('RPF = %d',RPF)     
    end
    if RPF(:,length(uj_k0)) < WW && RPF(:,length(uj_k0)) > 2-WW
        break
    end
end
% --------------------------------------------------------------------------------------

fprintf('迭代次數 = %d' ,ii)
fprintf('\n RPF = %d',RPF)
% ----------------------------------
uj = zeros(length(t),length(uj_k0));
temp = zeros(length(t),length(uj_k0));
for j = 1:length(uj_k0)
    for i = 1:length(k)
     temp(:,j) = sin( 2*pi*k(i,j)*t/T + Phi(i,j));
      uj(:,j) = temp(:,j) + uj(:,j);
    end
end
%%
t = transpose(0:(1/fss):T);                                                % 使用更小的取樣頻率fss，找到更接近零交叉的點
uj = zeros(length(t),length(uj_k0));
temp = zeros(length(t),length(uj_k0));
for j = 1:length(uj_k0)
    for i = 1:length(k)
     temp(:,j) = sin( 2*pi*k(i,j)*t/T + Phi(i,j));
      uj(:,j) = temp(:,j) + uj(:,j);
    end
end

v = 0;
[~,Index] = min(abs(uj(:,1:length(uj_k0))-v));                                % Index = uj中最接近 0 的值的索引
Index = Index';
phase_lag = t(Index)*2*pi/T;
for j = 1:length(uj_k0)
    for i = 1:M                                                            % 時間軸滑動輸入，直到在時間軸的原點放置零交叉
        Phi(i,j) = Phi(i,j) + phase_lag(j,:) * k(i,j);                     % 每個頻率的波形之相位偏移將不同，因為具有不同的頻率
    end
end
% ----------------------------------
uj = zeros(length(t),length(uj_k0));
for j = 1:length(uj_k0)
    for i = 1:length(k)
     temp(:,j) = sin( 2*pi*k(i,j)*t/T + Phi(i,j));
      uj(:,j) = temp(:,j) + uj(:,j);
    end
end
%%
for i = 1:length(Phi)
    if Phi(i)>2*pi
        Phi(i)= Phi(i)-2*pi;
    elseif Phi(i)<-2*pi
        Phi(i)= Phi(i)+2*pi;
    else
    end
end
figure(1)
tiledlayout(length(uj_k0),1,'TileSpacing','Compact','Padding','Compact');       
for i=1:length(uj_k0)
    ax(i) = nexttile;
    plot(t,uj(:,i),'b')                                                    % 繪製輸入時域圖 
    xlabel('t(s)');
    ylabel(['u' num2str(i) '(t)']); 
end
title(ax(1),'time domain inputs');
set(ax(1),'Fontsize',20);
%%
for i = 1:length(Phi)
    if Phi(i,1)>2*pi
        Phi(i,1) = Phi(i,1)-2*pi;
    end
end