% 本程式適用於MATLAB R2019b之後的版本，因使用繪圖指令： tiledlayout (Create tiled chart layout)

%正交相位優化多正弦輸入
%參考資料:2020 讚！Jared A. Grauer - Real-Time Estimation of Bare-Airframe Frequency Responses from Closed-Loop Data and Multisine Inputs
fs = 100;                                                              % 取樣頻率
T = 20;                                                                % 週期時間
a1 = 0.53;                                                             % 多正弦之振幅
a2 = 0.53;

t = transpose(0:(1/fs):T);
L = size(t,1);
freqBase = 1/T;                                                        % 基頻 (fundamental frequency)
tx = readmatrix('OPOMSI_MIMO_A1.xlsx');
% tx = readmatrix('OPOMSI_MIMO_EX2.3.1.xlsx');

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
for i=1:size(tx,1)
    u = a1 * sin( 2*pi*tx(i,1)*freqBase*t + tx(i,2));
    SSS(:,1) = u + SSS(:,1);
end
for i=1:size(tx,1)                                                   
    u = a2 * sin( 2*pi*tx(i,3)*freqBase*t + tx(i,4));                
    SSS(:,2) = u + SSS(:,2);
end
inputSignal=[t SSS];                                                 % sinmulink 的輸入訊號