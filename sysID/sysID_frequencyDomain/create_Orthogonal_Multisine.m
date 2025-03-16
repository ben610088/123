% 本程式適用於MATLAB R2019a之後的版本，因使用到讀取 excel 檔案的指令： readmatrix() 

%正交相位優化多正弦輸入
%參考資料:2020 讚！Jared A. Grauer - Real-Time Estimation of Bare-Airframe Frequency Responses from Closed-Loop Data and Multisine Inputs
fs = 100;                                                              % 取樣頻率                    
% T = 20;                                                              % 週期長度 (秒)
T = 40;
t = transpose(0:(1/fs):T);
L = size(t,1);
freqBase = 1/T;                                                        % 基頻 (fundamental frequency)


% tx = readmatrix('OPOMSI_MIMO_2020.xlsx');                % MATLAB R2019a 才有的指令，讀取 excel 檔案的指令
% tx = readmatrix('OPOMSI_MIMO_2018.xlsx');                % MATLAB R2019a 才有的指令，讀取 excel 檔案的指令
% tx = readmatrix('OPOMSI_MIMO_2014.xlsx');  
% tx = readmatrix('OPOMSI_MIMO_RPF_1.06_1.09.xlsx'); 
% tx = readmatrix('OPOMSI_MIMO_RPF_1.12_1.18.xlsx'); 
tx = readmatrix('OPOMSI_MIMO_RPF_u3_M_30.xlsx'); 
% tx = readmatrix('OPOMSI_MIMO_RPF_1.17_1.30_M_60.xlsx'); 
% tx = readmatrix('EX_2.4.1.xlsx');

%% 製成對照表格，排序所有inputs的OPOMSI 
% 原始表格：[ k1  phi_k1  k2  phi_k2  k3  phi_k3 ... ]
% 輸出表格：[ k1  phi_k1;
%            k2  phi_k2;
%            k3  phi_k3;
%            ：    ：   ]
% tx = readmatrix('OPOMSI_MIMO_2020.xlsx');
% temp = zeros(size(tx,1)*size(tx,2)/2,2);
% temp(1:size(tx,1),:) = tx(:,1:2);
% for i = 1:size(tx,2)/2-1
%     temp(end/2+1:end,:) = tx(:,2*i+1:2*i+2);
% end
% temp = sortrows(temp);                                               % temp  = [ k  phi_k ]
% temp2= [temp(:,1)*freqBase,temp(:,2)];                               % temp2 = [ Harmonic_Frequencies(Hz)  phi_k ]

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