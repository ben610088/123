% 本程式適用於MATLAB R2019a之後的版本，因使用到讀取 excel 檔案的指令： readmatrix() 

%正交相位優化多正弦輸入
%參考資料:2020 讚！Jared A. Grauer - Real-Time Estimation of Bare-Airframe Frequency Responses from Closed-Loop Data and Multisine Inputs
fs = 100;                                                              % 取樣頻率                    
T = 40;                                                            % 週期長度 (秒)

t = transpose(0:(1/fs):T);
L = size(t,1);
freqBase = 1/T;                                                        % 基頻 (fundamental frequency)

% tx = readmatrix('OPOMSI_MIMO_A3.xlsx'); 
tx = readmatrix('OPOMSI_MIMO_A2.xlsx'); 
%% 限制輸入訊號相位角介於 [ -2*pi   +2*pi ] 因為要跟輸出訊號相位角範圍互相搭配
for j=1:size(tx,2)/2
    for i=1:size(tx(:,1))
        if tx(i,2*j)>2*pi
            tx(i,2*j) = tx(i,2*j)-2*pi;
        elseif tx(i,2*j)<-2*pi
            tx(i,2*j) = tx(i,2*j)+2*pi;
        else
            tx(i,2*j) = tx(i,2*j);
        end
    end
end
%% Orthogonal Phase-Optimized Multisine Inputs
SSS =zeros(size(t,1) , size(tx,2)/2);                                  % 預先配置記憶體，初始化為零
for j=1:size(tx,2)/2
    for i=1:size(tx,1)
        u = sin( 2.*pi.*tx(i,2*j-1)*freqBase*t + tx(i,2*j));
        SSS(:,j) = u + SSS(:,j);
    end
end
% 對uj做正規化，使其最大振幅為1
for i = 1:size(SSS,2)
    SSS(:,i) = SSS(:,i)/max(abs(SSS(:,i)));
end
inputSignal=[t SSS];                                                   % sinmulink 的輸入訊號