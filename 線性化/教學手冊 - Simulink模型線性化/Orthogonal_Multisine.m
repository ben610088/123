% 本程式適用於MATLAB R2019b之後的版本，因使用繪圖指令： tiledlayout (Create tiled chart layout)

%正交相位優化多正弦輸入
%參考資料:2020 讚！Jared A. Grauer - Real-Time Estimation of Bare-Airframe Frequency Responses from Closed-Loop Data and Multisine Inputs
fs = 100;                                                              % 取樣頻率                    
T = 20;                                                                % 時間
a = 0.53;                                                              % 多正弦之震幅
t = transpose(0:(1/fs):T);
L = size(t,1);
freqBase = 1/T;                                                        % 基頻 (fundamental frequency)
simTime = t(end);                                                      % simulink 時間
mdl = 'T2_simulation_2020a';                                           % 指定要載入的 simulink model 的檔名

%% 製成對照表格，排序所有inputs的OPOMSI 
% 原始表格：[ k1  phi_k1  k2  phi_k2  k3  phi_k3 ... ]
% 輸出表格：[ k1  phi_k1;
%            k2  phi_k2;
%            k3  phi_k3;
%            ：    ：   ]
% tx=xlsread('OPOMSI_MIMO_2020.xlsx');
tx = xlsread('OPOMSI_MIMO_2020.xlsx');
temp = tx(:,1:2);
for i = 1:size(tx,2)/2-1
    temp = [temp;tx(:,2*i+1:2*i+2)];
end
temp = sortrows(temp);                                               % temp  = [ k  phi_k ]
temp2= [temp(:,1)*freqBase,temp(:,2)];                               % temp2 = [ Harmonic_Frequencies(Hz)  phi_k ]

%% 限制輸入訊號相位角介於 [ -2*pi   +2*pi ] 因為要跟輸出訊號相位角範圍互相搭配
for j=1:size(tx,2)/2
    for i=1:size(tx(:,1))
        if tx(i,2*j)>2*pi
            tx(i,2*j)=tx(i,2*j)-2*pi;
        elseif tx(i,2*j)<-2*pi
            tx(i,2*j)=tx(i,2*j)+2*pi;
        else
            tx(i,2*j)=tx(i,2*j);
        end
    end
end
%% Orthogonal Phase-Optimized Multisine Inputs
SSS =zeros(size(t,1) , size(tx,2)/2);
% for j=1:size(tx,2)/2
%     for i=1:size(tx,1)
%         u = a * sin( 2*pi*tx(i,2*j-1)*freqBase*t + tx(i,2*j));
%         SSS(:,j) = u + SSS(:,j);
%     end
% end
for i=1:size(tx,1)
    u = a * sin( 2*pi*tx(i,1)*freqBase*t + tx(i,2));
    SSS(:,1) = u + SSS(:,1);
end
for i=1:size(tx,1)                                                   
    u = a * sin( 2*pi*tx(i,3)*freqBase*t + tx(i,4));                % 配合文獻 u2 訊號顛倒
    SSS(:,2) = u + SSS(:,2);
end
inputSignal=[t SSS];                                                 % sinmulink 的輸入訊號