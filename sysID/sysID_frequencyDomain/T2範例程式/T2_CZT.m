% 本程式適用於MATLAB R2019b之後的版本，因使用繪圖指令： tiledlayout (Create tiled chart layout)
%% CZT 參數
cf1 = 0;                                                             % czt 初始頻率(Hz)
cf2 = 2;                                                             % czt 終止頻率(Hz)
m = 2000;                                                            % 取樣點數 (cf2-cf1)/m 必須整除....忘記為甚麼了
w0 = 1;                                                              % 螺旋曲率
a0 = 1;                                                              % 圓環半徑
FontSize = 11;                                                       % 圖的字體大小


w = w0 * exp(-1i*(2*pi*(cf2-cf1))/(m*fs));                           % 取樣點之間的比率
a = a0 * exp(1i*(2*pi*cf1)/fs);                                      % 取樣起點
frequency_interval = (cf2-cf1)/m;                                    % 頻率間隔
frequency = (cf1:frequency_interval :(cf2-frequency_interval ))';
%%
index = [tx(:,1)*freqBase*m/(cf2-cf1)+1,tx(:,3)*freqBase*m/(cf2-cf1)+1];       % 取出諧波頻率的index = [ w1_index  w2_index ]
index = uint64(index);                                                         % 將 index 從 double 轉為 整數

% ******************************
w1 = tx(:,1).*freqBase;
w2 = tx(:,3).*freqBase;
ww = [w1 w2];
% ******************************
%% CZT Inputs
input_chy = zeros(m , size(tx,2)/2);
for i = 1:size(tx,2)/2
    input_chy(:,i) = czt(sysIDInput.Data(:,i),m,w,a);                  % Chirp-Z Transform
end

InputDataCZT = zeros(m ,size(tx,2));
for i = 1:size(tx,2)/2                                                 % [ Am_u1   Phi_u1   Am_u2   Phi_u2 ... ]
    InputDataCZT(:,2*i-1) = abs(input_chy(:,i))./(L/2);
    InputDataCZT(:,2*i) = angle(input_chy(:,i));
end
%% CZT Outputs
output_chy = zeros(m , size(tx,2)/2);
for i = 1:size(tx,2)/2
    output_chy(:,i) = czt(sysIDOutput.Data(:,i),m,w,a);                  % Chirp-Z Transform
end
OutputDataCZT = zeros(m ,size(tx,2));
for i = 1:size(tx,2)/2                                                 % [ Am_y1   Phi_y1   Am_y2   Phi_y2 ... ]
    OutputDataCZT(:,2*i-1) = abs(output_chy(:,i))./(L/2);
    OutputDataCZT(:,2*i) = angle(output_chy(:,i));
end