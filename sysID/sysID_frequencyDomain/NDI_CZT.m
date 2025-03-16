% 本程式適用於MATLAB R2019b之後的版本，因使用繪圖指令： tiledlayout (Create tiled chart layout)

% sysID_InputData.Data(:,1)    % elevator
% sysID_InputData.Data(:,6)    % TVC pitch

% sysID_InputData.Data(:,3)    % ailron
% sysID_InputData.Data(:,5)    % rudder
% sysID_InputData.Data(:,7)    % TVC yaw
 
% sysID_OutputData.Data(:,2)   % alpha
% sysID_OutputData.Data(:,8)   % q
% sysID_OutputData.Data(:,5)   % theta
% sysID_OutputData.Data(:,15)  % az

% sysID_OutputData.Data(:,1)   % v
% sysID_OutputData.Data(:,3)   % beta
% sysID_OutputData.Data(:,4)   % phi
% sysID_OutputData.Data(:,6)   % psi
% sysID_OutputData.Data(:,7)   % p
% sysID_OutputData.Data(:,9)   % r
% sysID_OutputData.Data(:,14)  % ay
switch test_case
    case 'sysID_longitudinal'
        sysIDInput_sim = [sysID_InputData.Data(:,1) sysID_InputData.Data(:,6)];
        sysIDOutput_sim = [sysID_OutputData.Data(:,2) sysID_OutputData.Data(:,15) sysID_OutputData.Data(:,8) sysID_OutputData.Data(:,5)];
        load('D:\NDI\long_Linearizerd.mat')
        w1 = tx(:,1).*freqBase;
        w2 = tx(:,3).*freqBase;

    case 'sysID_lateral'
        sysIDInput_sim = [sysID_InputData.Data(:,3) sysID_InputData.Data(:,5) sysID_InputData.Data(: ,7)];
        sysIDOutput_sim = [sysID_OutputData.Data(:,3) sysID_OutputData.Data(:,7) sysID_OutputData.Data(:,4) sysID_OutputData.Data(:,6) sysID_OutputData.Data(:,9)];
        load('D:\NDI\lat_Linearized.mat')
        w1 = tx(:,1).*freqBase;
        w2 = tx(:,3).*freqBase;
        w3 = tx(:,5).*freqBase;
end
% 注意：simulink 的 sysID_InputData 單位是 deg，要轉成 rad 運算
sysIDInput_sim = deg2rad(sysIDInput_sim);

% 系統識別實驗時間，3秒+T+20秒
sysIDInput_rawData  = sysIDInput_sim(sysID_OBES.start_time*fs+1:end,:);
sysIDOutput_rawData = sysIDOutput_sim(sysID_OBES.start_time*fs+1:end,:);

% 原始訊號數據去平均值和去趨勢 - 使用 detrend()指令
sysIDInput  = detrend(sysIDInput_rawData,4);
sysIDOutput = detrend(sysIDOutput_rawData,4);

% 原始訊號數據去平均值和去趨勢 - 使用 filter()指令 ... 失敗!!
% butter_fc = 0.15;
% butter_fs = 100;
% [filter_b,filter_a] = butter(4,butter_fc/(butter_fs/2),'high');
% sysIDInput  = filter(filter_b, filter_a, sysIDInput_rawData);  
% sysIDOutput = filter(filter_b, filter_a, sysIDOutput_rawData);  
%% CZT 參數          
cf1 = 0;                                                             % czt 初始頻率(Hz)
cf2 = 5;                                                             % czt 終止頻率(Hz)
m = 2000;                                                            % 取樣點數 (cf2-cf1)/m 必須整除....忘記為甚麼了
w0 = 1;                                                              % 螺旋曲率
a0 = 1;                                                              % 圓環半徑
FontSize = 11;                                                       % 圖的字體大小


w = w0 * exp(-1i*(2*pi*(cf2-cf1))/(m*fs));                           % 取樣點之間的比率
a = a0 * exp(1i*(2*pi*cf1)/fs);                                      % 取樣起點
frequency_interval = (cf2-cf1)/m;                                    % 頻率間隔
frequency = (cf1:frequency_interval :(cf2-frequency_interval ))';
%%
index = zeros(length(tx),size(tx,2)/2);
for i = 1:size(tx,2)/2
    index(:,i) = tx(:,2*i-1)*freqBase*m/(cf2-cf1)+1;                 % 取出諧波頻率的index = [ w1_index  w2_index ... wn_index ]
end
index = uint64(index);                                               % 將 index 從 double 轉為 整數  
%% CZT Inputs 
input_chy = zeros(m , size(tx,2)/2);
for i = 1:size(sysIDInput,2)
    input_chy(:,i) = czt(sysIDInput(:,i),m,w,a);                     % Chirp-Z Transform  
end

InputDataCZT = zeros(m ,size(tx,2));                                            
for i = 1:size(tx,2)/2                                               % [ Am_u1   Phi_u1   Am_u2   Phi_u2 ... ]
    InputDataCZT(:,2*i-1) = abs(input_chy(:,i))./(L/2);
    InputDataCZT(:,2*i) = angle(input_chy(:,i));
end
%% CZT Outputs         
output_chy = zeros(m , size(sysIDOutput,2));
for i = 1:size(sysIDOutput,2)
    output_chy(:,i) = czt(sysIDOutput(:,i),m,w,a);                   % Chirp-Z Transform
end
OutputDataCZT = zeros(m ,size(sysIDOutput,2)*2);                                            
for i = 1:size(sysIDOutput,2)                                        % [ Am_y1   Phi_y1   Am_y2   Phi_y2 ... ]
    OutputDataCZT(:,2*i-1) = abs(output_chy(:,i))./(L/2);
    OutputDataCZT(:,2*i) = angle(output_chy(:,i));
end